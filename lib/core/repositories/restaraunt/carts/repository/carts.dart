import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../carts.dart';

class CartsRepository implements AbstractCartsRepository {
  CartsRepository({
    required this.dio,
    required this.cartsBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<Cart> cartsBox;
  final String apiSiteUrl;

  @override
  Future<List<Cart>> getCartsList() async {
    var cartsList = <Cart>[];
    try {
      // cartsList = await _fetchCartsListFromApi();
      cartsList = cartsBox.values.toList();
      final cartsMap = {for (var e in cartsList) e.id: e};
      await cartsBox.putAll(cartsMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      cartsList = cartsBox.values.toList();
    }

    cartsList.sort((a, b) => b.price.compareTo(a.price));
    return cartsList;
  }

  Future<List<Cart>> _fetchCartsListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/carts',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Ошибка при загрузке данных: ${response.statusCode}',
        );
      }

      final data = response.data;
      if (data is! List) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неожиданный формат ответа',
        );
      }

      final dishesList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных блюда',
          );
        }
        return Cart.fromJson(item);
      }).toList();
      
      return dishesList;
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении списка блюд: $e');
    }
  }

  @override
  Future<void> postAddItemCart(Cart itemCart) async {
    try {
      final existingItem = cartsBox.get(itemCart.id);
      
      if (existingItem != null) {
        final updatedCart = Cart(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          count: existingItem.count + 1,
          imageUrl: existingItem.imageUrl,
        );
        
        cartsBox.put(existingItem.id, updatedCart);
      } else {
        cartsBox.put(itemCart.id, itemCart);
      }

      // await dio.post(
      //   '$apiSiteUrl/cart',
      //   data: {'item': itemCart, 'operand': 'add'},
      //   options: Options(
      //     receiveTimeout: const Duration(seconds: 5),
      //     sendTimeout: const Duration(seconds: 5),
      //   ),
      // );
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
    }
  }

  @override
  Future<void> postSubtractItemCart(Cart itemCart) async {
    try {
      final existingItemList = cartsBox.values.where(
        (item) => item.id == itemCart.id
      ).toList();
      
      if (existingItemList.isNotEmpty) {
        final existingItem = existingItemList.first;
        
        if (existingItem.count > 1) {
          final updatedCart = Cart(
            id: existingItem.id,
            name: existingItem.name,
            price: existingItem.price,
            count: existingItem.count - 1,
            imageUrl: existingItem.imageUrl,
          );
          
          cartsBox.put(existingItem.id, updatedCart);
        } else {
          cartsBox.delete(existingItem.id);
        }
      }
      
      // await dio.post(
      //   '$apiSiteUrl/cart',
      //   data: {'item': itemCart, 'operand': 'subtract'},
      //   options: Options(
      //     receiveTimeout: const Duration(seconds: 5),
      //     sendTimeout: const Duration(seconds: 5),
      //   ),
      // );
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
    }
  }

  @override
  Future<void> postDeleteItemCart(Cart itemCart) async {
    try {
      final existingItem = cartsBox.get(itemCart.id);
      
      if (existingItem != null) {
        cartsBox.delete(itemCart.id);
      }
      
      // await dio.post(
      //   '$apiSiteUrl/cart',
      //   data: {'item': itemCart, 'operand': 'delete'},
      //   options: Options(
      //     receiveTimeout: const Duration(seconds: 5),
      //     sendTimeout: const Duration(seconds: 5),
      //   ),
      // );
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
    }
  }
}
