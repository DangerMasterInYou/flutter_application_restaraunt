import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../header_boxes.dart';

part 'product_variant.g.dart';

@HiveType(typeId: HiveHeaders.productVariantId)
@JsonSerializable()
class ProductVariant {
  ProductVariant({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.value,
    required this.unit,
    required this.sku,
    required this.isAvailable,
    required this.isCombo,
    required this.productId,
    required this.isDeleted,
  });

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'description')
  final String description;

  @HiveField(3)
  @JsonKey(name: 'price')
  final int price;

  @HiveField(4)
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @HiveField(5)
  @JsonKey(name: 'value')
  final int? value;

  @HiveField(6)
  @JsonKey(name: 'unit')
  final String? unit;

  @HiveField(7)
  @JsonKey(name: 'sku')
  final String sku;

  @HiveField(8)
  @JsonKey(name: 'is_available')
  final bool isAvailable;

  @HiveField(9)
  @JsonKey(name: 'is_combo')
  final bool isCombo;

  @HiveField(10)
  @JsonKey(name: 'product_id')
  final int productId;

  @HiveField(11)
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);
  Map<String, dynamic> toJson() => _$ProductVariantToJson(this);

  ProductVariant copyWith({
    int? id,
    String? name,
    String? description,
    int? price,
    String? imageUrl,
    int? value,
    String? unit,
    String? sku,
    bool? isAvailable,
    bool? isCombo,
    int? productId,
    bool? isDeleted,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      sku: sku ?? this.sku,
      isAvailable: isAvailable ?? this.isAvailable,
      isCombo: isCombo ?? this.isCombo,
      productId: productId ?? this.productId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
