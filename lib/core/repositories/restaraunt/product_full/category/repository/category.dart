import 'package:dio/dio.dart';

import '../category.dart';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CategoriesRepository implements AbstractCategoriesRepository {
  CategoriesRepository({
    required this.dio,
    required this.categoriesBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<Category> categoriesBox;
  final String apiSiteUrl;
  static String? get token =>
      GetIt.I<AbstractJWTTokensRepository>().getAccessToken();

  @override
  Future<List<Category>> getCategoriesList() async {
    var categoriesList = <Category>[];
    try {
      categoriesList = await _fetchCategoriesListFromApi();
      final categoriesMap = {for (var e in categoriesList) e.id: e};
      await categoriesBox.putAll(categoriesMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      categoriesList = categoriesBox.values.toList();
    }
    return categoriesList;
  }

  Future<List<Category>> _fetchCategoriesListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/categories',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
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
      final categoriesList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных категории',
          );
        }
        try {
          final category = Category.fromJson(item);
          return category;
        } catch (e) {
          rethrow;
        }
      }).toList();
      return List<Category>.from(categoriesList);
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении списка категорий: $e');
    }
  }

  @override
  Future<Category> getCategory(int categoryId) async {
    try {
      final category = await _fetchCategoryFromApi(categoryId);
      await categoriesBox.put(category.id, category);
      return category;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      for (var key in categoriesBox.keys) {
        final category = categoriesBox.get(key);
        if (category != null && category.name == categoryId) {
          return category;
        }
      }
      throw Exception('Ошибка при получении категории: $e');
    }
  }

  Future<Category> _fetchCategoryFromApi(int categoryId) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/categories/$categoryId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
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
      final categoryData = response.data;
      if (categoryData is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неожиданный формат ответа для категории $categoryId',
        );
      }
      final category = Category.fromJson(categoryData);
      return category;
    } catch (e) {
      throw Exception('Ошибка при получении категории: $e');
    }
  }

  @override
  Future<Category> postCreateCategory(CategoryCreateDTO dto) async {
    try {
      final category = await _fetchCreatedCategoryFromApi(dto);
      await categoriesBox.put(category.id, category);
      return category;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при создании категории: $e');
    }
  }

  Future<Category> _fetchCreatedCategoryFromApi(CategoryCreateDTO dto) async {
    final response = await dio.post(
      '$apiSiteUrl/categories',
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

    return Category.fromJson(response.data);
  }

  @override
  Future<Category> patchCategory(int categoryId, CategoryPatchDTO dto) async {
    try {
      final category = await _fetchUpdatedCategoryFromApi(categoryId, dto);
      await categoriesBox.put(category.id, category);
      return category;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при обновлении категории: $e');
    }
  }

  Future<Category> _fetchUpdatedCategoryFromApi(
      int categoryId, CategoryPatchDTO dto) async {
    final response = await dio.patch(
      '$apiSiteUrl/categories/$categoryId',
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

    return Category.fromJson(response.data);
  }

  @override
  Future<void> deleteHardCategory(int categoryId) async {
    try {
      await _deleteHardCategoryViaApi(categoryId);
      await categoriesBox.delete(categoryId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка жесткого удаления: $e');
    }
  }

  Future<void> _deleteHardCategoryViaApi(int categoryId) async {
    final response = await dio.delete(
      '$apiSiteUrl/categories/$categoryId/hard',
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
  Future<void> deleteSoftCategory(int categoryId) async {
    try {
      await _deleteSoftCategoryViaApi(categoryId);
      final category = categoriesBox.get(categoryId);
      if (category != null) {
        await categoriesBox.put(categoryId, category.copyWith(isDeleted: true));
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка мягкого удаления: $e');
    }
  }

  Future<void> _deleteSoftCategoryViaApi(int categoryId) async {
    final response = await dio.delete(
      '$apiSiteUrl/categories/$categoryId/soft',
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
  Future<void> postRestoreCategory(int categoryId) async {
    try {
      await _restoreCategoryViaApi(categoryId);
      final category = categoriesBox.get(categoryId);
      if (category != null) {
        await categoriesBox.put(
            categoryId, category.copyWith(isDeleted: false));
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка восстановления категории: $e');
    }
  }

  Future<void> _restoreCategoryViaApi(int categoryId) async {
    final response = await dio.post(
      '$apiSiteUrl/categories/$categoryId/restore',
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
