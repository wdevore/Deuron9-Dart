import '../model/model.dart';

abstract class IBitStream {
  reset();
  int output();
  step();
  update(Model model);
}
