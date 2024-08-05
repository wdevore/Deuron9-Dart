// Axon takes an input from the soma and routes it to one or more
// synapses on one or more neurons.
// a) Just poisson input
// b) Poisson and Stimulus

abstract class Axon {
  reset();

  set(int v) {}

  setNoDelay() {}

  setToMaxDelay() {}

  setToHalfDelay() {}

  // Output of axon that terminates with synapses
  int output() {
    return 0;
  }

  // Input from Soma to axon's hillock.
  input(int spike);

  // Step output
  step();
}
