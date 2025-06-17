// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModifierGroupAdapter extends TypeAdapter<ModifierGroup> {
  @override
  final int typeId = 22;

  @override
  ModifierGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModifierGroup(
      id: fields[0] as int,
      name: fields[1] as String,
      isRequired: fields[2] as bool,
      isMultiselect: fields[3] as bool,
      isDeleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ModifierGroup obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isRequired)
      ..writeByte(3)
      ..write(obj.isMultiselect)
      ..writeByte(4)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModifierGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierGroup _$ModifierGroupFromJson(Map<String, dynamic> json) =>
    ModifierGroup(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isRequired: json['is_required'] as bool,
      isMultiselect: json['is_multiselect'] as bool,
      isDeleted: json['is_deleted'] as bool,
    );

Map<String, dynamic> _$ModifierGroupToJson(ModifierGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_required': instance.isRequired,
      'is_multiselect': instance.isMultiselect,
      'is_deleted': instance.isDeleted,
    };
