  import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class ModifierGroupResponse {
  const ModifierGroupResponse({
    required this.id,
    required this.name,
    required this.isRequired,
    required this.isMultiselect,
    required this.isDeleted,
    required this.modifiers,
  });

  final int id;

  final String name;

  @JsonKey(name: 'is_required')
  final bool isRequired;

  @JsonKey(name: 'is_multiselect')
  final bool isMultiselect;

  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  final List<ModifierResponse> modifiers;

  factory ModifierGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModifierGroupResponseToJson(this);
}

@JsonSerializable()
class ModifierResponse {
  const ModifierResponse({
    required this.id,
    required this.name,
    required this.priceDelta,
    // required this.isDeleted,
  });

  final int id;

  final String name;

  @JsonKey(name: 'price_delta')
  final int priceDelta;

  // @JsonKey(name: 'is_deleted')
  // final bool isDeleted;

  factory ModifierResponse.fromJson(Map<String, dynamic> json) =>
      _$ModifierResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModifierResponseToJson(this);
}