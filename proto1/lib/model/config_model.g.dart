// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigModel _$ConfigModelFromJson(Map<String, dynamic> json) => ConfigModel()
  ..autoSave = json['autoSave'] as bool
  ..stepEnabled = json['stepEnabled'] as bool
  ..simulation = json['simulation'] as String
  ..synapticPresets = json['synapticPresets'] as String
  ..outputSomaAPFastFiles = json['outputSomaAPFastFiles'] as String
  ..dataPath = json['dataPath'] as String
  ..outputPoissonFiles = json['outputPoissonFiles'] as String
  ..outputSynapseSurgeFiles = json['outputSynapseSurgeFiles'] as String
  ..outputSynapseSpikeFiles = json['outputSynapseSpikeFiles'] as String
  ..dataOutputPath = json['dataOutputPath'] as String
  ..sourceStimulus = json['sourceStimulus'] as String
  ..outputDendriteAvgFiles = json['outputDendriteAvgFiles'] as String
  ..outputSynapseWeightFiles = json['outputSynapseWeightFiles'] as String
  ..outputSomaSpikeFiles = json['outputSomaSpikeFiles'] as String
  ..patternFrequency = (json['patternFrequency'] as num).toInt()
  ..outputSomaPSPFiles = json['outputSomaPSPFiles'] as String
  ..spans = (json['spans'] as num).toInt()
  ..outputSomaAPSlowFiles = json['outputSomaAPSlowFiles'] as String
  ..outputSynapsePspFiles = json['outputSynapsePspFiles'] as String
  ..outputStimulusFiles = json['outputStimulusFiles'] as String
  ..softAcceleration = (json['softAcceleration'] as num).toDouble()
  ..softCurve = (json['softCurve'] as num).toDouble()
  ..stimulusScaler = (json['stimulusScaler'] as num).toDouble()
  ..duration = (json['duration'] as num).toInt()
  ..timeScale = (json['timeScale'] as num).toInt()
  ..rangeStart = (json['rangeStart'] as num).toInt()
  ..rangeEnd = (json['rangeEnd'] as num).toInt()
  ..scroll = (json['scroll'] as num).toDouble();

Map<String, dynamic> _$ConfigModelToJson(ConfigModel instance) =>
    <String, dynamic>{
      'autoSave': instance.autoSave,
      'stepEnabled': instance.stepEnabled,
      'simulation': instance.simulation,
      'synapticPresets': instance.synapticPresets,
      'outputSomaAPFastFiles': instance.outputSomaAPFastFiles,
      'dataPath': instance.dataPath,
      'outputPoissonFiles': instance.outputPoissonFiles,
      'outputSynapseSurgeFiles': instance.outputSynapseSurgeFiles,
      'outputSynapseSpikeFiles': instance.outputSynapseSpikeFiles,
      'dataOutputPath': instance.dataOutputPath,
      'sourceStimulus': instance.sourceStimulus,
      'outputDendriteAvgFiles': instance.outputDendriteAvgFiles,
      'outputSynapseWeightFiles': instance.outputSynapseWeightFiles,
      'outputSomaSpikeFiles': instance.outputSomaSpikeFiles,
      'patternFrequency': instance.patternFrequency,
      'outputSomaPSPFiles': instance.outputSomaPSPFiles,
      'spans': instance.spans,
      'outputSomaAPSlowFiles': instance.outputSomaAPSlowFiles,
      'outputSynapsePspFiles': instance.outputSynapsePspFiles,
      'outputStimulusFiles': instance.outputStimulusFiles,
      'softAcceleration': instance.softAcceleration,
      'softCurve': instance.softCurve,
      'stimulusScaler': instance.stimulusScaler,
      'duration': instance.duration,
      'timeScale': instance.timeScale,
      'rangeStart': instance.rangeStart,
      'rangeEnd': instance.rangeEnd,
      'scroll': instance.scroll,
    };
