// This manages the simulation including running it and generating
// output that can be shown in the graphs.
// The output is captured in structures for rendering.

import 'dart:math';

import 'package:flutter/foundation.dart';

import '../cell/synapse_bio.dart';
import '../cell/axon.dart';
import '../cell/axon_zero_delay.dart';
import '../cell/compartment_bio.dart';
import '../cell/neuron_bio.dart';
import '../misc/maths.dart';
import '../stimulus/poisson_stream.dart';
import '../cell/dendrite_bio.dart';
import '../cell/soma.dart';
import '../model/appstate.dart';
import '../model/environment.dart';
import '../model/model.dart';
import '../samples/samples.dart';
import '../stimulus/ibit_stream.dart';
import '../stimulus/stimulus_stream.dart';

class NeuronSimulation {
  late AppState appState;

  int t = 0;
  late NeuronBio neuron;

  bool running = false;
  bool _step = false;

  int seed = 5000;

  NeuronSimulation();

  factory NeuronSimulation.create(AppState appState) {
    NeuronSimulation simulation = NeuronSimulation();
    simulation.appState = appState;
    return simulation;
  }

  void build() {
    // -----------------------------------------------------------------
    // First we create the Noise (Poisson) streams. Each stream will
    // be routed to a unique synapse. We need a collection of them so
    // we can exercise them on each simulation step.
    Model model = appState.model;
    Environment environment = appState.environment;

    _buildNoise(seed);
    if (kDebugMode) {
      print("Poisson Noise streams created");
    }

    // -----------------------------------------------------------------
    // Now create the stimulus streams
    for (int i = 0; i < environment.stimulusStreamCnt; i++) {
      List<int> stimList = environment.expandedStimulus[i];

      StimulusStream ss = StimulusStream.create(stimList, model.hertz);

      environment.stimuli.add(ss);
    }

    if (kDebugMode) {
      print("Stimulus streams created");
    }

    Samples samples = appState.samplesData.samples;

    // -----------------------------------------------------------------
    // Create cell dependencies starting with soma first.
    CompartmentBio compartment = CompartmentBio();

    DendriteBio dendrite = DendriteBio(appState)..compartments.add(compartment);

    Soma soma = Soma.create(appState, samples)..dendrite = dendrite;

    Axon axon = AxonZeroDelay();
    soma.setAxon(axon);

    // Incrementing IDs
    int genSynID = 0;

    // -----------------------------------------------------------------
    // Stimulus
    // We need a synapse for each stream. First is stimulas
    // on the lower 10 synaptic inputs.
    for (var stimulus in environment.stimuli) {
      SynapseBio synapse = SynapseBio.create(
        appState,
        genSynID,
        soma,
        dendrite,
        compartment,
      );

      // route noise to synapse
      synapse.stream = stimulus;
      synapse.initialize();
      environment.synapses.add(synapse);
      genSynID++;
    }

    // -----------------------------------------------------------------
    // Noise
    // The rest of the inputs are noise
    for (var noise in environment.noises) {
      SynapseBio synapse = SynapseBio.create(
        appState,
        genSynID,
        soma,
        dendrite,
        compartment,
      );

      // route noise to synapse
      synapse.stream = noise;
      synapse.initialize();
      environment.synapses.add(synapse);
      genSynID++;
    }

    // -----------------------------------------------------------------
    // Now create the single Neuron that this simulation execises
    neuron = NeuronBio.create(appState, soma);
    neuron.initialize();
  }

  void run() {
    reset();

    int time = 0;
    for (var i = 0; i < appState.configModel.duration; i++) {
      time = step(time);
      if (!_step) {
        break;
      }
    }

    appState.samplesData.update();

    if (kDebugMode) {
      print('Run complete');
    }
  }

  void reset() {
    t = 0;

    neuron.reset(appState.model);
    Environment environment = appState.environment;
    Model model = appState.model;

    int seedo = seed;
    for (var noise in environment.noises) {
      noise.configure(seed: seedo, lambda: model.noiseLambda);
      noise.reset();
      seedo += 5000;
    }

    for (var stimulus in environment.stimuli) {
      stimulus.reset();
    }

    appState.samplesData.samples.reset();

    // Set initial values for each synapse: Presets, Current or Random?
    switch (environment.initialWeights) {
      case 0: // Presets
        synapsePresets();
      case 2: // Random
        synapseWeightRandomizer();
    }

    if (environment.initialWeightValues != 1) {
      // Now transfer model to synapses
      for (var synapse in environment.synapses) {
        synapse.initialize();
      }
    }

    // Warm up the noise
    for (var i = 0; i < 1000; i++) {
      for (var noise in environment.noises) {
        noise.step();
      }
    }
  }

  void _buildNoise(int seed) {
    Model model = appState.model;
    Environment environment = appState.environment;
    environment.noises.clear();

    for (int i = 0; i < model.noiseCount; i++) {
      IBitStream noise = PoissonStream.create(seed, model.noiseLambda);
      environment.noises.add(noise);
      seed += 5000;
    }
  }

  int step(int time) {
    bool complete = simulate(time, appState.configModel.duration);
    // if (complete) {
    //   reset();
    // }
    time++;
    _step = !complete;

    return time;
  }

  bool simulate(int t, int duration) {
    neuron.integrate(0, t);
    Environment environment = appState.environment;

    // Step all streams. This causes each stream to update and move
    // its internal value to its output for the next integration.
    for (var noise in environment.noises) {
      noise.step();
    }

    for (var stimulus in environment.stimuli) {
      stimulus.step();
    }

    neuron.step();

    return t > duration;
  }

  // Assigns the same presets to all syn....
  void synapsePresets() {
    Environment environment = appState.environment;
    Model model = appState.model;
    Synapse defaults = model.neuron.dendrite.compartment.synapse;

    for (var synapse in environment.synapses) {
      synapse.bio.taoP = defaults.taoP;
      synapse.bio.taoN = defaults.taoN;
      synapse.bio.mu = defaults.mu;
      synapse.bio.distance = defaults.distance;
      synapse.bio.lambda = defaults.lambda;
      synapse.bio.amb = defaults.amb;
      synapse.bio.w = defaults.w;
      synapse.bio.alpha = defaults.alpha;
      synapse.bio.learningRateSlow = defaults.learningRateSlow;
      synapse.bio.learningRateFast = defaults.learningRateFast;
      synapse.bio.taoI = defaults.taoI;
      synapse.bio.ama = defaults.ama;
    }
  }

  void synapseWeightRandomizer() {
    Environment environment = appState.environment;

    // Use the Min/Max values to bound the Lerp
    double min = environment.minRangeValue;
    double max = environment.maxRangeValue;
    double center = environment.centerRangeValue;

    Random rando = Random();
    for (var synapse in environment.synapses) {
      double l = Maths.linear(min, max, center);
      double r = rando.nextDouble();

      if (r > l) {
        // Center -> Max wins
        synapse.bio.w = Maths.lerp(center, max, rando.nextDouble());
        continue;
      }

      // Min -> Center wins
      synapse.bio.w = Maths.lerp(min, center, rando.nextDouble());
    }
  }
}
