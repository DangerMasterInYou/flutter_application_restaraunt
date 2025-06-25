import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

@JsonSerializable()
class ModifierCreateDTO {
  const ModifierCreateDTO._({
    required this.name,
    required this.priceDelta,
  });

  factory ModifierCreateDTO({
    required String name,
    required int priceDelta,
  }) {
    return ModifierCreateDTO._(
      name: name,
      priceDelta: priceDelta,
    );
  }

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'price_delta')
  final int priceDelta;

  factory ModifierCreateDTO.fromJson(Map<String, dynamic> json) =>
      _$ModifierCreateDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierCreateDTOToJson(this);
}

@JsonSerializable()
class ModifierPatchDTO {
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;

  @JsonKey(name: 'price_delta', includeIfNull: false)
  final int? priceDelta;

  ModifierPatchDTO({
    this.name,
    this.priceDelta,
  });

  factory ModifierPatchDTO.fromJson(Map<String, dynamic> json) =>
      _$ModifierPatchDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ModifierPatchDTOToJson(this);
}
