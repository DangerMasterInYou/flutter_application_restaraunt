// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierCreateDTO _$ModifierCreateDTOFromJson(Map<String, dynamic> json) =>
    ModifierCreateDTO(
      name: json['name'] as String,
      priceDelta: (json['price_delta'] as num).toInt(),
    );

Map<String, dynamic> _$ModifierCreateDTOToJson(ModifierCreateDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price_delta': instance.priceDelta,
    };

ModifierPatchDTO _$ModifierPatchDTOFromJson(Map<String, dynamic> json) =>
    ModifierPatchDTO(
      name: json['name'] as String?,
      priceDelta: (json['price_delta'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ModifierPatchDTOToJson(ModifierPatchDTO instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.priceDelta case final value?) 'price_delta': value,
    };
