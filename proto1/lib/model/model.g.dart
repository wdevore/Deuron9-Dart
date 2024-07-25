// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Synapse _$SynapseFromJson(Map<String, dynamic> json) => Synapse()
  ..taoP = (json['taoP'] as num).toDouble()
  ..taoN = (json['taoN'] as num).toDouble()
  ..mu = (json['mu'] as num).toDouble()
  ..distance = (json['distance'] as num).toDouble()
  ..lambda = (json['lambda'] as num).toDouble()
  ..amb = (json['amb'] as num).toDouble()
  ..w = (json['w'] as num).toDouble()
  ..alpha = (json['alpha'] as num).toDouble()
  ..learningRateSlow = (json['learningRateSlow'] as num).toDouble()
  ..learningRateFast = (json['learningRateFast'] as num).toDouble()
  ..taoI = (json['taoI'] as num).toDouble()
  ..ama = (json['ama'] as num).toDouble();

Map<String, dynamic> _$SynapseToJson(Synapse instance) => <String, dynamic>{
      'taoP': instance.taoP,
      'taoN': instance.taoN,
      'mu': instance.mu,
      'distance': instance.distance,
      'lambda': instance.lambda,
      'amb': instance.amb,
      'w': instance.w,
      'alpha': instance.alpha,
      'learningRateSlow': instance.learningRateSlow,
      'learningRateFast': instance.learningRateFast,
      'taoI': instance.taoI,
      'ama': instance.ama,
    };

Compartment _$CompartmentFromJson(Map<String, dynamic> json) => Compartment(
      Synapse.fromJson(json['synapse'] as Map<String, dynamic>),
    )
      ..id = (json['id'] as num).toInt()
      ..weightMin = (json['weightMin'] as num).toDouble()
      ..weightMax = (json['weightMax'] as num).toDouble()
      ..weightDivisor = (json['weightDivisor'] as num).toDouble();

Map<String, dynamic> _$CompartmentToJson(Compartment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weightMin': instance.weightMin,
      'weightMax': instance.weightMax,
      'weightDivisor': instance.weightDivisor,
      'synapse': instance.synapse,
    };

Dendrite _$DendriteFromJson(Map<String, dynamic> json) => Dendrite()
  ..id = (json['id'] as num).toInt()
  ..length = (json['length'] as num).toDouble()
  ..taoEff = (json['taoEff'] as num).toDouble()
  ..minPSPValue = (json['minPSPValue'] as num).toDouble()
  ..compartments = (json['compartments'] as List<dynamic>)
      .map((e) => Compartment.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$DendriteToJson(Dendrite instance) => <String, dynamic>{
      'id': instance.id,
      'length': instance.length,
      'taoEff': instance.taoEff,
      'minPSPValue': instance.minPSPValue,
      'compartments': instance.compartments,
    };

Neuron _$NeuronFromJson(Map<String, dynamic> json) => Neuron()
  ..id = (json['id'] as num).toInt()
  ..tao = (json['tao'] as num).toDouble()
  ..fastSurge = (json['fastSurge'] as num).toDouble()
  ..taoJ = (json['taoJ'] as num).toDouble()
  ..taoS = (json['taoS'] as num).toDouble()
  ..aPMax = (json['aPMax'] as num).toDouble()
  ..threshold = (json['threshold'] as num).toDouble()
  ..refractoryPeriod = (json['refractoryPeriod'] as num).toDouble()
  ..slowSurge = (json['slowSurge'] as num).toDouble()
  ..dendrites = (json['dendrites'] as List<dynamic>)
      .map((e) => Dendrite.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$NeuronToJson(Neuron instance) => <String, dynamic>{
      'id': instance.id,
      'tao': instance.tao,
      'fastSurge': instance.fastSurge,
      'taoJ': instance.taoJ,
      'taoS': instance.taoS,
      'aPMax': instance.aPMax,
      'threshold': instance.threshold,
      'refractoryPeriod': instance.refractoryPeriod,
      'slowSurge': instance.slowSurge,
      'dendrites': instance.dendrites,
    };

Model _$ModelFromJson(Map<String, dynamic> json) => Model(
      Neuron.fromJson(json['neuron'] as Map<String, dynamic>),
    )
      ..synapses = (json['synapses'] as num).toInt()
      ..activeSynapse = (json['activeSynapse'] as num).toInt()
      ..poissonPatternSpread = (json['poissonPatternSpread'] as num).toInt()
      ..percentOfExcititorySynapses =
          (json['percentOfExcititorySynapses'] as num).toDouble()
      ..hertz = (json['hertz'] as num).toInt()
      ..poissonPatternMax = (json['poissonPatternMax'] as num).toDouble()
      ..poissonPatternMin = (json['poissonPatternMin'] as num).toDouble()
      ..noiseLambda = (json['noiseLambda'] as num).toDouble()
      ..noiseCount = (json['noiseCount'] as num).toInt();

Map<String, dynamic> _$ModelToJson(Model instance) => <String, dynamic>{
      'synapses': instance.synapses,
      'activeSynapse': instance.activeSynapse,
      'poissonPatternSpread': instance.poissonPatternSpread,
      'percentOfExcititorySynapses': instance.percentOfExcititorySynapses,
      'hertz': instance.hertz,
      'poissonPatternMax': instance.poissonPatternMax,
      'poissonPatternMin': instance.poissonPatternMin,
      'noiseLambda': instance.noiseLambda,
      'noiseCount': instance.noiseCount,
      'neuron': instance.neuron,
    };
