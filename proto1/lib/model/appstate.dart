import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:proto1/utils.dart';

import 'config_model.dart';
import 'model.dart';

/// AppState is the environment and state management.
class AppState with ChangeNotifier {
  factory AppState.create() => AppState();

  AppState();

  // Environment var
  double _minRangeValue = 0.0;
  double _maxRangeValue = 0.0;
  double _centerRangeValue = 0.0;
  // Hard(0) or Soft(1) (used by Synapse for triple integration)
  int _weightBounding = 0;
  double _softAcceleration = 0;
  double _softCurve = 0; // 1.0 = linear, 2.0 = parabola

  Model? model;
  ConfigModel? configModel;

  bool dirty = true;

  void initialize() async {
    _minRangeValue = 5.0;
    _maxRangeValue = 10.0;

    var filePath = p.join(Directory.current.path, 'data/config.json');
    Map<String, dynamic>? map = await Utils.importData(filePath);
    if (map != null) {
      configModel = ConfigModel.fromJson(map);
    }

    filePath = p.join(Directory.current.path, 'data/SimModel.json');
    map = await Utils.importData(filePath);
    if (map != null) {
      model = Model.fromJson(map);
    }

    createNeuron();
  }

  void reset() {}

  void update() {
    notifyListeners();
  }

  void loadDefaultSimModel(String fileName) {
    final File file = File(fileName);
  }

  void createNeuron() {
    Neuron neuron = Neuron.create();
    model = Model(neuron);
  }

  // ----------------------------------------------------------------
  // State management
  // ----------------------------------------------------------------
  set activeSynapse(int v) {
    model?.activeSynapse = v;
    notifyListeners();
  }

  int get activeSynapse => model!.activeSynapse;

  // ---------------------------
  set minRangeValue(double v) {
    _minRangeValue = v;
    notifyListeners();
  }

  double get minRangeValue => _minRangeValue;

  // ---------------------------
  set maxRangeValue(double v) {
    _maxRangeValue = v;
    notifyListeners();
  }

  double get maxRangeValue => _maxRangeValue;

  // ---------------------------
  set centerRangeValue(double v) {
    _centerRangeValue = v;
    notifyListeners();
  }

  double get centerRangeValue => _centerRangeValue;

  // ---------------------------
  set weightBounding(int v) {
    _weightBounding = v;
    notifyListeners();
  }

  int get weightBounding => _weightBounding;

  // ----------------------------------------------------------------
  @override
  String toString() {
    try {
      if (model != null) {
        Map<String, dynamic> map = model!.toJson();
        String json = jsonEncode(map);
        return json;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(e);
        print(stackTrace);
      }
    }
    return '';
  }

  String toStringConfig() {
    try {
      if (configModel != null) {
        Map<String, dynamic> map = configModel!.toJson();
        String json = jsonEncode(map);
        return json;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(e);
        print(stackTrace);
      }
    }
    return '';
  }
}
