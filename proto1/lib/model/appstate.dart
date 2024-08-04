import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:proto1/utils.dart';

import 'config_model.dart';
import 'environment.dart';
import 'model.dart';

/// AppState is the environment AND state management.
class AppState with ChangeNotifier {
  factory AppState.create() => AppState();

  AppState();

  // Environment var
  Environment environment = Environment();

  Model model = Model.create();
  ConfigModel configModel = ConfigModel.create();

  bool dirty = true;

  Future<int> initialize() async {
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

    return 0;
  }

  void reset() {}

  void update() {
    notifyListeners();
  }

  void createNeuron() {
    Neuron neuron = Neuron.create();
    model = Model(neuron);
  }

  // ----------------------------------------------------------------
  @override
  String toString() {
    try {
      Map<String, dynamic> map = model.toJson();
      String json = jsonEncode(map);
      return json;
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
      Map<String, dynamic> map = configModel.toJson();
      String json = jsonEncode(map);
      return json;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(e);
        print(stackTrace);
      }
    }
    return '';
  }
}
