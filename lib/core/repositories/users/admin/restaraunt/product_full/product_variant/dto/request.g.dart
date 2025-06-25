// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductVariantCreateDTO _$ProductVariantCreateDTOFromJson(
        Map<String, dynamic> json) =>
    ProductVariantCreateDTO(
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      value: (json['value'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      sku: json['sku'] as String,
      isAvailable: json['is_available'] as bool,
      isCombo: json['is_combo'] as bool,
      productId: (json['product_id'] as num).toInt(),
    );

Map<String, dynamic> _$ProductVariantCreateDTOToJson(
        ProductVariantCreateDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image_url': instance.imageUrl,
      'value': instance.value,
      'unit': instance.unit,
      'sku': instance.sku,
      'is_available': instance.isAvailable,
      'is_combo': instance.isCombo,
      'product_id': instance.productId,
    };

ProductVariantPatchDTO _$ProductVariantPatchDTOFromJson(
        Map<String, dynamic> json) =>
    ProductVariantPatchDTO(
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
      imageUrl: json['image_url'] as String?,
      value: (json['value'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      sku: json['sku'] as String?,
      isAvailable: json['is_available'] as bool?,
      isCombo: json['is_combo'] as bool?,
      productId: (json['product_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductVariantPatchDTOToJson(
        ProductVariantPatchDTO instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.price case final value?) 'price': value,
      if (instance.imageUrl case final value?) 'image_url': value,
      if (instance.value case final value?) 'value': value,
      if (instance.unit case final value?) 'unit': value,
      if (instance.sku case final value?) 'sku': value,
      if (instance.isAvailable case final value?) 'is_available': value,
      if (instance.isCombo case final value?) 'is_combo': value,
      if (instance.productId case final value?) 'product_id': value,
    };
