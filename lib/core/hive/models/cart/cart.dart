import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import '../header_boxes.dart';

part 'cart.g.dart';
@HiveType(typeId: HiveHeaders.cartsId)
@JsonSerializable()
class Cart extends Equatable {
  const Cart({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.count,
  });

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'price')
  final int price;

  @HiveField(3)
  @JsonKey(name: 'image_url')
  final String imageUrl;
  String get fullImageUrl => imageUrl;

  @HiveField(4)
  @JsonKey(name: 'count')
  final int count;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);

  @override
  List<Object> get props => [id, name, price, imageUrl, count];
}
