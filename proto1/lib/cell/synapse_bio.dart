import 'dart:math';

import 'package:proto1/model/synapse_model.dart';

import '../cell/soma.dart';

import '../model/appstate.dart';
import '../model/model.dart';
import '../stimulus/ibit_stream.dart';
import 'compartment_bio.dart';
import 'dendrite_bio.dart';

class SynapseBio {
  // Properties
  late AppState appState;

  late Soma soma;
  late DendriteBio dendrite;
  late CompartmentBio compartment;

  int id = 0;

  SynapseBio(AppState appState);

  // true = excititory, false = inhibitory
  bool excititory = false;

  // The weight of the synapse
  double w = 0;
  double initialW = 0;

  double wMax = 0;
  double wMin = 0;

  // The stream (aka Merger) that feeds into this synapse
  late IBitStream stream;

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // new surge ion concentration
  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // concentration base. We should always have a minimum concentration
  // as a result of a spike
  // Surge is calculated at the arrival of a spike
  // surge = amb - ama*e^(-psp/tsw) == rising curve
  double surge = 0;

  // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  // The time-mark at which a spike arrived at a synapse
  double preT = 0;

  // The current ion concentration
  double psp = 0;

  // -----------------------------------
  // Weight dependence
  // -----------------------------------
  // F-(w) = λ⍺w^µ, F+(w) = λ(1-w)^µ

  // -----------------------------------
  // Suppression
  // -----------------------------------
  double prevEffTrace = 0;

  // -----------------------------------
  // Fall off
  // -----------------------------------
  double distanceEfficacy = 0;

  // The farther the synapse is from the Soma the less of an influence
  // this synapse has. The function can either be linear or non-linear.
  // The default is linear.
  // Note: no matter how far a synapse is it will still have an influence
  // otherwise it's useless.
  // distance's value = 1.0 for synapses closest to soma. The farther out
  // the value reaches a minimum of around ~0.25.
  // distance is multiplied into soma.psp.

  // =============================================================
  // Learning rules:
  // =============================================================
  // Depression pair-STDP, Potentiation is triplet.
  // "tao"s control the rate of decay. Larger values means a slower decay.
  // Smaller values equals a sharper decay.

  // These are the current values for this synapse. It initialized
  // with starter values via initialize.
  Synapse bio = Synapse.create();

  factory SynapseBio.create(
    AppState appState,
    int id,
    Soma soma,
    DendriteBio dendrite,
    CompartmentBio compartment,
  ) {
    SynapseBio syn = SynapseBio(appState)
      ..id = id
      ..soma = soma
      ..dendrite = dendrite
      ..compartment = compartment;

    syn.compartment.addSynapse(syn);

    return syn;
  }

  // Initialize this synapse from the synapses persistence.
  void initialize(SynapsesModel synapses) {
    Synapse syn = synapses.synapses[id];

    bio.excititory = bio.excititory;
    bio.taoP = bio.taoP;
    bio.taoN = bio.taoN;
    bio.mu = bio.mu;
    bio.distance = bio.distance;
    bio.lambda = bio.lambda;
    bio.amb = bio.amb;
    bio.w = bio.w;
    bio.alpha = bio.alpha;
    bio.learningRateSlow = bio.learningRateSlow;
    bio.learningRateFast = bio.learningRateFast;
    bio.taoI = bio.taoI;
    bio.ama = bio.ama;

    initialW = bio.w;
    w = bio.w;
    excititory = bio.excititory;

    // Calc this synapses's reaction to the AP based on its
    // distance from the soma.
    distanceEfficacy = dendrite.aPEfficacy(bio.distance);
  }

  // Reset resets for another sim pass
  void reset() {
    prevEffTrace = 1.0;
    distanceEfficacy = 0.0;
    surge = 0.0;
    psp = 0.0;
    preT = 0.0;

    Model model = appState.model;
    Compartment comp = model.neuron.dendrite.compartment;

    wMax = comp.weightMax;
    wMin = comp.weightMin;
  }

  // Integrate is the actual integration
  double integrate(int spanT, int t) {
    return tripleIntegration(spanT, t);
  }

  // TripleIntegration advanced
  // =============================================================
  // Triplet:
  // =============================================================
  // Pre trace, Post slow and fast traces.
  //
  // Depression: fast post trace with at pre spike
  // Potentiation: slow post trace at post spike
  double tripleIntegration(int spanT, int t) {
    double value = 0.0;

    // Calc psp based on current dynamics: (t - preT). As dt increases
    // psp will decrease asymtotically to zero.
    double dt = t.toDouble() - preT;

    double dwD = 0.0;
    double dwP = 0.0;
    bool updateWeight = false;

    // The output of the stream is the input to this synapse.
    if (stream.output() == 1) {
      // A spike has arrived on the input to this synapse.
      // fmt.Printf("(%d) at %d\n", s.id, t)

      if (excititory) {
        surge = psp + bio.ama * exp(-psp / bio.taoP);
      } else {
        surge = psp + bio.ama * exp(-psp / bio.taoN);
      }

      // #######################################
      // Depression (LTD). This may not be correct.
      // #######################################
      // Read post trace and adjust weight accordingly.
      dwD = prevEffTrace * weightFactor(false) * soma.apFast;

      prevEffTrace = efficacy(dt);

      preT = t.toDouble();
      dt = 0.0;

      updateWeight = true;
    }

    return value;
  }

  // WeightFactor mu = 0.0 = additive, mu = 1.0 = multiplicative
  double weightFactor(bool potentiation) {
    if (potentiation) {
      return bio.lambda * pow(1.0 - w.abs() / wMax, bio.mu);
    }

    return bio.lambda * bio.alpha * pow(w.abs() / wMax, bio.mu);
  }

  // Efficacy : each spike of pre-synaptic neuron j sets the presynaptic spike
  // efficacy j to 0
  // whereafter it recovers exponentially to 1 with a time constant
  // τj = toaJ
  // In other words, the efficacy of a spike is suppressed by
  // the proximity of a trailing spike.
  double efficacy(double dt) {
    return 1.0 - exp(-dt / bio.taoI);
  }
}
