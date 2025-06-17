import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../header_boxes.dart';

part 'modifier_group_association.g.dart';

@HiveType(typeId: HiveHeaders.modifierGroupAssociationId)
@JsonSerializable()
class ModifierGroupAssociation {
  ModifierGroupAssociation({
    required this.id,
    required this.productVariantId,
    required this.modifierGroupId,
    required this.isDeleted,
  });

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'product_variant_id')
  final int productVariantId;

  @HiveField(2)
  @JsonKey(name: 'modifier_group_id')
  final int modifierGroupId;

  @HiveField(3)
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  factory ModifierGroupAssociation.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupAssociationFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierGroupAssociationToJson(this);

  ModifierGroupAssociation copyWith({
    int? id,
    int? productVariantId,
    int? modifierGroupId,
    bool? isDeleted,
  }) {
    return ModifierGroupAssociation(
      id: id ?? this.id,
      productVariantId: productVariantId ?? this.productVariantId,
      modifierGroupId: modifierGroupId ?? this.modifierGroupId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
