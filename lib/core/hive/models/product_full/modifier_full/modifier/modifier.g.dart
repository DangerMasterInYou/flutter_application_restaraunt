// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModifierAdapter extends TypeAdapter<Modifier> {
  @override
  final int typeId = 24;

  @override
  Modifier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Modifier(
      id: fields[0] as int,
      name: fields[1] as String,
      priceDelta: fields[2] as int,
      groupId: fields[3] as int,
      isDeleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Modifier obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.priceDelta)
      ..writeByte(3)
      ..write(obj.groupId)
      ..writeByte(4)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModifierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Modifier _$ModifierFromJson(Map<String, dynamic> json) => Modifier(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      priceDelta: (json['price_delta'] as num).toInt(),
      groupId: (json['group_id'] as num).toInt(),
      isDeleted: json['is_deleted'] as bool,
    );

Map<String, dynamic> _$ModifierToJson(Modifier instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price_delta': instance.priceDelta,
      'group_id': instance.groupId,
      'is_deleted': instance.isDeleted,
    };
