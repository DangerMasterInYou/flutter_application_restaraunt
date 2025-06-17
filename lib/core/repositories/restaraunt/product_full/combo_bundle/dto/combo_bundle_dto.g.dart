// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo_bundle_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComboBundleCreateDTO _$ComboBundleCreateDTOFromJson(
        Map<String, dynamic> json) =>
    ComboBundleCreateDTO(
      comboVariantId: (json['combo_variant_id'] as num).toInt(),
      includedVariantId: (json['included_variant_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$ComboBundleCreateDTOToJson(
        ComboBundleCreateDTO instance) =>
    <String, dynamic>{
      'combo_variant_id': instance.comboVariantId,
      'included_variant_id': instance.includedVariantId,
      'quantity': instance.quantity,
    };

ComboBundlePatchDTO _$ComboBundlePatchDTOFromJson(Map<String, dynamic> json) =>
    ComboBundlePatchDTO(
      comboVariantId: (json['combo_variant_id'] as num?)?.toInt(),
      includedVariantId: (json['included_variant_id'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ComboBundlePatchDTOToJson(
        ComboBundlePatchDTO instance) =>
    <String, dynamic>{
      if (instance.comboVariantId case final value?) 'combo_variant_id': value,
      if (instance.includedVariantId case final value?)
        'included_variant_id': value,
      'quantity': instance.quantity,
    };
