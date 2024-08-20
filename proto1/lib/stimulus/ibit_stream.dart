import '../model/model.dart';

abstract class IBitStream {
  configure({int? seed, double? lambda});
  reset();
  int output();
  step();
  update(Model model);
}
