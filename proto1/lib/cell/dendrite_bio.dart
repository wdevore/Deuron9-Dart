import 'dart:math';

import '../model/appstate.dart';
import '../model/model.dart';
import 'compartment_bio.dart';

// DendriteBio is part of a compartment
class DendriteBio {
  final AppState appState;
  // Contains Compartments
  List<CompartmentBio> compartments = [];

  int synapses = 0;

  DendriteBio(this.appState);

  // APEfficacy Calc this synapses's reaction to the AP based on its
  // distance from the soma.
  double aPEfficacy(double distance) {
    Dendrite dendrite = appState.model.neuron.dendrite;

    if (distance < dendrite.length) {
      return 1.0;
    }

    return exp(-(dendrite.length - distance) / dendrite.taoEff);
  }

  void initialize() {}

  void reset() {
    compartments[0].reset();
  }

  double integrate(int spanT, int t) {
    Dendrite dendrite = appState.model.neuron.dendrite;

    double sum = compartments[0].integrate(spanT, t);
    double psp = max(sum, dendrite.minPSPValue);

    return psp;
  }
}
