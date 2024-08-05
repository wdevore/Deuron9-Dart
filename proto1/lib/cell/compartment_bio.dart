import 'package:proto1/cell/synapse_bio.dart';

class CompartmentBio {
  // Contains Synapses
  List<SynapseBio> synapses = [];

  void addSynapse(SynapseBio syn) {
    synapses.add(syn);
  }

  void reset() {
    for (var synapse in synapses) {
      synapse.reset();
    }
  }

  /// Returns 'psp'.
  double integrate(int spanT, int t) {
    double psp = 0.0;

    for (var synapse in synapses) {
      double sum = synapse.integrate(spanT, t);
      psp += sum;
    }

    return psp;
  }
}
