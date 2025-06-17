// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo_bundle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComboBundleAdapter extends TypeAdapter<ComboBundle> {
  @override
  final int typeId = 25;

  @override
  ComboBundle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComboBundle(
      id: fields[0] as int,
      comboVariantId: fields[1] as int,
      includedVariantId: fields[2] as int,
      quantity: fields[3] as int,
      isDeleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ComboBundle obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.comboVariantId)
      ..writeByte(2)
      ..write(obj.includedVariantId)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComboBundleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComboBundle _$ComboBundleFromJson(Map<String, dynamic> json) => ComboBundle(
      id: (json['id'] as num).toInt(),
      comboVariantId: (json['combo_variant_id'] as num).toInt(),
      includedVariantId: (json['included_variant_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      isDeleted: json['is_deleted'] as bool,
    );

Map<String, dynamic> _$ComboBundleToJson(ComboBundle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'combo_variant_id': instance.comboVariantId,
      'included_variant_id': instance.includedVariantId,
      'quantity': instance.quantity,
      'is_deleted': instance.isDeleted,
    };
