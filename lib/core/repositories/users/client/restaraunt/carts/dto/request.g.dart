// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemRequestDTO _$CartItemRequestDTOFromJson(Map<String, dynamic> json) =>
    CartItemRequestDTO(
      productVariantId: (json['product_variant_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      modifierIds: (json['modifier_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CartItemRequestDTOToJson(CartItemRequestDTO instance) =>
    <String, dynamic>{
      'product_variant_id': instance.productVariantId,
      'quantity': instance.quantity,
      'modifier_ids': instance.modifierIds,
    };
