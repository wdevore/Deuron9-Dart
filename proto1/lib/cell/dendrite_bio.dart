import 'dart:math';

import '../model/appstate.dart';
import '../model/model.dart';

class DendriteBio {
  late AppState appState;

  DendriteBio(AppState appState);

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

  void reset() {}

  double integrate(int spanT, int t) {
    // TODO
    return 0.0;
  }
}
