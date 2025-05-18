import 'package:dio/dio.dart';

import '../products.dart';


import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ProductsRepository implements AbstractProductsRepository {
  ProductsRepository({
    required this.dio,
    required this.productsBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<Product> productsBox;
  final String apiSiteUrl;

  @override
  Future<List<Product>> getProductsList() async {
    var productsList = <Product>[];
    try {
      productsList = await _fetchProductsListFromApi();
      final productsMap = {for (var e in productsList) e.id: e};
      await productsBox.putAll(productsMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      productsList = productsBox.values.toList();
    }

    productsList.sort((a, b) => b.price.compareTo(a.price));
    return productsList;
  }

  Future<List<Product>> _fetchProductsListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/products',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
    
      print('Статус ответа: ${response.statusCode}');
      print('Данные ответа: ${response.data}');

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
    
      print('Количество элементов в списке: ${data.length}');
      
      if (data.isNotEmpty) {
        print('Первый элемент: ${data[0]}');
      }

      final productsList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных продукта',
          );
        }
        try {
          print('Преобразование элемента: $item');
          final product = Product.fromJson(item);
          print('Успешно преобразовано в Product: ${product.name}');
          return product;
        } catch (e) {
          print('Ошибка при преобразовании элемента: $e');
          rethrow;
        }
      }).toList();
      
      print('Количество преобразованных продуктов: ${productsList.length}');
      return productsList;
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении списка продукт: $e');
    }
  }

  @override
  Future<Product> getProduct(int productId) async {
    try {
      final product = await _fetchProductFromApi(productId);
      await productsBox.put(productId, product);
      return product;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      return productsBox.get(productId)!;
    }
  }

  Future<Product> _fetchProductFromApi(int productId) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/product/$productId',
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

      final productData = response.data;
      if (productData is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неожиданный формат ответа для продукта $productId',
        );
      }
      
      final product = Product.fromJson(productData);
      return product;
    } catch (e) {
      throw Exception('Ошибка при получении продукта: $e');
    }
  }
}
