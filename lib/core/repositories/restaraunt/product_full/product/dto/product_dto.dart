// ignore_for_file: invalid_annotation_target
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductCreateDTO extends Equatable {
  const ProductCreateDTO._({
    required this.name,
    required this.description,
    required this.sortOrder,
    required this.imageUrl,
    required this.categoryId,
  });

  factory ProductCreateDTO({
    required String name,
    required String description,
    required int sortOrder,
    required String imageUrl,
    required int categoryId,
  }) {
    return ProductCreateDTO._(
      name: name,
      description: description,
      sortOrder: sortOrder,
      imageUrl: imageUrl,
      categoryId: categoryId,
    );
  }

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @JsonKey(name: 'image_url')
  final String imageUrl;

  @JsonKey(name: 'category_id')
  final int categoryId;

  factory ProductCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$ProductCreateDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCreateDTOToJson(this);

  @override
  List<Object> get props => [];
}

@JsonSerializable()
class ProductPatchDTO {
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;

  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;

  @JsonKey(name: 'sort_order', includeIfNull: false)
  final int? sortOrder;

  @JsonKey(name: 'image_url', includeIfNull: false)
  final String? imageUrl;

  @JsonKey(name: 'category_id', includeIfNull: false)
  final int? categoryId;

  ProductPatchDTO({
    this.name,
    this.description,
    this.sortOrder,
    this.imageUrl,
    this.categoryId,
  });

  factory ProductPatchDTO.fromJson(Map<String, dynamic> json) =>
      _$ProductPatchDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProductPatchDTOToJson(this);
}
