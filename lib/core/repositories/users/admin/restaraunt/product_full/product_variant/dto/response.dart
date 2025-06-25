import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class VariantResponse {
  const VariantResponse({
    required this.id,
    required this.productId,
    required this.name,
    this.description,
    this.imageUrl,
    required this.price,
    required this.sku,
    this.value,
    this.unit,
    required this.isAvailable,
    required this.isDeleted,
    required this.isCombo,
  });

  final int id;

  @JsonKey(name: 'product_id')
  final int productId;

  final String name;

  final String? description;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  final int price;

  final String sku;

  final double? value;

  final String? unit;

  @JsonKey(name: 'is_available')
  final bool isAvailable;

  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @JsonKey(name: 'is_combo')
  final bool isCombo;

  factory VariantResponse.fromJson(Map<String, dynamic> json) =>
      _$VariantResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VariantResponseToJson(this);
}