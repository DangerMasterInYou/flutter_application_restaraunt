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

Map<String, dynamic> _$ModifierPatchDTOToJson(ModifierPatchDTO instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('price_delta', instance.priceDelta);
  return val;
}
