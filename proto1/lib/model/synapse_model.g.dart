// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synapse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SynapsesModel _$SynapsesModelFromJson(Map<String, dynamic> json) =>
    SynapsesModel()
      ..synapses = (json['synapses'] as List<dynamic>)
          .map((e) => Synapse.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$SynapsesModelToJson(SynapsesModel instance) =>
    <String, dynamic>{
      'synapses': instance.synapses,
    };
