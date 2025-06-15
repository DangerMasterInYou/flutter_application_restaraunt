// import 'package:equatable/equatable.dart';
// import '../cart/cart.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:json_annotation/json_annotation.dart';
// import '../header_boxes.dart';

// part 'order.g.dart';

// @HiveType(typeId: HiveHeaders.statusAdapterId)
// enum Status {
//   @HiveField(0)
//   coffee,
//   @HiveField(1)
//   cola,
//   @HiveField(2)
//   tea,
//   @HiveField(3)
//   milkshake,
//   @HiveField(4)
//   shawarma,
//   @HiveField(5)
//   hotDog,
//   @HiveField(6)
//   frenchFries,
//   @HiveField(7)
//   nuggets,
//   @HiveField(8)
//   strips,
//   @HiveField(9)
//   combo;
  
//   String get russianUpperCase {
//     switch (this) {
//       case Status.coffee:
//         return 'Кофе';
//       case Status.cola:
//         return 'Кола';
//       case Status.tea:
//         return 'Чай';
//       case Status.milkshake:
//         return 'Милкшейк';
//       case Status.shawarma:
//         return 'Шаурма';
//       case Status.hotDog:
//         return 'Хот-дог';
//       case Status.frenchFries:
//         return 'Картофель фри';
//       case Status.nuggets:
//         return 'Наггетсы';
//       case Status.strips:
//         return 'Стрипсы';
//       case Status.combo:
//         return 'Комбо';
//     }
//   }
  
//   String get russianLowerCase {
//     return russianUpperCase.toLowerCase();
//   }
// }

// @HiveType(typeId: HiveHeaders.ordersId)
// @JsonSerializable()
// class Order extends Equatable {
//   const Order({
//     required this.id,
//     required this.active,
//     required this.latitude,
//     required this.longitude,
//     required this.street,
//     required this.house,
//     required this.flat,
//     required this.entrance,
//     required this.floor,
//     required this.comment,
//     required this.sum,
//     required this.paymentMethod,
//     required this.status,
//     required this.orderItems,
//   });

//   @HiveField(0)
//   @JsonKey(name: 'id')
//   final int id;

//   @HiveField(1)
//   @JsonKey(name: 'active')
//   final String active;

//   @HiveField(2)
//   @JsonKey(name: 'latitude')
//   final String latitude;

//   @HiveField(3)
//   @JsonKey(name: 'longitude')
//   final int longitude;

//   @HiveField(4)
//   @JsonKey(name: 'street')
//   final String street;

//   @HiveField(5)
//   @JsonKey(name: 'house')
//   final int house;

//   @HiveField(6)
//   @JsonKey(name: 'flat')
//   final int flat;

//   @HiveField(7)
//   @JsonKey(name: 'entrance')
//   final int entrance;

//   @HiveField(8)
//   @JsonKey(name: 'floor')
//   final bool floor;

//   @HiveField(9)
//   @JsonKey(name: 'comment')
//   final String comment;

//   @HiveField(10)
//   @JsonKey(name: 'sum')
//   final int sum;

//   @HiveField(11)
//   @JsonKey(name: 'payment_method')
//   final bool paymentMethod;

//   @HiveField(12)
//   @JsonKey(name: 'status')
//   final Status status;

//   @HiveField(13)
//   @JsonKey(name: 'order_items')
//   final List<Cart> orderItems;

//   factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
//   Map<String, dynamic> toJson() => _$OrderToJson(this);

//   @override
//   List<Object> get props => [id, active, latitude, longitude, street, house, flat, comment, sum, paymentMethod, status, orderItems];
// }


import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../header_boxes.dart';

part 'order.g.dart';

@HiveType(typeId: HiveHeaders.statusAdapterId)
enum Status {
  @HiveField(0)
  created,
  @HiveField(1)
  rejected,
  @HiveField(2)
  accepted,
  @HiveField(3)
  ready,
  @HiveField(4)
  issued;
  
  String get russianUpperCase {
    switch (this) {
      case Status.created:
        return 'Создан';
      case Status.rejected:
        return 'Отклонен';
      case Status.accepted:
        return 'Принят';
      case Status.ready:
        return 'Готов';
      case Status.issued:
        return 'Выдан';
    }
  }
  
  String get russianLowerCase {
    return russianUpperCase.toLowerCase();
  }
}

@HiveType(typeId: HiveHeaders.ordersId)
@JsonSerializable()
class Order extends Equatable {
  const Order({
    required this.id,
    required this.userId,
    required this.itemsProducts,
    required this.paymentMethod,
    required this.payed,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'user_id')
  final int userId;

  @HiveField(2)
  @JsonKey(name: 'items_products')
  final String itemsProducts;

  @HiveField(3)
  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @HiveField(4)
  @JsonKey(name: 'payed')
  final bool payed;

  @HiveField(5)
  @JsonKey(name: 'status')
  final Status status;

  @HiveField(6)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @HiveField(7)
  @JsonKey(name: 'created_by')
  final String createdBy;

  @HiveField(8)
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @HiveField(9)
  @JsonKey(name: 'updated_by')
  final String updatedBy;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  @override
  List<Object> get props => [
        id,
        userId,
        itemsProducts,
        paymentMethod,
        payed,
        status,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
      ];
}