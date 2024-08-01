// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Synapse _$SynapseFromJson(Map<String, dynamic> json) => Synapse()
  ..taoP = (json['taoP'] as num).toDouble()
  ..taoN = (json['taoN'] as num).toDouble()
  ..mu = (json['mu'] as num).toDouble()
  ..amb = (json['amb'] as num).toDouble()
  ..lambda = (json['lambda'] as num).toDouble()
  ..w = (json['w'] as num).toDouble()
  ..distance = (json['distance'] as num).toDouble()
  ..alpha = (json['alpha'] as num).toDouble()
  ..learningRateSlow = (json['learningRateSlow'] as num).toDouble()
  ..learningRateFast = (json['learningRateFast'] as num).toDouble()
  ..taoI = (json['taoI'] as num).toDouble()
  ..ama = (json['ama'] as num).toDouble();

Map<String, dynamic> _$SynapseToJson(Synapse instance) => <String, dynamic>{
      'taoP': instance.taoP,
      'taoN': instance.taoN,
      'mu': instance.mu,
      'amb': instance.amb,
      'lambda': instance.lambda,
      'w': instance.w,
      'distance': instance.distance,
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
      'synapse': instance.synapse,
      'weightMin': instance.weightMin,
      'weightMax': instance.weightMax,
      'weightDivisor': instance.weightDivisor,
    };

Dendrite _$DendriteFromJson(Map<String, dynamic> json) => Dendrite()
  ..id = (json['id'] as num).toInt()
  ..compartment =
      Compartment.fromJson(json['compartment'] as Map<String, dynamic>)
  ..length = (json['length'] as num).toDouble()
  ..taoEff = (json['taoEff'] as num).toDouble()
  ..minPSPValue = (json['minPSPValue'] as num).toDouble();

Map<String, dynamic> _$DendriteToJson(Dendrite instance) => <String, dynamic>{
      'id': instance.id,
      'compartment': instance.compartment,
      'length': instance.length,
      'taoEff': instance.taoEff,
      'minPSPValue': instance.minPSPValue,
    };

Neuron _$NeuronFromJson(Map<String, dynamic> json) => Neuron()
  ..id = (json['id'] as num).toInt()
  ..dendrite = Dendrite.fromJson(json['dendrite'] as Map<String, dynamic>)
  ..tao = (json['tao'] as num).toDouble()
  ..fastSurge = (json['fastSurge'] as num).toDouble()
  ..taoJ = (json['taoJ'] as num).toDouble()
  ..taoS = (json['taoS'] as num).toDouble()
  ..aPMax = (json['aPMax'] as num).toDouble()
  ..threshold = (json['threshold'] as num).toDouble()
  ..refractoryPeriod = (json['refractoryPeriod'] as num).toDouble()
  ..slowSurge = (json['slowSurge'] as num).toDouble();

Map<String, dynamic> _$NeuronToJson(Neuron instance) => <String, dynamic>{
      'id': instance.id,
      'dendrite': instance.dendrite,
      'tao': instance.tao,
      'fastSurge': instance.fastSurge,
      'taoJ': instance.taoJ,
      'taoS': instance.taoS,
      'aPMax': instance.aPMax,
      'threshold': instance.threshold,
      'refractoryPeriod': instance.refractoryPeriod,
      'slowSurge': instance.slowSurge,
    };

Model _$ModelFromJson(Map<String, dynamic> json) => Model(
      Neuron.fromJson(json['neuron'] as Map<String, dynamic>),
    )
      ..synapses = (json['synapses'] as num).toInt()
      ..poissonPatternSpread = (json['poissonPatternSpread'] as num).toInt()
      ..percentOfExcititorySynapses =
          (json['percentOfExcititorySynapses'] as num).toDouble()
      ..noiseCount = (json['noiseCount'] as num).toInt()
      ..activeSynapse = (json['activeSynapse'] as num).toInt()
      ..hertz = (json['hertz'] as num).toInt()
      ..noiseLambda = (json['noiseLambda'] as num).toDouble()
      ..poissonPatternMin = (json['poissonPatternMin'] as num).toDouble()
      ..poissonPatternMax = (json['poissonPatternMax'] as num).toDouble();

Map<String, dynamic> _$ModelToJson(Model instance) => <String, dynamic>{
      'synapses': instance.synapses,
      'poissonPatternSpread': instance.poissonPatternSpread,
      'percentOfExcititorySynapses': instance.percentOfExcititorySynapses,
      'noiseCount': instance.noiseCount,
      'neuron': instance.neuron,
      'activeSynapse': instance.activeSynapse,
      'hertz': instance.hertz,
      'noiseLambda': instance.noiseLambda,
      'poissonPatternMin': instance.poissonPatternMin,
      'poissonPatternMax': instance.poissonPatternMax,
    };
