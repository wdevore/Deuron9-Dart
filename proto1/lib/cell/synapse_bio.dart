import 'dart:math';

import '../model/config_model.dart';
import '../model/environment.dart';
import '../cell/soma.dart';
import '../model/appstate.dart';
import '../model/model.dart';
import '../stimulus/ibit_stream.dart';
import 'compartment_bio.dart';
import 'dendrite_bio.dart';

class SynapseBio {
  // Properties
  AppState appState;
  late ConfigModel configModel;
  late Environment environment;

  late Soma soma;
  late DendriteBio dendrite;
  late CompartmentBio compartment;

  int id = 0;

  SynapseBio(this.appState);

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
  // this synapse ha The function can either be linear or non-linear.
  // The default is linear.
  // Note: no matter how far a synapse is it will still have an influence
  // otherwise it's useles
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
    syn.configModel = appState.configModel;
    syn.environment = appState.environment;

    return syn;
  }

  // Initialize this synapse from the synapses persistence.
  void initialize() {
    Synapse syn = appState.environment.synapsesModel.synapses[id];

    bio.excititory = syn.excititory;
    bio.taoP = syn.taoP;
    bio.taoN = syn.taoN;
    bio.mu = syn.mu;
    bio.distance = syn.distance;
    bio.lambda = syn.lambda;
    bio.amb = syn.amb;
    bio.w = syn.w;
    bio.alpha = syn.alpha;
    bio.learningRateSlow = syn.learningRateSlow;
    bio.learningRateFast = syn.learningRateFast;
    bio.taoI = syn.taoI;
    bio.ama = syn.ama;

    initialW = syn.w;
    w = syn.w;
    excititory = syn.excititory;

    // Calc this synapses's reaction to the AP based on its
    // distance from the soma.
    distanceEfficacy = dendrite.aPEfficacy(syn.distance);
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
    return tripleIntegration(t);
  }

  // TripleIntegration advanced
  // =============================================================
  // Triplet:
  // =============================================================
  // Pre trace, Post slow and fast trace
  //
  // Depression: fast post trace with at pre spike
  // Potentiation: slow post trace at post spike
  double tripleIntegration(int t) {
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
      // fmt.Printf("(%d) at %d\n", id, t)

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

    if (excititory) {
      psp = surge * exp(-dt / bio.taoP);
    } else {
      psp = surge * exp(-dt / bio.taoN);
    }

    // If an AP occurred (from the soma) we read the current psp value and add it to the "w"
    if (soma.output() == 1) {
      // #######################################
      // Potentiation LTP
      // #######################################
      // Read pre trace (aka psp) and slow AP trace for adjusting weight accordingly.
      //     Post efficacy                       weight dependence        triplet sum
      double wf = weightFactor(true);
      dwP =
          soma.efficacyTrace * distanceEfficacy * wf * (psp + soma.apSlowPrior);
      updateWeight = true;
    }

    // Finally update the weight.
    if (updateWeight) {
      double newW = w + dwP - dwD;

      switch (environment.weightBounding) {
        case Environment.weightBoundingHard:
          w = max(min(newW, wMax), wMin);
        case Environment.weightBoundingSoft: // soft-bounds (Easing)
          // https://neuronaldynamicepfl.ch/online/Ch19.S2.html
          double d;
          // With soft-bounds we want to slow down the movement of the weight as it moves
          // towards wMax/wMin.
          if (excititory) {
            d = (wMax - newW).abs();
            // sb is larger the farther away newW is from wMax
          } else {
            d = (newW - wMin).abs();
          }

          double sb =
              configModel.softAcceleration * pow(d, configModel.softCurve);
          // We still need hard-bounds to make sure the bounds aren't exceeded.
          w = max(min(sb * newW, wMax), wMin);
      }
    }

    // Return the "value" of this synapse for this "t"
    if (excititory) {
      value = psp * w * bio.distance;
    } else {
      value = -psp * w * bio.distance; // is inhibitory
    }

    // Collect this synapse' values at this time step
    // samples.collectSynapse(this, id, t);
    appState.samplesData.samples.collectSynapse(this, id, t);

    return value;
  }

  // WeightFactor mu = 0.0 = additive, mu = 1.0 = multiplicative
  double weightFactor(bool potentiation) {
    if (potentiation) {
      return bio.lambda * pow(1.0 - w.abs() / wMax, bio.mu);
    }

    return bio.lambda * bio.alpha * pow(w.abs() / wMax, bio.mu);
  }

  double efficacy(double dt) {
    return 1.0 - exp(-dt / bio.taoI);
  }
}
