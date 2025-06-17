import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../modifier_group.dart';

class ModifierGroupRepository implements AbstractModifierGroupRepository {
  ModifierGroupRepository({
    required this.dio,
    required this.modifierGroupBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<ModifierGroup> modifierGroupBox;
  final String apiSiteUrl;
  static String? get token =>
      GetIt.I<AbstractJWTTokensRepository>().getAccessToken();

  @override
  Future<List<ModifierGroup>> getModifierGroupList() async {
    var modifierGroupList = <ModifierGroup>[];
    try {
      modifierGroupList = await _fetchModifierGroupListFromApi();
      final modifierGroupMap = {for (var e in modifierGroupList) e.id: e};
      await modifierGroupBox.putAll(modifierGroupMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      modifierGroupList = modifierGroupBox.values.toList();
    }
    return modifierGroupList;
  }

  Future<List<ModifierGroup>> _fetchModifierGroupListFromApi() async {
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
      final modifierGroupList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных группы модификаторов',
          );
        }
        try {
          final modifierGroup = ModifierGroup.fromJson(item);
          return modifierGroup;
        } catch (e) {
          rethrow;
        }
      }).toList();
      return List<ModifierGroup>.from(modifierGroupList);
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении списка групп модификаторов: $e');
    }
  }

  @override
  Future<ModifierGroup> getModifierGroup(int modifierGroupId) async {
    try {
      final modifierGroup = await _fetchModifierGroupFromApi(modifierGroupId);
      await modifierGroupBox.put(modifierGroup.id, modifierGroup);
      return modifierGroup;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      for (var key in modifierGroupBox.keys) {
        final modifierGroup = modifierGroupBox.get(key);
        if (modifierGroup != null && modifierGroup.id == modifierGroupId) {
          return modifierGroup;
        }
      }
      throw Exception('Ошибка при получении группы модификаторов: $e');
    }
  }

  Future<ModifierGroup> _fetchModifierGroupFromApi(int modifierGroupId) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/modifier_groups/$modifierGroupId',
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
      final modifierGroupData = response.data;
      if (modifierGroupData is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'Неожиданный формат ответа для группы модификаторов $modifierGroupId',
        );
      }
      final modifierGroup = ModifierGroup.fromJson(modifierGroupData);
      return modifierGroup;
    } catch (e) {
      throw Exception('Ошибка при получении группы модификаторов: $e');
    }
  }

  @override
  Future<ModifierGroup> postCreateModifierGroup(
      ModifierGroupCreateDTO dto) async {
    try {
      final modifierGroup = await _fetchCreatedModifierGroupFromApi(dto);
      await modifierGroupBox.put(modifierGroup.id, modifierGroup);
      return modifierGroup;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при создании группы модификаторов: $e');
    }
  }

  Future<ModifierGroup> _fetchCreatedModifierGroupFromApi(
      ModifierGroupCreateDTO dto) async {
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

    return ModifierGroup.fromJson(response.data);
  }

  @override
  Future<ModifierGroup> patchModifierGroup(
      int modifierGroupId, ModifierGroupPatchDTO dto) async {
    try {
      final modifierGroup =
          await _fetchUpdatedModifierGroupFromApi(modifierGroupId, dto);
      await modifierGroupBox.put(modifierGroup.id, modifierGroup);
      return modifierGroup;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при обновлении группы модификаторов: $e');
    }
  }

  Future<ModifierGroup> _fetchUpdatedModifierGroupFromApi(
      int modifierGroupId, ModifierGroupPatchDTO dto) async {
    final response = await dio.patch(
      '$apiSiteUrl/modifier_groups/$modifierGroupId',
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

    return ModifierGroup.fromJson(response.data);
  }

  @override
  Future<void> deleteHardModifierGroup(int modifierGroupId) async {
    try {
      await _deleteHardModifierGroupViaApi(modifierGroupId);
      await modifierGroupBox.delete(modifierGroupId);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка жесткого удаления: $e');
    }
  }

  Future<void> _deleteHardModifierGroupViaApi(int modifierGroupId) async {
    final response = await dio.delete(
      '$apiSiteUrl/modifier_groups/$modifierGroupId/hard',
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
  Future<void> deleteSoftModifierGroup(int modifierGroupId) async {
    try {
      await _deleteSoftModifierGroupViaApi(modifierGroupId);
      final modifierGroup = modifierGroupBox.get(modifierGroupId);
      if (modifierGroup != null) {
        await modifierGroupBox.put(
          modifierGroupId,
          modifierGroup.copyWith(isDeleted: true),
        );
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка мягкого удаления: $e');
    }
  }

  Future<void> _deleteSoftModifierGroupViaApi(int modifierGroupId) async {
    final response = await dio.delete(
      '$apiSiteUrl/modifier_groups/$modifierGroupId/soft',
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
  Future<void> postRestoreModifierGroup(int modifierGroupId) async {
    try {
      await _restoreModifierGroupViaApi(modifierGroupId);
      final modifierGroup = modifierGroupBox.get(modifierGroupId);
      if (modifierGroup != null) {
        await modifierGroupBox.put(
          modifierGroupId,
          modifierGroup.copyWith(isDeleted: false),
        );
      }
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка восстановления группы модификаторов: $e');
    }
  }

  Future<void> _restoreModifierGroupViaApi(int modifierGroupId) async {
    final response = await dio.post(
      '$apiSiteUrl/modifier_groups/$modifierGroupId/restore',
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
