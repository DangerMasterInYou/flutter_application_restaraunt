import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../header_boxes.dart';

part 'category.g.dart';

@HiveType(typeId: HiveHeaders.categoryId)
@JsonSerializable()
class Category {
  Category({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.isDeleted,
  });

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @HiveField(3)
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  Category copyWith({
    int? id,
    String? name,
    int? sortOrder,
    bool? isDeleted,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
