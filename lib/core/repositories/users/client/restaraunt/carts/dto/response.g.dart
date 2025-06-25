// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponseDTO _$CartResponseDTOFromJson(Map<String, dynamic> json) =>
    CartResponseDTO(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['total_price'] as num).toInt(),
    );

Map<String, dynamic> _$CartResponseDTOToJson(CartResponseDTO instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total_price': instance.totalPrice,
    };

CartItemResponseDTO _$CartItemResponseDTOFromJson(Map<String, dynamic> json) =>
    CartItemResponseDTO(
      id: (json['id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      productVariant:
          Menu.fromJson(json['product_variant'] as Map<String, dynamic>),
      appliedModifiers: (json['applied_modifiers'] as List<dynamic>)
          .map((e) =>
              AppliedModifierResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotalPrice: (json['subtotal_price'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemResponseDTOToJson(
        CartItemResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'product_variant': instance.productVariant,
      'applied_modifiers': instance.appliedModifiers,
      'subtotal_price': instance.subtotalPrice,
    };

AppliedModifierResponseDTO _$AppliedModifierResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AppliedModifierResponseDTO(
      quantity: (json['quantity'] as num).toInt(),
      modifier: Modifier.fromJson(json['modifier'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppliedModifierResponseDTOToJson(
        AppliedModifierResponseDTO instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'modifier': instance.modifier,
    };
