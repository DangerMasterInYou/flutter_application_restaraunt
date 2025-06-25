import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class ModifierResponse {
  const ModifierResponse._({
    required this.id,
    required this.name,
    required this.priceDelta,
    required this.groupId,
    // required this.isDeleted,
  });

  factory ModifierResponse({
    required int id,
    required String name,
    required int priceDelta,
    required int groupId,
    // required bool isDeleted,
  }) {
    return ModifierResponse._(
      id: id,
      name: name,
      priceDelta: priceDelta,
      groupId: groupId,
      // isDeleted: isDeleted,
    );
  }

  final int id;

  final String name;

  @JsonKey(name: 'price_delta')
  final int priceDelta;

  @JsonKey(name: 'group_id')
  final int groupId;

  // @JsonKey(name: 'is_deleted')
  // final bool isDeleted;

  factory ModifierResponse.fromJson(Map<String, dynamic> json) =>
      _$ModifierResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierResponseToJson(this);

  ModifierResponse copyWith({
    int? id,
    String? name,
    int? priceDelta,
    int? groupId,
    // bool? isDeleted,
  }) {
    return ModifierResponse(
      id: id ?? this.id,
      name: name ?? this.name,
      priceDelta: priceDelta ?? this.priceDelta,
      groupId: groupId ?? this.groupId,
      // isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
