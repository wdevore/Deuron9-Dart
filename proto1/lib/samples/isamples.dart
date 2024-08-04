import '../cell/soma.dart';
import '../model/model.dart';

// ISamples represents samples taken at each time step
abstract class ISamples {
  collectSynapse(Synapse synapse, int id, int t);
  collectDendrite(Dendrite dendrite, int t);
  collectSoma(Soma soma, int t);

  reset();

  // Synaptic data
  List<List<Synapse>> synapticData();
  List<Synapse> synapseData(int data);

  double synapseSurgeMin();
  double synapseSurgeMax();

  double synapsePspMin();
  double synapsePspMax();

  double synapseWeightMin();
  double synapseWeightMax();

  // Soma data
  List<Soma> somaData();
  double somaPspMin();
  double somaPspMax();
  double somaAPFastMin();
  double somaAPFastMax();
  double somaAPSlowMin();
  double somaAPSlowMax();
}
