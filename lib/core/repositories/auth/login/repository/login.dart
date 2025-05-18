import 'package:dio/dio.dart';

import '../login.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';


class LoginRepository implements AbstractLoginRepository {
  LoginRepository({
    required this.dio,
    required this.tokenBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<Token> tokenBox;
  final String apiSiteUrl;

  final tokenkey = 1;

  @override
  Future<Token?> postLogin(String email, String password) async {
    try {
      final token = await _sendLoginRequest(email, password);
      return token;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      return null;
    }
  }

  Future<Token> _sendLoginRequest(String email, String password) async {
    try {
      final loginDTO = LoginDTO(
        email: email,
        password: password
      ).toJson();

      final response = await dio.post('$apiSiteUrl/login',
        data: loginDTO);

      if (response.statusCode != 200) {
        throw Exception('Ошибка при загрузке данных: ${response.statusCode}');
      }
      
      if (response.data is Map<String, dynamic> && 
          response.data['access'] != null && 
          response.data['refresh'] != null) {
        
        final token = Token.fromJson(response.data);
        
        await tokenBox.put(tokenkey, token);
        return token;
      } else {
        throw Exception('Ответ сервера не содержит необходимые токены: ${response.data}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception('Неверный формат данных: ${e.response?.data}');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Неверный логин или пароль');
      } else {
        throw Exception('Ошибка соединения с сервером: ${e.message}');
      }
    }
    catch (e) {
      throw Exception('Ошибка при загрузке данных: $e');
    }
  }
}
