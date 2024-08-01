import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Synapse with ChangeNotifier {
  double _taoP = 0;
  double _taoN = 0;
  double _mu = 0;
  double _distance = 0;
  double _lambda = 0;
  double _amb = 0;
  double _w = 0;
  double _alpha = 0;
  double _learningRateSlow = 0;
  double _learningRateFast = 0;
  double _taoI = 0;
  double _ama = 0;

  Synapse();

  factory Synapse.create() {
    Synapse synapse = Synapse();
    return synapse;
  }

  factory Synapse.fromJson(Map<String, dynamic> json) =>
      _$SynapseFromJson(json);
  Map<String, dynamic> toJson() => _$SynapseToJson(this);

  // -----------------------------------
  set taoP(double v) {
    _taoP = v;
    notifyListeners();
  }

  double get taoP => _taoP;

  // -----------------------------------
  set taoN(double v) {
    _taoN = v;
    notifyListeners();
  }

  double get taoN => _taoN;
  // -----------------------------------
  set mu(double v) {
    _mu = v;
    notifyListeners();
  }

  double get mu => _mu;
  // -----------------------------------
  set amb(double v) {
    _amb = v;
    notifyListeners();
  }

  double get amb => _amb;
  // -----------------------------------
  set lambda(double v) {
    _lambda = v;
    notifyListeners();
  }

  double get lambda => _lambda;
  // -----------------------------------
  set w(double v) {
    _w = v;
    notifyListeners();
  }

  double get w => _w;
  // -----------------------------------
  set distance(double v) {
    _distance = v;
    notifyListeners();
  }

  double get distance => _distance;
  // -----------------------------------
  set alpha(double v) {
    _alpha = v;
    notifyListeners();
  }

  double get alpha => _alpha;
  // -----------------------------------
  set learningRateSlow(double v) {
    _learningRateSlow = v;
    notifyListeners();
  }

  double get learningRateSlow => _learningRateSlow;
  // -----------------------------------
  set learningRateFast(double v) {
    _learningRateFast = v;
    notifyListeners();
  }

  double get learningRateFast => _learningRateFast;
  // -----------------------------------
  set taoI(double v) {
    _taoI = v;
    notifyListeners();
  }

  double get taoI => _taoI;
  // -----------------------------------
  set ama(double v) {
    _ama = v;
    notifyListeners();
  }

  double get ama => _ama;
}

@JsonSerializable()
class Compartment with ChangeNotifier {
  int id = 0;
  double _weightMin = 0;
  double _weightMax = 0;
  double _weightDivisor = 0;
  final Synapse synapse;

  Compartment(this.synapse);

  factory Compartment.create(Synapse synapse) {
    Compartment compartment = Compartment(synapse);
    return compartment;
  }

  factory Compartment.fromJson(Map<String, dynamic> json) =>
      _$CompartmentFromJson(json);
  Map<String, dynamic> toJson() => _$CompartmentToJson(this);

  // -----------------------------------
  set weightMin(double v) {
    _weightMin = v;
    notifyListeners();
  }

  double get weightMin => _weightMin;

  // -----------------------------------
  set weightMax(double v) {
    _weightMax = v;
    notifyListeners();
  }

  double get weightMax => _weightMax;

  // -----------------------------------
  set weightDivisor(double v) {
    _weightDivisor = v;
    notifyListeners();
  }

  double get weightDivisor => _weightDivisor;
}

@JsonSerializable()
class Dendrite with ChangeNotifier {
  int id = 0;
  double _length = 0;
  double _taoEff = 0;
  double _minPSPValue = 0;
  late Compartment compartment;
  // List<Compartment> compartments = [];

  Dendrite();

  factory Dendrite.create() {
    Synapse synapse = Synapse.create();

    Dendrite dendrite = Dendrite()..compartment = Compartment.create(synapse);
    return dendrite;
    // Compartment compartment = Compartment.create(synapse);
    // return Dendrite()..compartments.add(compartment);
  }

  factory Dendrite.fromJson(Map<String, dynamic> json) =>
      _$DendriteFromJson(json);
  Map<String, dynamic> toJson() => _$DendriteToJson(this);

  // -----------------------------------
  set length(double v) {
    _length = v;
    notifyListeners();
  }

  double get length => _length;

  // -----------------------------------
  set taoEff(double v) {
    _taoEff = v;
    notifyListeners();
  }

  double get taoEff => _taoEff;

  // -----------------------------------
  set minPSPValue(double v) {
    _minPSPValue = v;
    notifyListeners();
  }

  double get minPSPValue => _minPSPValue;
}

@JsonSerializable()
class Neuron with ChangeNotifier {
  int id = 0;
  double _tao = 0;
  double _fastSurge = 0;
  double _taoJ = 0;
  double _taoS = 0;
  double _aPMax = 0;
  double _threshold = 0;
  double _refractoryPeriod = 0;
  double _slowSurge = 0;
  // List<Dendrite> dendrites = [];
  Dendrite dendrite = Dendrite.create();

  Neuron();

  factory Neuron.create() {
    // Dendrite dendrite = Dendrite.create();
    // return Neuron()..dendrites.add(dendrite);
    return Neuron();
  }

  factory Neuron.fromJson(Map<String, dynamic> json) => _$NeuronFromJson(json);
  Map<String, dynamic> toJson() => _$NeuronToJson(this);

  // -----------------------------------
  set tao(double v) {
    _tao = v;
    notifyListeners();
  }

  double get tao => _tao;

  // -----------------------------------
  set fastSurge(double v) {
    _fastSurge = v;
    notifyListeners();
  }

  double get fastSurge => _fastSurge;

  // -----------------------------------
  set taoJ(double v) {
    _taoJ = v;
    notifyListeners();
  }

  double get taoJ => _taoJ;

  // -----------------------------------
  set taoS(double v) {
    _taoS = v;
    notifyListeners();
  }

  double get taoS => _taoS;

  // -----------------------------------
  set aPMax(double v) {
    _aPMax = v;
    notifyListeners();
  }

  double get aPMax => _aPMax;

  // -----------------------------------
  set threshold(double v) {
    _threshold = v;
    notifyListeners();
  }

  double get threshold => _threshold;

  // -----------------------------------
  set refractoryPeriod(double v) {
    _refractoryPeriod = v;
    notifyListeners();
  }

  double get refractoryPeriod => _refractoryPeriod;

  // -----------------------------------
  set slowSurge(double v) {
    _slowSurge = v;
    notifyListeners();
  }

  double get slowSurge => _slowSurge;
}

@JsonSerializable()
class Model with ChangeNotifier {
  int synapses = 1;
  int _activeSynapse = 1;
  int poissonPatternSpread = 0;
  double percentOfExcititorySynapses = 0;

  // If Hertz = 0 then stimulus is distributed as poisson.
  // Hertz is = cycles per second (or 1000ms per second)
  // 10Hz = 10 applied in 1000ms or every 100ms = 1000/10Hz
  // This means a stimulus is generated every 100ms which also means the
  // Inter-spike-interval (ISI) is fixed at 100ms
  int _hertz = 0;

  double _poissonPatternMax = 0;
  double _poissonPatternMin = 0;

  // Poisson stream Lambda
  // Firing rate = spikes over an interval of time or
  // Poisson events per interval of time.
  // For example, spikes in a 1 sec span.
  double _noiseLambda = 0;
  int noiseCount = 0;

  final Neuron neuron;

  Model(this.neuron);

  factory Model.create() {
    Neuron neuron = Neuron.create();
    return Model(neuron);
  }

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);

  // ----------------------------------------------------------------
  // State management
  // ----------------------------------------------------------------
  set activeSynapse(int v) {
    _activeSynapse = v;
    notifyListeners();
  }

  int get activeSynapse => _activeSynapse;

  // -----------------------------------
  set hertz(int v) {
    _hertz = v;
    notifyListeners();
  }

  int get hertz => _hertz;

  // -----------------------------------
  set noiseLambda(double v) {
    _noiseLambda = v;
    notifyListeners();
  }

  double get noiseLambda => _noiseLambda;

  // -----------------------------------
  set poissonPatternMin(double v) {
    _poissonPatternMin = v;
    notifyListeners();
  }

  double get poissonPatternMin => _poissonPatternMin;

  // -----------------------------------
  set poissonPatternMax(double v) {
    _poissonPatternMax = v;
    notifyListeners();
  }

  double get poissonPatternMax => _poissonPatternMax;
}
