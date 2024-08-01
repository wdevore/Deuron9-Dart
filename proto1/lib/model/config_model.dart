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
  double _scroll = 0.0; // velocity
  String dataOutputPath = '';
  int _rangeStart = 0;
  int _rangeEnd = 0;
  String sourceStimulus = '';
  double _stimulusScaler = 10;
  int _duration = 10000;
  double _softAcceleration = 0.05;
  double _softCurve = 2; // 1.0 = linear, 2.0 = parabola
  String outputDendriteAvgFiles = '';
  String outputSynapseWeightFiles = '';
  String outputSomaSpikeFiles = '';
  int patternFrequency = 0;
  String outputSomaPSPFiles = '';
  int spans = 5;
  String outputSomaAPSlowFiles = '';
  String outputSynapsePspFiles = '';
  int _timeScale = 100;
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
  set softAcceleration(double v) {
    _softAcceleration = v;
    notifyListeners();
  }

  double get softAcceleration => _softAcceleration;

  // ---------------------------
  set softCurve(double v) {
    _softCurve = v;
    notifyListeners();
  }

  double get softCurve => _softCurve;

  // ---------------------------
  set stimulusScaler(double v) {
    _stimulusScaler = v;
    notifyListeners();
  }

  double get stimulusScaler => _stimulusScaler;

  // -----------------------------------
  set duration(int v) {
    _duration = v;
    notifyListeners();
  }

  int get duration => _duration;

  // -----------------------------------
  set timeScale(int v) {
    _timeScale = v;
    notifyListeners();
  }

  int get timeScale => _timeScale;
  // -----------------------------------
  set rangeStart(int v) {
    _rangeStart = v;
    notifyListeners();
  }

  int get rangeStart => _rangeStart;
  // -----------------------------------
  set rangeEnd(int v) {
    _rangeEnd = v;
    notifyListeners();
  }

  int get rangeEnd => _rangeEnd;
  // ---------------------------
  set scroll(double v) {
    _scroll = v;
    notifyListeners();
  }

  double get scroll => _scroll;
}
