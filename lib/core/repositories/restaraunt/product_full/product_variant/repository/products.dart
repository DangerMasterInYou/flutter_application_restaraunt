import 'package:dio/dio.dart';

import '../product_variant.dart';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ProductVariantRepository implements AbstractProductVariantRepository {
  ProductVariantRepository({
    required this.dio,
    required this.productVariantBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<ProductVariant> productVariantBox;
  final String apiSiteUrl;
  static String? get token =>
      GetIt.I<AbstractJWTTokensRepository>().getAccessToken();

  @override
  Future<List<ProductVariant>> getProductVariantList() async {
    var productVariantList = <ProductVariant>[];
    try {
      productVariantList = await _fetchProductVariantListFromApi();
      final productVariantMap = {for (var e in productVariantList) e.id: e};
      await productVariantBox.putAll(productVariantMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      productVariantList = productVariantBox.values.toList();
    }
    return productVariantList;
  }

  Future<List<ProductVariant>> _fetchProductVariantListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/product_variants',
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
      final productVariantList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных варианта продукта',
          );
        }
        try {
          final productVariant = ProductVariant.fromJson(item);
          return productVariant;
        } catch (e) {
          rethrow;
        }
      }).toList();
      return List<ProductVariant>.from(productVariantList);
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении списка вариантов продукта: $e');
    }
  }

  @override
  Future<ProductVariant> getProductVariant(int productVariantId) async {
    try {
      final productVariant =
          await _fetchProductVariantFromApi(productVariantId);
      await productVariantBox.put(productVariant.id, productVariant);
      return productVariant;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      for (var key in productVariantBox.keys) {
        final productVariant = productVariantBox.get(key);
        if (productVariant != null && productVariant.id == productVariantId) {
          return productVariant;
        }
      }
      throw Exception('Ошибка при получении варианта продукта: $e');
    }
  }

  Future<ProductVariant> _fetchProductVariantFromApi(
      int productVariantId) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/product_variants/$productVariantId',
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
      final productVariantData = response.data;
      if (productVariantData is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'Неожиданный формат ответа для варианта продукта $productVariantId',
        );
      }
      final productVariant = ProductVariant.fromJson(productVariantData);
      return productVariant;
    } catch (e) {
      throw Exception('Ошибка при получении варианта продукта: $e');
    }
  }

  @override
  Future<ProductVariant> postCreateProductVariant(
      ProductVariantCreateDTO dto) async {
    try {
      final productVariant = await _fetchCreatedProductVariantFromApi(dto);
      await productVariantBox.put(productVariant.id, productVariant);
      return productVariant;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при создании варианта продукта: $e');
    }
  }

  Future<ProductVariant> _fetchCreatedProductVariantFromApi(
      ProductVariantCreateDTO dto) async {
    final response = await dio.post(
      '$apiSiteUrl/product_variants',
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

    return ProductVariant.fromJson(response.data);
  }

  @override
  Future<ProductVariant> patchProductVariant(
      int productVariantId, ProductVariantPatchDTO dto) async {
    try {
      final productVariant =
          await _fetchUpdatedProductVariantFromApi(productVariantId, dto);
      await productVariantBox.put(productVariant.id, productVariant);
      return productVariant;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при обновлении варианта продукта: $e');
    }
  }

  Future<ProductVariant> _fetchUpdatedProductVariantFromApi(
      int productVariantId, ProductVariantPatchDTO dto) async {
    final response = await dio.patch(
      '$apiSiteUrl/product_variants/$productVariantId',
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

    return ProductVariant.fromJson(response.data);
  }

  @override
  Future<void> deleteHardProductVariant(int productVariantId) async {
    try {
      await _deleteHardProductVariantViaApi(productVariantId);
      await productVariantBox.delete(productVariantId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка жесткого удаления: $e');
    }
  }

  Future<void> _deleteHardProductVariantViaApi(int productVariantId) async {
    final response = await dio.delete(
      '$apiSiteUrl/product_variants/$productVariantId/hard',
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
  Future<void> deleteSoftProductVariant(int productVariantId) async {
    try {
      await _deleteSoftProductVariantViaApi(productVariantId);
      final productVariant = productVariantBox.get(productVariantId);
      if (productVariant != null) {
        await productVariantBox.put(
          productVariantId,
          productVariant.copyWith(isDeleted: true),
        );
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка мягкого удаления: $e');
    }
  }

  Future<void> _deleteSoftProductVariantViaApi(int productVariantId) async {
    final response = await dio.delete(
      '$apiSiteUrl/product_variants/$productVariantId/soft',
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
  Future<void> postRestoreProductVariant(int productVariantId) async {
    try {
      await _restoreProductVariantViaApi(productVariantId);
      final productVariant = productVariantBox.get(productVariantId);
      if (productVariant != null) {
        await productVariantBox.put(
          productVariantId,
          productVariant.copyWith(isDeleted: false),
        );
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка восстановления варианта продукта: $e');
    }
  }

  Future<void> _restoreProductVariantViaApi(int productVariantId) async {
    final response = await dio.post(
      '$apiSiteUrl/product_variants/$productVariantId/restore',
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
