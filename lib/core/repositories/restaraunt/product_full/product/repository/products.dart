import 'package:dio/dio.dart';

import '../product.dart';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '/core/hive/models/models.dart';
import '../dto/dto.dart';

class ProductRepository implements AbstractProductRepository {
  ProductRepository({
    required this.dio,
    required this.productsBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<Product> productsBox;
  final String apiSiteUrl;
  static String? get token =>
      GetIt.I<AbstractJWTTokensRepository>().getAccessToken();

  @override
  Future<List<Product>> getProductList() async {
    var productsList = <Product>[];
    try {
      productsList = await _fetchProductListFromApi();
      final productsMap = {for (var e in productsList) e.id: e};
      await productsBox.putAll(productsMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      productsList = productsBox.values.toList();
    }
    return productsList;
  }

  Future<List<Product>> _fetchProductListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/products',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
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
      final productsList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных продукта',
          );
        }
        try {
          final product = Product.fromJson(item);
          return product;
        } catch (e) {
          rethrow;
        }
      }).toList();
      return List<Product>.from(productsList);
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении списка продуктов: $e');
    }
  }

  @override
  Future<Product> getProduct(int productId) async {
    try {
      final product = await _fetchProductFromApi(productId);
      await productsBox.put(product.id, product);
      return product;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      for (var key in productsBox.keys) {
        final product = productsBox.get(key);
        if (product != null && product.id == productId) {
          return product;
        }
      }
      throw Exception('Ошибка при получении продукта: $e');
    }
  }

  Future<Product> _fetchProductFromApi(int productId) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/api/v1/menu/products/$productId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
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

  @override
  Future<Product> postCreateProduct(ProductCreateDTO dto) async {
    try {
      final product = await _fetchCreatedProductFromApi(dto);
      await productsBox.put(product.id, product);
      return product;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при создании продукта: $e');
    }
  }

  Future<Product> _fetchCreatedProductFromApi(ProductCreateDTO dto) async {
    final response = await dio.post(
      '$apiSiteUrl/products',
      data: dto.toJson(),
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        contentType: Headers.jsonContentType,
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
    );

    if (response.statusCode != 201) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Ошибка создания: ${response.statusCode}',
      );
    }

    return Product.fromJson(response.data);
  }

  @override
  Future<Product> patchProduct(int productId, ProductPatchDTO dto) async {
    try {
      final product = await _fetchUpdatedProductFromApi(productId, dto);
      await productsBox.put(product.id, product);
      return product;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при обновлении продукта: $e');
    }
  }

  Future<Product> _fetchUpdatedProductFromApi(
      int productId, ProductPatchDTO dto) async {
    final response = await dio.patch(
      '$apiSiteUrl/products/$productId',
      data: dto.toJson(),
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        contentType: Headers.jsonContentType,
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
    );

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Ошибка обновления: ${response.statusCode}',
      );
    }

    return Product.fromJson(response.data);
  }

  @override
  Future<void> deleteHardProduct(int productId) async {
    try {
      await _deleteHardProductViaApi(productId);
      await productsBox.delete(productId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка жесткого удаления: $e');
    }
  }

  Future<void> _deleteHardProductViaApi(int productId) async {
    final response = await dio.delete(
      '$apiSiteUrl/products/$productId/hard',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
    );

    if (response.statusCode != 204) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Ошибка удаления: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> deleteSoftProduct(int productId) async {
    try {
      await _deleteSoftProductViaApi(productId);
      final product = productsBox.get(productId);
      if (product != null) {
        // Здесь предполагается, что у Product есть поле isDeleted
        await productsBox.put(productId, product.copyWith(isDeleted: true));
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка мягкого удаления: $e');
    }
  }

  Future<void> _deleteSoftProductViaApi(int productId) async {
    final response = await dio.delete(
      '$apiSiteUrl/products/$productId/soft',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
    );

    if (response.statusCode != 204) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Ошибка удаления: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> postRestoreProduct(int productId) async {
    try {
      await _restoreProductViaApi(productId);
      final product = productsBox.get(productId);
      if (product != null) {
        // Здесь предполагается, что у Product есть поле isDeleted
        await productsBox.put(productId, product.copyWith(isDeleted: false));
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка восстановления продукта: $e');
    }
  }

  Future<void> _restoreProductViaApi(int productId) async {
    final response = await dio.post(
      '$apiSiteUrl/products/$productId/restore',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
    );

    if (response.statusCode != 204) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Ошибка восстановления: ${response.statusCode}',
      );
    }
  }
}
