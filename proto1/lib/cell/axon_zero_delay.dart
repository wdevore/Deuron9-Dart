import 'axon.dart';

// AxonZeroDelay takes an input from the soma and routes it to one or more
// synapses on one or more neurons.
class AxonZeroDelay extends Axon {
  int _input = 0;
  int _output = 0;

  // Input from Soma to AxonZeroDelay's hillock.
  @override
  input(int spike) {
    _input = spike;
  }

  // Output of AxonZeroDelay that terminates with synapses
  @override
  int output() {
    return _output;
  }

  @override
  reset() {
    _input = 0;
    _output = 0;
  }

  // Set forces both input and output to a value
  @override
  set(int v) {
    _input = v;
    _output = v;
  }

  // Step output
  @override
  step() {
    _output = _input;
  }
}
