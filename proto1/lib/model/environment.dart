import 'package:flutter/material.dart';

class Environment with ChangeNotifier {
  double _minRangeValue = 0.0;
  double _maxRangeValue = 0.0;
  double _centerRangeValue = 0.0;

  // Hard(0) or Soft(1) (used by Synapse for triple integration)
  int _weightBounding = 0;

  void initialize() async {
    _minRangeValue = 5.0;
    _maxRangeValue = 10.0;
  }

  void update() {
    notifyListeners();
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
