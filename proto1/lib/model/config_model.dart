import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config_model.g.dart';

@JsonSerializable()
class ConfigModel with ChangeNotifier {
  bool autoSave = true;
  bool stepEnabled = false;
  String simulation = '';
  String synapticPresets = '';
  String outputSomaAPFastFiles = '';
  String dataPath = '';
  String outputPoissonFiles = '';
  String outputSynapseSurgeFiles = '';
  String outputSynapseSpikeFiles = '';
  double scroll = 0.0; // velocity
  String dataOutputPath = '';
  int rangeStart = 0;
  int rangeEnd = 0;
  String sourceStimulus = '';
  double stimulusScaler = 10;
  int duration = 10000;
  double softAcceleration = 0.05;
  double softCurve = 2; // 1.0 = linear, 2.0 = parabola
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

  void update() {
    notifyListeners();
  }

  // ---------------------------
  set softnessAcceleration(double v) {
    softAcceleration = v;
    notifyListeners();
  }

  double get softnessAcceleration => softAcceleration;

  // ---------------------------
  set softnessCurve(double v) {
    softCurve = v;
    notifyListeners();
  }

  double get softnessCurve => softCurve;
}
