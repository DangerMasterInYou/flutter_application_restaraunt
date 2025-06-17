import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../header_boxes.dart';

part 'modifier.g.dart';

@HiveType(typeId: HiveHeaders.modifiersId)
@JsonSerializable()
class Modifier {
  Modifier({
    required this.id,
    required this.name,
    required this.priceDelta,
    required this.groupId,
    required this.isDeleted,
  });

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'price_delta')
  final int priceDelta;

  @HiveField(3)
  @JsonKey(name: 'group_id')
  final int groupId;

  @HiveField(4)
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierToJson(this);

  Modifier copyWith({
    int? id,
    String? name,
    int? priceDelta,
    int? groupId,
    bool? isDeleted,
  }) {
    return Modifier(
      id: id ?? this.id,
      name: name ?? this.name,
      priceDelta: priceDelta ?? this.priceDelta,
      groupId: groupId ?? this.groupId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
