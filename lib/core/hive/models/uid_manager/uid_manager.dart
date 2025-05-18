import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import '../header_boxes.dart';

part 'uid_manager.g.dart';

@HiveType(typeId: HiveHeaders.uidManagerId)
@JsonSerializable()
class UidManager extends Equatable {
  const UidManager({required this.lastUidKey});

  @HiveField(0)
  @JsonKey(name: 'lastUidKey')
  final int lastUidKey;

  static int getNextUid() {
    final box = Hive.box(HiveHeaders.uidManagerNameBox);
    int lastUid = box.get('lastUidKey', defaultValue: 0) as int;
    lastUid += 1;
    box.put('lastUidKey', lastUid);
    return lastUid;
  }

  factory UidManager.fromJson(Map<String, dynamic> json) => _$UidManagerFromJson(json);
  Map<String, dynamic> toJson() => _$UidManagerToJson(this);

  @override
  List<Object> get props => [lastUidKey];
}
