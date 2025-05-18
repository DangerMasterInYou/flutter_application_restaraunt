// import 'dart:developer';

// import 'package:dio/dio.dart';

// import 'package:flutter_food_order/core/repositories/imports/users/auth/login/abstract_login.dart';
// import 'package:get_it/get_it.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:talker_flutter/talker_flutter.dart';

// class LoginRepository implements AbstractLoginRepository {
//   LoginRepository({
//     required this.dio,
//     required this.loginBox,
//     required this.apiSiteUrl,
//   });

//   final Dio dio;
//   final Box<Login> loginBox;
//   final String apiSiteUrl;

//   @override
//   Future<Login> postLogin(String email, String password) async {
//     var login = <Login>;
//     try {
//       login = await _fetchLoginFromApi();
//       loginBox.put(dishId, dish);
//       return dish;
//     } catch (e, st) {
//       GetIt.instance<Talker>().handle(e, st);
//       dishesList = dishesBox.values.toList();
//     }

//     dishesList.sort((a, b) => b.price.compareTo(a.price));
//     return dishesList;
//   }

//   Future<List<Dish>> _fetchLoginFromApi() async {
//     final response = await dio.get('$apiSiteUrl/menu');

//     print('Response data: ${response.data}');
//     print('Response status code: ${response.statusCode}');

//     if (response.statusCode != 200) {
//       throw Exception('Ошибка при загрузке данных: ${response.statusCode}');
//     }

//     final data = response.data as Map<String, dynamic>;
//     final dishesList =
//         data.entries.map((e) {
//           final dishData = e.value as Map<String, dynamic>;
//           return _jsonToMapDish(dishData);
//         }).toList();
//     return dishesList;
//   }

//   Login _jsonToMapDish(Map<String, dynamic> dishData) {
//     Login dish = Login(
//       id: dishData['id'] as int,
//       name: dishData['name'] as String,
//       description: dishData['description'] as String,
//       category: dishData['category'] as String,
//       imageUrl: dishData['image_url'] as String,
//       price: dishData['price'] as int,
//     );

//     return dish;
//   }
// }
