import 'dart:math';

import '../cell/soma.dart';
import '../model/model.dart';
import 'soma_sample.dart';

class Samples {
  // Synaptic data. There are N synapses and each is tracked
  // with their own collection.
  List<List<Synapse>> synData = [];

  List<SomaSample> somaData = [];

  double synapseSurgeMin = 0.0;
  double synapseSurgeMax = 0.0;
  double synapsePspMin = 0.0;
  double synapsePspMax = 0.0;
  double synapseWeightMin = 0.0;
  double synapseWeightMax = 0.0;

  double somaPspMin = 0.0;
  double somaPspMax = 0.0;
  double somaAPFastMin = 0.0;
  double somaAPFastMax = 0.0;
  double somaAPSlowMin = 0.0;
  double somaAPSlowMax = 0.0;

  Samples();

  factory Samples.create() {
    Samples sam = Samples();
    sam.reset();
    return sam;
  }

  void reset() {
    synData = [];
    somaData = [];

    synapseSurgeMin = 1000000000000.0;
    synapseSurgeMax = -1000000000000.0;
    synapsePspMin = 1000000000000.0;
    synapsePspMax = -1000000000000.0;
    synapseWeightMin = 1000000000000.0;
    synapseWeightMax = -1000000000000.0;

    somaPspMin = 1000000000000.0;
    somaPspMax = -1000000000000.0;
    somaAPFastMin = 1000000000000.0;
    somaAPFastMax = -1000000000000.0;
    somaAPSlowMin = 1000000000000.0;
    somaAPSlowMax = -1000000000000.0;
  }

  void collectSoma(Soma soma, int t) {
    somaPspMin = min(somaPspMin, soma.psp);
    somaPspMax = max(somaPspMax, soma.psp);
    somaAPFastMin = min(somaAPFastMin, soma.apFast);
    somaAPFastMax = max(somaAPFastMax, soma.apFast);
    somaAPSlowMin = min(somaAPSlowMin, soma.apSlow);
    somaAPSlowMax = max(somaAPSlowMax, soma.apSlow);

    somaData.add(SomaSample()
      ..t = t
      ..apFast = soma.apFast
      ..apSlow = soma.apSlow
      ..psp = soma.psp
      ..output = soma.output());
  }
}
