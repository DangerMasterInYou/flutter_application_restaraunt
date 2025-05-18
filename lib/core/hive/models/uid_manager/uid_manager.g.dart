// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uid_manager.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UidManagerAdapter extends TypeAdapter<UidManager> {
  @override
  final int typeId = 1;

  @override
  UidManager read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UidManager(
      lastUidKey: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UidManager obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.lastUidKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UidManagerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UidManager _$UidManagerFromJson(Map<String, dynamic> json) => UidManager(
      lastUidKey: (json['lastUidKey'] as num).toInt(),
    );

Map<String, dynamic> _$UidManagerToJson(UidManager instance) =>
    <String, dynamic>{
      'lastUidKey': instance.lastUidKey,
    };
