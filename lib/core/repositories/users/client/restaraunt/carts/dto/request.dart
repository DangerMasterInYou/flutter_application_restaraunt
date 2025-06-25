// lib/features/cart/data/dto/request.dart

import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

// Для эндпоинта POST /cart/items
@JsonSerializable()
class CartItemRequestDTO {
  @JsonKey(name: 'product_variant_id')
  final int productVariantId;

  @JsonKey(name: 'quantity')
  final int quantity;

  @JsonKey(name: 'modifier_ids')
  final List<int> modifierIds;

  CartItemRequestDTO({
    required this.productVariantId,
    required this.quantity,
    this.modifierIds = const [],
  });

  factory CartItemRequestDTO.fromJson(Map<String, dynamic> json) =>
      _$CartItemRequestDTOFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemRequestDTOToJson(this);
}