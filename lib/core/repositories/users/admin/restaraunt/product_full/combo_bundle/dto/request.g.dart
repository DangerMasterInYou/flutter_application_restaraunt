// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComboBundleCreateDTO _$ComboBundleCreateDTOFromJson(
        Map<String, dynamic> json) =>
    ComboBundleCreateDTO(
      comboVariantId: (json['combo_variant_id'] as num).toInt(),
      includedVariantIds: (json['included_variant_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$ComboBundleCreateDTOToJson(
        ComboBundleCreateDTO instance) =>
    <String, dynamic>{
      'combo_variant_id': instance.comboVariantId,
      'included_variant_ids': instance.includedVariantIds,
      'quantity': instance.quantity,
    };

ComboBundlePatchDTO _$ComboBundlePatchDTOFromJson(Map<String, dynamic> json) =>
    ComboBundlePatchDTO(
      comboVariantId: (json['combo_variant_id'] as num?)?.toInt(),
      includedVariantIds: (json['included_variant_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ComboBundlePatchDTOToJson(
        ComboBundlePatchDTO instance) =>
    <String, dynamic>{
      if (instance.comboVariantId case final value?) 'combo_variant_id': value,
      if (instance.includedVariantIds case final value?)
        'included_variant_ids': value,
      if (instance.quantity case final value?) 'quantity': value,
    };
