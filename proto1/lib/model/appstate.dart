import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:proto1/model/config_model.dart';
import 'package:proto1/model/model.dart';

class AppState with ChangeNotifier {
  factory AppState.create() => AppState();

  AppState();

  late String version;

  Model? model;
  ConfigModel? configModel;

  bool dirty = true;

  void initialize() {
    createNeuron();
  }

  void reset() {}

  void update() {}

  void loadConfig(String fileName) {
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
