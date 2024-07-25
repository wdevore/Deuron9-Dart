import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class Synapse {
  double taoP = 0;
  double taoN = 0;
  double mu = 0;
  double distance = 0;
  double lambda = 0;
  double amb = 0;
  double w = 0;
  double alpha = 0;
  double learningRateSlow = 0;
  double learningRateFast = 0;
  double taoI = 0;
  double ama = 0;

  Synapse();

  factory Synapse.create() {
    Synapse synapse = Synapse();
    return synapse;
  }

  factory Synapse.fromJson(Map<String, dynamic> json) =>
      _$SynapseFromJson(json);
  Map<String, dynamic> toJson() => _$SynapseToJson(this);
}

@JsonSerializable()
class Compartment {
  int id = 0;
  double weightMin = 0;
  double weightMax = 0;
  double weightDivisor = 0;
  final Synapse synapse;

  Compartment(this.synapse);

  factory Compartment.create(Synapse synapse) {
    Compartment compartment = Compartment(synapse);
    return compartment;
  }

  factory Compartment.fromJson(Map<String, dynamic> json) =>
      _$CompartmentFromJson(json);
  Map<String, dynamic> toJson() => _$CompartmentToJson(this);
}

@JsonSerializable()
class Dendrite {
  int id = 0;
  double length = 0;
  double taoEff = 0;
  double minPSPValue = 0;
  List<Compartment> compartments = [];

  Dendrite();

  factory Dendrite.create() {
    Synapse synapse = Synapse.create();

    Compartment compartment = Compartment.create(synapse);
    return Dendrite()..compartments.add(compartment);
  }

  factory Dendrite.fromJson(Map<String, dynamic> json) =>
      _$DendriteFromJson(json);
  Map<String, dynamic> toJson() => _$DendriteToJson(this);
}

@JsonSerializable()
class Neuron {
  int id = 0;
  double tao = 0;
  double fastSurge = 0;
  double taoJ = 0;
  double taoS = 0;
  double aPMax = 0;
  double threshold = 0;
  double refractoryPeriod = 0;
  double slowSurge = 0;
  List<Dendrite> dendrites = [];

  Neuron();

  factory Neuron.create() {
    Dendrite dendrite = Dendrite.create();
    return Neuron()..dendrites.add(dendrite);
  }

  factory Neuron.fromJson(Map<String, dynamic> json) => _$NeuronFromJson(json);
  Map<String, dynamic> toJson() => _$NeuronToJson(this);
}

@JsonSerializable()
class Model {
  int synapses = 0;
  int activeSynapse = 0;
  int poissonPatternSpread = 0;
  double percentOfExcititorySynapses = 0;

  // If Hertz = 0 then stimulus is distributed as poisson.
  // Hertz is = cycles per second (or 1000ms per second)
  // 10Hz = 10 applied in 1000ms or every 100ms = 1000/10Hz
  // This means a stimulus is generated every 100ms which also means the
  // Inter-spike-interval (ISI) is fixed at 100ms
  int hertz = 0;

  double poissonPatternMax = 0;
  double poissonPatternMin = 0;

  // Poisson stream Lambda
  // Firing rate = spikes over an interval of time or
  // Poisson events per interval of time.
  // For example, spikes in a 1 sec span.
  double noiseLambda = 0;
  int noiseCount = 0;

  final Neuron neuron;

  Model(this.neuron);

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);
  Map<String, dynamic> toJson() => _$ModelToJson(this);
}
