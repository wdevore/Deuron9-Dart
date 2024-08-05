import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../cell/synapse_bio.dart';
import '../samples/samples.dart';
import 'config_model.dart';
import 'synapse_model.dart';

class Environment with ChangeNotifier {
  static const int weightBoundingHard = 0;
  static const int weightBoundingSoft = 1;

  double _minRangeValue = 0.0;
  double _maxRangeValue = 0.0;
  double _centerRangeValue = 0.0;

  late Samples samples;

  // Synapses
  late SynapsesModel synapsesModel;

  // Synapses Bio
  List<SynapseBio> synapses = [];

  List<List<int>> stimulus = [];
  List<List<int>> expandedStimulus = [];

  int stimulusStreamCnt = 0;

  // Hard(0) or Soft(1) (used by Synapse for triple integration)
  int _weightBounding = 0;

  late String dataPath;

  Environment();

  factory Environment.create() {
    Environment environment = Environment();

    return environment;
  }

  void initialize(ConfigModel configModel) async {
    _minRangeValue = 5.0;
    _maxRangeValue = 10.0;
    dataPath = p.join(Directory.current.path, 'data/');

    // Load synaptic presets. Most likely from a previous run.
    loadSynapsesModel(configModel);

    samples = Samples.create();

    loadStimulus(configModel);
  }

  void update() {
    notifyListeners();
  }

  void loadStimulus(ConfigModel configModel) {
    String path = '$dataPath${configModel.sourceStimulus}.data';

    final File file = File(path);

    List<String> lines = file.readAsLinesSync();
    // Each line is the same length
    int duration = lines[0].length;

    for (var pattern in lines) {
      // The array size is duration + (duration * StimExpander)
      // For example, if duration is 10 and stim_scaler is 3 then
      // size of stimulus is 10 + (10*3) = 40
      // StimExpander thus becomes an expanding factor. For every bit in
      // the pattern we append StimExpander 0s.
      if (configModel.stimulusScaler == 0) {
        // Special case of 0 then duration is unchanged (i.e. reflected)
        configModel.stimulusScaler =
            1; // Note: we don't call Changed() on purpose.
      } else {
        duration = (duration * configModel.stimulusScaler).toInt();
      }

      List<int> expanded = List.filled(duration, 0);
      List<int> stim = [];

      int col = 0;
      for (var c in pattern.split('')) {
        if (c == '|') {
          expanded[col] = 1;
          stim.add(1);
        } else {
          stim.add(0);
        }
        // Move col "past" the expanded positions.
        col += configModel.stimulusScaler.toInt();
      }

      stimulus.add(stim);
      expandedStimulus.add(expanded);

      stimulusStreamCnt++;
    }
  }

  expandStimulus(int scaler) {
    // Reset expanded data
    expandedStimulus = [];

    // All channels are the same length, pick 0
    int duration = stimulus[0].length * scaler;

    // Iterate each channel and expand it.
    for (var stim in stimulus) {
      List<int> expanded = List.filled(duration, 0);
      int col = 0;
      for (var spike in stim) {
        if (spike == 1) {
          expanded[col] = 1;
        }
        // Move col "past" the expanded positions.
        col += scaler;
      }
      expandedStimulus.add(expanded);
    }
  }

  void loadSynapsesModel(ConfigModel configModel) {
    String synPath = '$dataPath/synapses';

    String path = '$synPath${configModel.synapticPresets}';

    final File file = File(path);
    String json = file.readAsStringSync();

    try {
      if (json.isNotEmpty) {
        Map<String, dynamic> map = jsonDecode(json);
        synapsesModel = SynapsesModel.fromJson(map);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // ------------------------------------------------------
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
}
