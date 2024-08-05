// This manages the simulation including running it and generating
// output that can be shown in the graphs.
// The output is captured in structures for rendering.

import 'package:flutter/foundation.dart';
import 'package:proto1/cell/synapse_bio.dart';

import '../cell/axon.dart';
import '../cell/axon_zero_delay.dart';
import '../cell/compartment_bio.dart';
import '../cell/neuron_bio.dart';
import '../stimulus/poisson_stream.dart';
import '../cell/dendrite_bio.dart';
import '../cell/soma.dart';
import '../model/appstate.dart';
import '../model/environment.dart';
import '../model/model.dart';
import '../samples/samples.dart';
import '../stimulus/ibit_stream.dart';
import '../stimulus/stimulus_stream.dart';

class Simulation {
  late AppState appState;

  // Noise streams
  List<IBitStream> noises = [];

  // Stimulus
  List<IBitStream> stimuli = [];

  int t = 0;

  bool running = false;
  bool step = false;

  Simulation();

  factory Simulation.create(AppState appState) {
    Simulation simulation = Simulation();

    return simulation;
  }

  void build() {
    // -----------------------------------------------------------------
    // First we create the Noise (Poisson) streams. Each stream will
    // be routed to a unique synapse. We need a collection of them so
    // we can exercise them on each simulation step.
    int seed = 5000;
    Model model = appState.model;
    for (int i = 0; i < model.noiseCount; i++) {
      IBitStream noise = PoissonStream.create(seed, model.noiseLambda);
      noises.add(noise);
      seed += 5000;
    }
    if (kDebugMode) {
      print("Poisson Noise streams created");
    }

    // -----------------------------------------------------------------
    // Now create the stimulus streams
    Environment environment = appState.environment;
    for (int i = 0; i < environment.stimulusStreamCnt; i++) {
      List<int> stimList = environment.expandedStimulus[i];

      StimulusStream ss = StimulusStream.create(stimList, model.hertz);

      stimuli.add(ss);
    }

    if (kDebugMode) {
      print("Stimulus streams created");
    }

    Samples samples = environment.samples;

    // -----------------------------------------------------------------
    // Create cell dependencies starting with soma first.
    Soma soma = Soma.create(appState, samples);

    DendriteBio dendrite = DendriteBio(appState);
    soma.dendrite = dendrite;

    CompartmentBio compartment = CompartmentBio();

    Axon axon = AxonZeroDelay();
    soma.setAxon(axon);

    // Incrementing IDs
    int genSynID = 0;

    // -----------------------------------------------------------------
    // We need a synapse for each stream, both Noise and Stimulus
    for (var stimulus in stimuli) {
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
    for (var noise in noises) {
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
    NeuronBio neuron = NeuronBio.create(appState, soma);
    neuron.initialize();
  }

  void run() {}
}
