import 'package:dio/dio.dart';

import '../combo_bundle.dart';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ComboBundleRepository implements AbstractComboBundleRepository {
  ComboBundleRepository({
    required this.dio,
    required this.comboBundleBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<ComboBundle> comboBundleBox;
  final String apiSiteUrl;
  static String? get token =>
      GetIt.I<AbstractJWTTokensRepository>().getAccessToken();

  @override
  Future<List<ComboBundle>> getComboBundleList() async {
    var comboBundleList = <ComboBundle>[];
    try {
      comboBundleList = await _fetchComboBundleListFromApi();
      final comboBundleMap = {for (var e in comboBundleList) e.id: e};
      await comboBundleBox.putAll(comboBundleMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      comboBundleList = comboBundleBox.values.toList();
    }
    return comboBundleList;
  }

  Future<List<ComboBundle>> _fetchComboBundleListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/comboBundle',
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
      final comboBundleList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных продукта',
          );
        }
        try {
          final comboBundle = ComboBundle.fromJson(item);
          return comboBundle;
        } catch (e) {
          rethrow;
        }
      }).toList();
      return List<ComboBundle>.from(comboBundleList);
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении списка продукт: $e');
    }
  }

  @override
  Future<ComboBundle> getComboBundle(int comboBundleId) async {
    try {
      final comboBundle = await _fetchComboBundleFromApi(comboBundleId);
      await comboBundleBox.put(comboBundle.id, comboBundle);
      return comboBundle;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      for (var key in comboBundleBox.keys) {
        final comboBundle = comboBundleBox.get(key);
        if (comboBundle != null &&
            comboBundle.comboVariantId == comboBundleId) {
          return comboBundle;
        }
      }
      throw Exception('Ошибка при получении продукта: $e');
    }
  }

  Future<ComboBundle> _fetchComboBundleFromApi(int comboBundleId) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/api/v1/menu/comboBundle/$comboBundleId',
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
      final comboBundleData = response.data;
      if (comboBundleData is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неожиданный формат ответа для продукта $comboBundleId',
        );
      }
      final comboBundle = ComboBundle.fromJson(comboBundleData);
      return comboBundle;
    } catch (e) {
      throw Exception('Ошибка при получении продукта: $e');
    }
  }

  @override
  Future<ComboBundle> postCreateComboBundle(ComboBundleCreateDTO dto) async {
    try {
      final comboBundle = await _fetchCreatedComboBundleFromApi(dto);
      await comboBundleBox.put(comboBundle.id, comboBundle);
      return comboBundle;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при создании Combo Bundle: $e');
    }
  }

  Future<ComboBundle> _fetchCreatedComboBundleFromApi(
      ComboBundleCreateDTO dto) async {
    final response = await dio.post(
      '$apiSiteUrl/comboBundle',
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

    return ComboBundle.fromJson(response.data);
  }

  // 2. Обновление Combo Bundle
  @override
  Future<ComboBundle> patchComboBundle(
      int comboBundleId, ComboBundlePatchDTO dto) async {
    try {
      final comboBundle =
          await _fetchUpdatedComboBundleFromApi(comboBundleId, dto);
      await comboBundleBox.put(comboBundle.id, comboBundle);
      return comboBundle;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при обновлении Combo Bundle: $e');
    }
  }

  Future<ComboBundle> _fetchUpdatedComboBundleFromApi(
      int comboBundleId, ComboBundlePatchDTO dto) async {
    final response = await dio.patch(
      '$apiSiteUrl/comboBundle/$comboBundleId',
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

    return ComboBundle.fromJson(response.data);
  }

  // 3. Жесткое удаление
  @override
  Future<void> deleteHardComboBundle(int comboBundleId) async {
    try {
      await _deleteHardComboBundleViaApi(comboBundleId);
      await comboBundleBox.delete(comboBundleId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка жесткого удаления: $e');
    }
  }

  Future<void> _deleteHardComboBundleViaApi(int comboBundleId) async {
    final response = await dio.delete(
      '$apiSiteUrl/comboBundle/$comboBundleId/hard',
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

  // 4. Мягкое удаление
  @override
  Future<void> deleteSoftComboBundle(int comboBundleId) async {
    try {
      await _deleteSoftComboBundleViaApi(comboBundleId);
      final comboBundle = comboBundleBox.get(comboBundleId);
      if (comboBundle != null) {
        await comboBundleBox.put(
          comboBundleId,
          comboBundle.copyWith(isDeleted: true), // 1 = true для int-флага
        );
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка мягкого удаления: $e');
    }
  }

  Future<void> _deleteSoftComboBundleViaApi(int comboBundleId) async {
    final response = await dio.delete(
      '$apiSiteUrl/comboBundle/$comboBundleId/soft',
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

  // 5. Восстановление
  @override
  Future<void> postRestoreComboBundle(int comboBundleId) async {
    try {
      await _restoreComboBundleViaApi(comboBundleId);
      final comboBundle = comboBundleBox.get(comboBundleId);
      if (comboBundle != null) {
        await comboBundleBox.put(
          comboBundleId,
          comboBundle.copyWith(isDeleted: false), // 0 = false для int-флага
        );
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка восстановления: $e');
    }
  }

  Future<void> _restoreComboBundleViaApi(int comboBundleId) async {
    final response = await dio.post(
      '$apiSiteUrl/comboBundle/$comboBundleId/restore',
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
