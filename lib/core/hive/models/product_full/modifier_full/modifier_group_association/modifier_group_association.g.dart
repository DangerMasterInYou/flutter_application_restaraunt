// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_group_association.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModifierGroupAssociationAdapter
    extends TypeAdapter<ModifierGroupAssociation> {
  @override
  final int typeId = 22;

  @override
  ModifierGroupAssociation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModifierGroupAssociation(
      id: fields[0] as int,
      productVariantId: fields[1] as int,
      modifierGroupId: fields[2] as int,
      isDeleted: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ModifierGroupAssociation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productVariantId)
      ..writeByte(2)
      ..write(obj.modifierGroupId)
      ..writeByte(3)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModifierGroupAssociationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierGroupAssociation _$ModifierGroupAssociationFromJson(
        Map<String, dynamic> json) =>
    ModifierGroupAssociation(
      id: (json['id'] as num).toInt(),
      productVariantId: (json['product_variant_id'] as num).toInt(),
      modifierGroupId: (json['modifier_group_id'] as num).toInt(),
      isDeleted: json['is_deleted'] as bool,
    );

Map<String, dynamic> _$ModifierGroupAssociationToJson(
        ModifierGroupAssociation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_variant_id': instance.productVariantId,
      'modifier_group_id': instance.modifierGroupId,
      'is_deleted': instance.isDeleted,
    };
