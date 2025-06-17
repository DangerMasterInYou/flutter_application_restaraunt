// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductVariantAdapter extends TypeAdapter<ProductVariant> {
  @override
  final int typeId = 21;

  @override
  ProductVariant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductVariant(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as int,
      imageUrl: fields[4] as String?,
      value: fields[5] as int?,
      unit: fields[6] as String?,
      sku: fields[7] as String,
      isAvailable: fields[8] as bool,
      isCombo: fields[9] as bool,
      productId: fields[10] as int,
      isDeleted: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductVariant obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.value)
      ..writeByte(6)
      ..write(obj.unit)
      ..writeByte(7)
      ..write(obj.sku)
      ..writeByte(8)
      ..write(obj.isAvailable)
      ..writeByte(9)
      ..write(obj.isCombo)
      ..writeByte(10)
      ..write(obj.productId)
      ..writeByte(11)
      ..write(obj.isDeleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductVariant _$ProductVariantFromJson(Map<String, dynamic> json) =>
    ProductVariant(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      imageUrl: json['image_url'] as String?,
      value: (json['value'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      sku: json['sku'] as String,
      isAvailable: json['is_available'] as bool,
      isCombo: json['is_combo'] as bool,
      productId: (json['product_id'] as num).toInt(),
      isDeleted: json['is_deleted'] as bool,
    );

Map<String, dynamic> _$ProductVariantToJson(ProductVariant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image_url': instance.imageUrl,
      'value': instance.value,
      'unit': instance.unit,
      'sku': instance.sku,
      'is_available': instance.isAvailable,
      'is_combo': instance.isCombo,
      'product_id': instance.productId,
      'is_deleted': instance.isDeleted,
    };
