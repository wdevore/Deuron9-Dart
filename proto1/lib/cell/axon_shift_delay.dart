import 'axon.dart';

class AxonShiftDelay extends Axon {
  // A single bit is Set at a particular position where the
  // output is sampled.
  //                      /--- output
  //                     |
  // An 8bit example: 00010000
  //                          \-- input
  int _delay = 0;

  // MSB = output ... LSB = input
  int _register = 0;

  AxonShiftDelay(int delay) {
    if (delay == 0) {
      delay = 1;
    }
    delay = delay;
  }

  @override
  reset() {
    _register = 0;
  }

  @override
  void setNoDelay() {
    _delay = 1;
  }

  // SetToMaxDelay set maximum delay (64 delays)
  @override
  void setToMaxDelay() {
    _delay = 1 << 63;
  }

  // SetToHalfDelay set half maximum delay (32 delays)
  @override
  void setToHalfDelay() {
    _delay = 1 << 31;
  }

  @override
  int output() {
    // Capture output first
    if (_delay == 1) {
      return _register;
    }

    if ((_register & _delay) > 0) {
      return 1;
    }

    return 0;
  }

  // Input from Soma to AxonShiftDelay's hillock.
  // The incoming spike enters at position 0 (LSB) and shifts
  // towards the MSB
  @override
  input(int spike) {
    // Place spike in register at LSB
    _register = _register | (spike & 1);
  }

  // Step output
  @override
  step() {
    if (_delay > 1) {
      _register = _register << 1;
    }
  }
}
