import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import '../header_boxes.dart';

part 'product.g.dart';

@HiveType(typeId: HiveHeaders.categoryAdapterId)
enum Category {
  @HiveField(0)
  coffee,
  @HiveField(1)
  cola,
  @HiveField(2)
  tea,
  @HiveField(3)
  milkshake,
  @HiveField(4)
  shawarma,
  @HiveField(5)
  hotDog,
  @HiveField(6)
  frenchFries,
  @HiveField(7)
  nuggets,
  @HiveField(8)
  strips,
  @HiveField(9)
  combo;
  
  String get russianUpperCase {
    switch (this) {
      case Category.coffee:
        return 'Кофе';
      case Category.cola:
        return 'Кола';
      case Category.tea:
        return 'Чай';
      case Category.milkshake:
        return 'Милкшейк';
      case Category.shawarma:
        return 'Шаурма';
      case Category.hotDog:
        return 'Хот-дог';
      case Category.frenchFries:
        return 'Картофель фри';
      case Category.nuggets:
        return 'Наггетсы';
      case Category.strips:
        return 'Стрипсы';
      case Category.combo:
        return 'Комбо';
    }
  }
  
  String get russianLowerCase {
    return russianUpperCase.toLowerCase();
  }
}

@HiveType(typeId: HiveHeaders.productsId)
@JsonSerializable()
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.weightG,
    required this.volumeMl,
    required this.stock,
    required this.isAvailable,
    required this.category,
  });

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'description')
  final String description;

  @HiveField(3)
  @JsonKey(name: 'price')
  final int price;

  @HiveField(4)
  @JsonKey(name: 'image_url')
  final String imageUrl;
  String get fullImageUrl => imageUrl;

  @HiveField(5)
  @JsonKey(name: 'weight_g')
  final int weightG;

  @HiveField(6)
  @JsonKey(name: 'volume_ml')
  final int volumeMl;

  @HiveField(7)
  @JsonKey(name: 'stock')
  final int stock;

  @HiveField(8)
  @JsonKey(name: 'is_available')
  final bool isAvailable;

  @HiveField(9)
  @JsonKey(name: 'category')
  final Category category;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object> get props => [id, name, description, price, imageUrl, weightG, volumeMl, stock, isAvailable, category];
}
