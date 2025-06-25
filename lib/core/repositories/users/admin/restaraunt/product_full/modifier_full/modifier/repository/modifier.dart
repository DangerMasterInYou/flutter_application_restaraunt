import 'package:dio/dio.dart';
import '../modifier.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ModifierRepository implements AbstractModifierRepository {
  ModifierRepository({
    required this.dio,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final String apiSiteUrl;
  static String? get token =>
      GetIt.I<AbstractJWTTokensRepository>().getAccessToken();

  @override
  Future<List<Modifier>> getModifierList() async {
    try {
      final modifierList = await _fetchModifierListFromApi();
      return modifierList;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка загрузки списка модификаторов: $e');
    }
  }

  Future<List<Modifier>> _fetchModifierListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/admin/modifiers',
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
      final modifierList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных модификатора',
          );
        }
        try {
          final modifier = Modifier.fromJson(item);
          return modifier;
        } catch (e) {
          rethrow;
        }
      }).toList();
      return List<Modifier>.from(modifierList);
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении списка модификаторов: $e');
    }
  }

  @override
  Future<Modifier> getModifier(int modifierId) async {
    try {
      return await _fetchModifierFromApi(modifierId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении модификатора: $e');
    }
  }

  Future<Modifier> _fetchModifierFromApi(int modifierId) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/admin/modifiers/$modifierId',
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
      final modifierData = response.data;
      if (modifierData is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неожиданный формат ответа для модификатора $modifierId',
        );
      }
      final modifier = Modifier.fromJson(modifierData);
      return modifier;
    } catch (e) {
      throw Exception('Ошибка при получении модификатора: $e');
    }
  }

  @override
  Future<Modifier> postCreateModifier(int groupId, ModifierCreateDTO dto) async {
    try {
      final modifier = await _fetchCreatedModifierFromApi(groupId, dto);
      return modifier;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при создании модификатора: $e');
    }
  }

  Future<Modifier> _fetchCreatedModifierFromApi(
      int groupId, ModifierCreateDTO dto) async {
    final response = await dio.post(
      '$apiSiteUrl/admin/modifier-groups/$groupId/modifiers',
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

    return Modifier.fromJson(response.data);
  }

  @override
  Future<Modifier> patchModifier(int modifierId, ModifierPatchDTO dto) async {
    try {
      final modifier = await _fetchUpdatedModifierFromApi(modifierId, dto);
      return modifier;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при обновлении модификатора: $e');
    }
  }

  Future<Modifier> _fetchUpdatedModifierFromApi(
      int modifierId, ModifierPatchDTO dto) async {
    final response = await dio.patch(
      '$apiSiteUrl/admin/modifiers/$modifierId',
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

    return Modifier.fromJson(response.data);
  }

  @override
  Future<void> deleteHardModifier(int modifierId) async {
    try {
      await _deleteHardModifierViaApi(modifierId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка жесткого удаления: $e');
    }
  }

  Future<void> _deleteHardModifierViaApi(int modifierId) async {
    final response = await dio.delete(
      '$apiSiteUrl/admin/modifiers/$modifierId/hard',
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
  Future<void> deleteSoftModifier(int modifierId) async {
    try {
      await _deleteSoftModifierViaApi(modifierId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка мягкого удаления: $e');
    }
  }

  Future<void> _deleteSoftModifierViaApi(int modifierId) async {
    final response = await dio.delete(
      '$apiSiteUrl/admin/modifiers/$modifierId/soft',
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
  Future<void> postRestoreModifier(int modifierId) async {
    try {
      await _restoreModifierViaApi(modifierId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка восстановления модификатора: $e');
    }
  }

  Future<void> _restoreModifierViaApi(int modifierId) async {
    final response = await dio.post(
      '$apiSiteUrl/admin/modifiers/$modifierId/restore',
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
