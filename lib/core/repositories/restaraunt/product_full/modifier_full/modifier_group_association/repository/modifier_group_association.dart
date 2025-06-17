import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../modifier_group_association.dart';

class ModifierGroupAssociationRepository
    implements AbstractModifierGroupAssociationRepository {
  ModifierGroupAssociationRepository({
    required this.dio,
    required this.modifierGroupAssociationBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<ModifierGroupAssociation> modifierGroupAssociationBox;
  final String apiSiteUrl;
  static String? get token =>
      GetIt.I<AbstractJWTTokensRepository>().getAccessToken();

  @override
  Future<List<ModifierGroupAssociation>>
      getModifierGroupAssociationList() async {
    var modifierGroupAssociationList = <ModifierGroupAssociation>[];
    try {
      modifierGroupAssociationList =
          await _fetchModifierGroupAssociationListFromApi();
      final modifierGroupAssociationMap = {
        for (var e in modifierGroupAssociationList) e.id: e
      };
      await modifierGroupAssociationBox.putAll(modifierGroupAssociationMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      modifierGroupAssociationList =
          modifierGroupAssociationBox.values.toList();
    }
    return modifierGroupAssociationList;
  }

  Future<List<ModifierGroupAssociation>>
      _fetchModifierGroupAssociationListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/modifier_groups',
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
      final modifierGroupAssociationList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных группы ассоциации модификаторов',
          );
        }
        try {
          final modifierGroupAssociation =
              ModifierGroupAssociation.fromJson(item);
          return modifierGroupAssociation;
        } catch (e) {
          rethrow;
        }
      }).toList();
      return List<ModifierGroupAssociation>.from(modifierGroupAssociationList);
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception(
          'Ошибка при получении списка групп ассоциаций модификаторов: $e');
    }
  }

  @override
  Future<ModifierGroupAssociation> getModifierGroupAssociation(
      int modifierGroupAssociationId) async {
    try {
      final modifierGroupAssociation =
          await _fetchModifierGroupAssociationFromApi(
              modifierGroupAssociationId);
      await modifierGroupAssociationBox.put(
          modifierGroupAssociation.id, modifierGroupAssociation);
      return modifierGroupAssociation;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      for (var key in modifierGroupAssociationBox.keys) {
        final modifierGroupAssociation = modifierGroupAssociationBox.get(key);
        if (modifierGroupAssociation != null &&
            modifierGroupAssociation.id == modifierGroupAssociationId) {
          return modifierGroupAssociation;
        }
      }
      throw Exception(
          'Ошибка при получении группы ассоциаций модификаторов: $e');
    }
  }

  Future<ModifierGroupAssociation> _fetchModifierGroupAssociationFromApi(
      int modifierGroupAssociationId) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/modifier_groups/$modifierGroupAssociationId',
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
      final modifierGroupAssociationData = response.data;
      if (modifierGroupAssociationData is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'Неожиданный формат ответа для группы ассоциаций модификаторов $modifierGroupAssociationId',
        );
      }
      final modifierGroupAssociation =
          ModifierGroupAssociation.fromJson(modifierGroupAssociationData);
      return modifierGroupAssociation;
    } catch (e) {
      throw Exception(
          'Ошибка при получении группы ассоциаций модификаторов: $e');
    }
  }

  @override
  Future<ModifierGroupAssociation> postCreateModifierGroupAssociation(
      ModifierGroupAssociationCreateDTO dto) async {
    try {
      final modifierGroupAssociation =
          await _fetchCreatedModifierGroupAssociationFromApi(dto);
      await modifierGroupAssociationBox.put(
          modifierGroupAssociation.id, modifierGroupAssociation);
      return modifierGroupAssociation;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception(
          'Ошибка при создании группы ассоциаций модификаторов: $e');
    }
  }

  Future<ModifierGroupAssociation> _fetchCreatedModifierGroupAssociationFromApi(
      ModifierGroupAssociationCreateDTO dto) async {
    final response = await dio.post(
      '$apiSiteUrl/modifier_groups',
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

    return ModifierGroupAssociation.fromJson(response.data);
  }

  @override
  Future<ModifierGroupAssociation> patchModifierGroupAssociation(
      int modifierGroupAssociationId,
      ModifierGroupAssociationPatchDTO dto) async {
    try {
      final modifierGroupAssociation =
          await _fetchUpdatedModifierGroupAssociationFromApi(
              modifierGroupAssociationId, dto);
      await modifierGroupAssociationBox.put(
          modifierGroupAssociation.id, modifierGroupAssociation);
      return modifierGroupAssociation;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception(
          'Ошибка при обновлении группы ассоциаций модификаторов: $e');
    }
  }

  Future<ModifierGroupAssociation> _fetchUpdatedModifierGroupAssociationFromApi(
      int modifierGroupAssociationId,
      ModifierGroupAssociationPatchDTO dto) async {
    final response = await dio.patch(
      '$apiSiteUrl/modifier_groups/$modifierGroupAssociationId',
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

    return ModifierGroupAssociation.fromJson(response.data);
  }

  @override
  Future<void> deleteHardModifierGroupAssociation(
      int modifierGroupAssociationId) async {
    try {
      await _deleteHardModifierGroupAssociationViaApi(
          modifierGroupAssociationId);
      await modifierGroupAssociationBox.delete(modifierGroupAssociationId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка жесткого удаления: $e');
    }
  }

  Future<void> _deleteHardModifierGroupAssociationViaApi(
      int modifierGroupAssociationId) async {
    final response = await dio.delete(
      '$apiSiteUrl/modifier_groups/$modifierGroupAssociationId/hard',
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
  Future<void> deleteSoftModifierGroupAssociation(
      int modifierGroupAssociationId) async {
    try {
      await _deleteSoftModifierGroupAssociationViaApi(
          modifierGroupAssociationId);
      final modifierGroupAssociation =
          modifierGroupAssociationBox.get(modifierGroupAssociationId);
      if (modifierGroupAssociation != null) {
        await modifierGroupAssociationBox.put(
          modifierGroupAssociationId,
          modifierGroupAssociation.copyWith(isDeleted: true),
        );
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка мягкого удаления: $e');
    }
  }

  Future<void> _deleteSoftModifierGroupAssociationViaApi(
      int modifierGroupAssociationId) async {
    final response = await dio.delete(
      '$apiSiteUrl/modifier_groups/$modifierGroupAssociationId/soft',
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
  Future<void> postRestoreModifierGroupAssociation(
      int modifierGroupAssociationId) async {
    try {
      await _restoreModifierGroupAssociationViaApi(modifierGroupAssociationId);
      final modifierGroupAssociation =
          modifierGroupAssociationBox.get(modifierGroupAssociationId);
      if (modifierGroupAssociation != null) {
        await modifierGroupAssociationBox.put(
          modifierGroupAssociationId,
          modifierGroupAssociation.copyWith(isDeleted: false),
        );
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception(
          'Ошибка восстановления группы ассоциаций модификаторов: $e');
    }
  }

  Future<void> _restoreModifierGroupAssociationViaApi(
      int modifierGroupAssociationId) async {
    final response = await dio.post(
      '$apiSiteUrl/modifier_groups/$modifierGroupAssociationId/restore',
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
