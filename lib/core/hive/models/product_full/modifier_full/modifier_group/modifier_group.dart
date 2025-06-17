import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../header_boxes.dart';

part 'modifier_group.g.dart';

@HiveType(typeId: HiveHeaders.modifierGroupId)
@JsonSerializable()
class ModifierGroup {
  ModifierGroup({
    required this.id,
    required this.name,
    required this.isRequired,
    required this.isMultiselect,
    required this.isDeleted,
  });

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'is_required')
  final bool isRequired;

  @HiveField(3)
  @JsonKey(name: 'is_multiselect')
  final bool isMultiselect;

  @HiveField(4)
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  factory ModifierGroup.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierGroupToJson(this);

  ModifierGroup copyWith({
    int? id,
    String? name,
    bool? isRequired,
    bool? isMultiselect,
    bool? isDeleted,
  }) {
    return ModifierGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      isRequired: isRequired ?? this.isRequired,
      isMultiselect: isMultiselect ?? this.isMultiselect,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
