import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'modifier_group_association.g.dart';

@JsonSerializable()
class ModifierGroupAssociationCreateDTO extends Equatable {
  const ModifierGroupAssociationCreateDTO._({
    required this.name,
    required this.isRequired,
    required this.isMultiselect,
  });

  factory ModifierGroupAssociationCreateDTO({
    required String name,
    required bool isRequired,
    required bool isMultiselect,
  }) {
    return ModifierGroupAssociationCreateDTO._(
      name: name,
      isRequired: isRequired,
      isMultiselect: isMultiselect,
    );
  }

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'is_required')
  final bool isRequired;

  @JsonKey(name: 'is_multiselect')
  final bool isMultiselect;

  factory ModifierGroupAssociationCreateDTO.fromJson(
          Map<String, dynamic> json) =>
      _$ModifierGroupAssociationCreateDTOFromJson(json);
  Map<String, dynamic> toJson() =>
      _$ModifierGroupAssociationCreateDTOToJson(this);

  @override
  List<Object> get props => [];
}

@JsonSerializable()
class ModifierGroupAssociationPatchDTO {
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;

  @JsonKey(name: 'is_required', includeIfNull: false)
  final bool? isRequired;

  @JsonKey(name: 'is_multiselect', includeIfNull: false)
  final bool? isMultiselect;

  ModifierGroupAssociationPatchDTO({
    this.name,
    this.isRequired,
    this.isMultiselect,
  });

  factory ModifierGroupAssociationPatchDTO.fromJson(
          Map<String, dynamic> json) =>
      _$ModifierGroupAssociationPatchDTOFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ModifierGroupAssociationPatchDTOToJson(this);
}
