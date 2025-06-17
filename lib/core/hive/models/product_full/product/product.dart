import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../header_boxes.dart';

part 'product.g.dart';

@HiveType(typeId: HiveHeaders.productsId)
@JsonSerializable()
class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.sortOrder,
    required this.imageUrl,
    required this.categoryId,
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
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @HiveField(4)
  @JsonKey(name: 'image_url')
  final String imageUrl;

  @HiveField(5)
  @JsonKey(name: 'category_id')
  final int categoryId;

  @HiveField(6)
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    int? id,
    String? name,
    String? description,
    int? sortOrder,
    String? imageUrl,
    int? categoryId,
    bool? isDeleted,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
