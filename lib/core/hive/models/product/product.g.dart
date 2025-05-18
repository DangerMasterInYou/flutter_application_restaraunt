// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 3;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as int,
      imageUrl: fields[4] as String,
      weightG: fields[5] as int,
      volumeMl: fields[6] as int,
      stock: fields[7] as int,
      isAvailable: fields[8] as bool,
      category: fields[9] as Category,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.weightG)
      ..writeByte(6)
      ..write(obj.volumeMl)
      ..writeByte(7)
      ..write(obj.stock)
      ..writeByte(8)
      ..write(obj.isAvailable)
      ..writeByte(9)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 7;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.coffee;
      case 1:
        return Category.cola;
      case 2:
        return Category.tea;
      case 3:
        return Category.milkshake;
      case 4:
        return Category.shawarma;
      case 5:
        return Category.hotDog;
      case 6:
        return Category.frenchFries;
      case 7:
        return Category.nuggets;
      case 8:
        return Category.strips;
      case 9:
        return Category.combo;
      default:
        return Category.coffee;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.coffee:
        writer.writeByte(0);
        break;
      case Category.cola:
        writer.writeByte(1);
        break;
      case Category.tea:
        writer.writeByte(2);
        break;
      case Category.milkshake:
        writer.writeByte(3);
        break;
      case Category.shawarma:
        writer.writeByte(4);
        break;
      case Category.hotDog:
        writer.writeByte(5);
        break;
      case Category.frenchFries:
        writer.writeByte(6);
        break;
      case Category.nuggets:
        writer.writeByte(7);
        break;
      case Category.strips:
        writer.writeByte(8);
        break;
      case Category.combo:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
      imageUrl: json['image_url'] as String,
      weightG: (json['weight_g'] as num).toInt(),
      volumeMl: (json['volume_ml'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      isAvailable: json['is_available'] as bool,
      category: $enumDecode(_$CategoryEnumMap, json['category']),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image_url': instance.imageUrl,
      'weight_g': instance.weightG,
      'volume_ml': instance.volumeMl,
      'stock': instance.stock,
      'is_available': instance.isAvailable,
      'category': _$CategoryEnumMap[instance.category]!,
    };

const _$CategoryEnumMap = {
  Category.coffee: 'coffee',
  Category.cola: 'cola',
  Category.tea: 'tea',
  Category.milkshake: 'milkshake',
  Category.shawarma: 'shawarma',
  Category.hotDog: 'hotDog',
  Category.frenchFries: 'frenchFries',
  Category.nuggets: 'nuggets',
  Category.strips: 'strips',
  Category.combo: 'combo',
};
