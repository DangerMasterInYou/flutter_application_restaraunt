import 'package:dio/dio.dart';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../profile.dart';

class ProfilesRepository implements AbstractProfilesRepository {
  ProfilesRepository({
    required this.dio,
    required this.profilesBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<Profile> profilesBox;
  final String apiSiteUrl;

  @override
  Future<Profile> getProfilesList() async {
    Profile profile;
    try {
      // profile = await _fetchProfilesListFromApi();
      
      profile = Profile(
        id: 1,
        email: "1@gmail.com",
        birthday: DateTime(2000, 1, 1),
        username: "Тестовый пользователь",
        familyName: "Тестов",
        phone: "+7 (999) 123-45-67",
        isActive: true,
        createdAt: DateTime.now(),
      );
      
      await profilesBox.put(profile.id, profile);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      if (profilesBox.isNotEmpty) {
        profile = profilesBox.values.first;
      } else {
        throw Exception('Профиль не найден в локальном хранилище');
      }
    }

    return profile;
  }

  Future<Profile> _fetchProfilesListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/profile',
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
      if (data is! List || data.isEmpty) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неожиданный формат ответа или пустой список',
        );
      }

      final item = data.first;
      if (item is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неверный формат данных профиля',
        );
      }
      
      return Profile.fromJson(item);
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении данных профиля: $e');
    }
  }

  @override
  Future<void> postResetPassword(Profile profile) async {
    throw UnimplementedError('Метод postResetPassword пока не реализован');
  }
}
