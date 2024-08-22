import 'dart:math';

import '../model/environment.dart';
import '../cell/axon.dart';
import '../model/appstate.dart';
import '../model/model.dart';
import '../samples/samples.dart';
import 'dendrite_bio.dart';

class Soma {
  // Properties
  late AppState appState;
  late Environment environment;

  // Axon is the output
  late Axon axon;
  late Neuron neuron;
  late DendriteBio dendrite;

  // Soma threshold. When exceeded an AP is generated.
  double threshold = 0.0;
  // Post synaptic potential
  double psp = 0.0;

  // --------------------------------------------------------
  // Action potential
  // --------------------------------------------------------
  // AP can travel back down the dendrite. The value decays
  // with distance.
  double apFast = 0.0; // Fast trace
  double apSlow = 0.0; // Slow trace
  double apSlowPrior = 0.0; // Slow trace (t-1)

  // The time-mark of the current AP.
  double aPt = 0.0;
  // The previous time-mark
  double preAPt = 0.0;
  double aPMax = 0.0;

  // --------------------------------------------------------
  // STDP
  // --------------------------------------------------------
  // -----------------------------------
  // AP decay
  // -----------------------------------
  // ntao  =0.0; // fast trace
  // ntaoS =0.0; // slow trace

  // Fast Surge
  double nFastSurge = 0.0;
  double nDynFastSurge = 0.0;
  double nInitialFastSurge = 0.0;

  // Slow Surge
  double nSlowSurge = 0.0;
  double nDynSlowSurge = 0.0;
  double nInitialSlowSurge = 0.0;

  // The time-mark at which a spike arrived at a synapse
  double preT = 0.0;

  double refractoryCnt = 0.0;
  bool refractoryState = false;

  // -----------------------------------
  // Suppression
  // -----------------------------------
  double ntaoJ = 0.0;
  double efficacyTrace = 0.0;

  Soma();

  factory Soma.create(AppState appState, Samples samples) {
    Soma s = Soma()
      ..appState = appState
      ..environment = appState.environment
      // ..samples = samples
      ..neuron = appState.model.neuron;

    return s;
  }

  void initialize() {
    dendrite.initialize();
  }

  void reset(Model model) {
    // Initial values to boot the cell.
    nSlowSurge = neuron.slowSurge;
    nFastSurge = neuron.fastSurge;
    threshold = neuron.threshold;
    aPMax = neuron.aPMax;

    // Default values
    apFast = 0.0;
    apSlow = 0.0;
    preT = -1000000000000000.0;
    refractoryState = false;
    refractoryCnt = 0;
    efficacyTrace = 0.0;
    psp = 0;

    axon.reset();
    dendrite.reset();
  }

  // Integrate is the core the soma
  int integrate(int spanT, int t) {
    double dt = t.toDouble() - preT;

    efficacyTrace = efficacy(dt);

    // The dendrite will return a value that affects the soma.
    psp = dendrite.integrate(spanT, t);

    // Default state
    axon.reset();

    if (refractoryState) {
      // this algorithm should be the same as for the synapse or at least very
      // close.
      if (refractoryCnt >= neuron.refractoryPeriod) {
        refractoryState = false;
        refractoryCnt = 0;
        // fmt.Printf("Refractory ended at (%d)\n", int(t))
      } else {
        refractoryCnt = refractoryCnt + 1;
      }
    } else {
      if (psp > threshold) {
        // An action potential just occurred.
        // TODO Handle depolarization

        refractoryState = true;

        // TODO
        // Generate a back propagating spike that fades spatial/temporally similar to CaDP model.
        // This spike affects forward in time.
        // The value is driven by the time delta of (preAPt - APt)

        // We set immediately because we are simulating a single neuron.
        axon.set(1);
        // axon.Input(1)
        // fmt.Println(t)

        // Surge from action potential

        nFastSurge =
            aPMax + apFast * neuron.fastSurge * exp(-apFast / neuron.tao);
        nSlowSurge =
            aPMax + apSlow * neuron.slowSurge * exp(-apSlow / neuron.taoS);

        // Reset time deltas
        preT = t.toDouble();
        dt = 0;
      }
    }

    // Prior is for triplet
    apSlowPrior = apSlow;

    // fmt.Printf("Soma:: %0.3f, %0.3f, psp:%0.3f\n", nFastSurge, nSlowSurge, psp)
    // println(soma.nFastSurge, ", ", soma.nSlowSurge, ", ", soma.ntao, ", ", soma.ntaoS)
    apFast = nFastSurge * exp(-dt / neuron.tao);
    apSlow = nSlowSurge * exp(-dt / neuron.taoS);

    // Collect this soma' values at this time step
    appState.samplesData.samples.collectSoma(this, t);

    return axon.output();
  }

// Step after integration
  void step() {
    axon.step();
  }

  // Efficacy : each spike of pre-synaptic neuron j sets the presynaptic spike
  // efficacy j to 0
  // whereafter it recovers exponentially to 1 with a time constant
  // τj = toaJ
  // In other words, the efficacy of a spike is suppressed by
  // the proximity of a trailing spike.
  double efficacy(double dt) {
    return 1.0 - exp(-dt / neuron.taoJ);
  }

  int output() {
    return axon.output();
  }

  void setAxon(Axon axon) {
    this.axon = axon;
  }
}
