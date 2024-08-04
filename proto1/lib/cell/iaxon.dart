// IAxon routes spikes to synapses
abstract class IAxon {
  reset();
  input(int spike);
  int output();
  step();

  // Set forces both input and output to a value
  set(int value);
  setNoDelay();
  setToMaxDelay();
  setToHalfDelay();
}
