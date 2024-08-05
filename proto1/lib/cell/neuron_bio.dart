import '../model/appstate.dart';
import '../model/model.dart';
import 'soma.dart';

class NeuronBio {
  late AppState appState;

  late Soma soma;

  NeuronBio();

  factory NeuronBio.create(AppState appState, Soma soma) {
    NeuronBio nb = NeuronBio();
    nb.soma = soma;
    return nb;
  }

  void initialize() {
    soma.initialize();
  }

  void reset(Model model) {
    soma.reset(model);
  }

  int integrate(int spanT, int t) {
    return soma.integrate(spanT, t);
  }

  void step() {
    soma.step();
  }

  int output() {
    return soma.output();
  }
}
