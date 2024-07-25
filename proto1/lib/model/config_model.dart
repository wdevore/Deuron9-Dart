import 'package:json_annotation/json_annotation.dart';

part 'config_model.g.dart';

@JsonSerializable()
class ConfigModel {
  bool autoSave = true;
  bool stepEnabled = false;
  String simulation = '';
  String synapticPresets = '';
  String outputSomaAPFastFiles = '';
  String dataPath = '';
  String outputPoissonFiles = '';
  String outputSynapseSurgeFiles = '';
  String outputSynapseSpikeFiles = '';
  int scroll = 0;
  String dataOutputPath = '';
  int rangeStart = 0;
  int rangeEnd = 0;
  String sourceStimulus = '';
  double stimulusScaler = 10;
  int duration = 10000;
  double softAcceleration = 0.05;
  double softCurve = 2;
  String outputDendriteAvgFiles = '';
  String outputSynapseWeightFiles = '';
  String outputSomaSpikeFiles = '';
  int patternFrequency = 0;
  String outputSomaPSPFiles = '';
  int spans = 5;
  String outputSomaAPSlowFiles = '';
  String outputSynapsePspFiles = '';
  int timeScale = 100;
  String outputStimulusFiles = '';

  ConfigModel();

  factory ConfigModel.create() {
    ConfigModel config = ConfigModel();
    return config;
  }

  factory ConfigModel.fromJson(Map<String, dynamic> json) =>
      _$ConfigModelFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigModelToJson(this);
}
