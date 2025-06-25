// lib/features/cart/data/dto/response.dart

import 'package:json_annotation/json_annotation.dart';
import '/core/hive/models/menu/menu.dart'; // <-- Укажите правильный путь к вашей модели Menu

part 'response.g.dart';

@JsonSerializable()
class CartResponseDTO {
  @JsonKey(name: 'items')
  final List<CartItemResponseDTO> items;

  @JsonKey(name: 'total_price')
  final int totalPrice;

  CartResponseDTO({
    required this.items,
    required this.totalPrice,
  });

  factory CartResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$CartResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseDTOToJson(this);
}

@JsonSerializable()
class CartItemResponseDTO {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'quantity')
  final int quantity;

  // product_variant теперь соответствует вашей модели Menu
  @JsonKey(name: 'product_variant')
  final Menu productVariant;

  @JsonKey(name: 'applied_modifiers')
  final List<AppliedModifierResponseDTO> appliedModifiers;

  @JsonKey(name: 'subtotal_price')
  final int subtotalPrice;

  CartItemResponseDTO({
    required this.id,
    required this.quantity,
    required this.productVariant,
    required this.appliedModifiers,
    required this.subtotalPrice,
  });

  factory CartItemResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$CartItemResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemResponseDTOToJson(this);
}

@JsonSerializable()
class AppliedModifierResponseDTO {
  @JsonKey(name: 'quantity')
  final int quantity;

  // modifier теперь соответствует вашей модели Modifier
  @JsonKey(name: 'modifier')
  final Modifier modifier;

  AppliedModifierResponseDTO({
    required this.quantity,
    required this.modifier,
  });

  factory AppliedModifierResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AppliedModifierResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AppliedModifierResponseDTOToJson(this);
}