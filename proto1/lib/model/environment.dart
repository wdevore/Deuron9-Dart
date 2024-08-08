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

  // Holds both synapse and soma samples.
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
  int initialWeightValues = 0; // Default to 'preset'

  late String dataPath;

  Environment();

  factory Environment.create(ConfigModel configModel) {
    Environment environment = Environment()..initialize(configModel);
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

    expandedStimulus = [];

    List<String> lines = file.readAsLinesSync();
    // Each line is the same length
    int duration = lines[0].length;
    double stimulusScaler = configModel.stimulusScaler;

    // The array size is duration + (duration * StimExpander)
    // For example, if duration is 10 and stim_scaler is 3 then
    // size of stimulus is 10 + (10*3) = 40
    // StimExpander thus becomes an expanding factor. For every bit in
    // the pattern we append StimExpander 0s.
    if (stimulusScaler == 0) {
      // Special case of 0 then duration is unchanged (i.e. reflected)
      // Note: we don't call Changed() on purpose.
      stimulusScaler = 1;
    } else {
      duration = (duration * stimulusScaler).toInt();
    }

    for (var pattern in lines) {
      List<int> expanded = List.filled(duration, 0);
      List<int> stim = [];

      int col = 0;
      List<String> spikes = pattern.split('');
      for (var c in spikes) {
        if (c == '|') {
          expanded[col] = 1;
          stim.add(1);
        } else {
          stim.add(0);
        }
        // Move col "past" the expanded positions.
        col += stimulusScaler.toInt();
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
    String synPath = '${dataPath}synapses/';

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

  // ---------------------------
  set initialWeights(int v) {
    initialWeightValues = v;
    notifyListeners();
  }

  int get initialWeights => initialWeightValues;
}
