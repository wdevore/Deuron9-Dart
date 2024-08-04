import 'package:json_annotation/json_annotation.dart';

import 'model.dart';

part 'synapse_model.g.dart';

// The synapses this json has are presets. The model also
// has presets that would spread across all synapses.
@JsonSerializable()
class SynapsesModel {
  List<Synapse> synapses = [];

  SynapsesModel();

  factory SynapsesModel.fromJson(Map<String, dynamic> json) =>
      _$SynapsesModelFromJson(json);
  Map<String, dynamic> toJson() => _$SynapsesModelToJson(this);
}
