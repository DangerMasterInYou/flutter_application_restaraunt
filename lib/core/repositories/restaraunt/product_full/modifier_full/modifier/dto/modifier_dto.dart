import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'modifier_dto.g.dart';

@JsonSerializable()
class ModifierCreateDTO extends Equatable {
  const ModifierCreateDTO._({
    required this.name,
    required this.priceDelta,
    required this.groupId,
  });

  factory ModifierCreateDTO({
    required String name,
    required int priceDelta,
    required int groupId,
  }) {
    return ModifierCreateDTO._(
      name: name,
      priceDelta: priceDelta,
      groupId: groupId,
    );
  }

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'price_delta')
  final int priceDelta;

  @JsonKey(name: 'group_id')
  final int groupId;

  factory ModifierCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$ModifierCreateDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierCreateDTOToJson(this);

  @override
  List<Object> get props => [];
}

@JsonSerializable()
class ModifierPatchDTO {
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;

  @JsonKey(name: 'price_delta', includeIfNull: false)
  final int? priceDelta;

  @JsonKey(name: 'group_id', includeIfNull: false)
  final int? groupId;

  ModifierPatchDTO({
    this.name,
    this.priceDelta,
    this.groupId,
  });

  factory ModifierPatchDTO.fromJson(Map<String, dynamic> json) =>
      _$ModifierPatchDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ModifierPatchDTOToJson(this);
}
