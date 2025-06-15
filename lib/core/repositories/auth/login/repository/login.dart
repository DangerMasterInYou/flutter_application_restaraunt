import 'package:dio/dio.dart';

import '../login.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:hive/hive.dart';
import '/core/hive/models/uid_manager/uid_manager.dart';

class AttemptsExceededException implements Exception {
  final String message;
  final int attemptsLeft;
  AttemptsExceededException(this.message, {this.attemptsLeft = 0});

  @override
  String toString() => message;
}

class LoginRepository implements AbstractLoginRepository {
  int _attempts = 0;
  DateTime? _blockUntil;

  static const int maxAttempts = 5;
  static const Duration blockDuration = Duration(minutes: 1);

  void resetAttempts() {
    _attempts = 0;
    _blockUntil = null;
  }

  void _decrementAttempts() {
    _attempts++;
    if (_attempts >= maxAttempts) {
      _blockUntil = DateTime.now().add(blockDuration);
      _attempts = 0;
    }
  }

  bool get isBlocked {
    if (_blockUntil == null) return false;
    if (DateTime.now().isAfter(_blockUntil!)) {
      resetAttempts();
      return false;
    }
    return true;
  }
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

  @override
  Future<bool> sendVerificationCode(String email) async {
    try {
      final sendCodeDTO = '{"email": "$email"}';
      final response = await dio.post('$apiSiteUrl/api/v1/send-code', data: sendCodeDTO);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['success'] == true;
      } else {
        throw Exception('Ошибка отправки кода: ${response.statusCode}, ${response.data}');
      }
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace, 'DioException on sendVerificationCode');
      throw Exception('Ошибка соединения: ${e.message}');
    } catch (e, st) {
      _decrementAttempts();
      GetIt.instance<Talker>().handle(e, st, 'Exception on sendVerificationCode');
      throw AttemptsExceededException('Осталось попыток: ${5 - _attempts}');
    }
  }

  @override
  Future<Token?> verifyCode(String email, String code) async {
    if (isBlocked) {
      throw AttemptsExceededException('Слишком много попыток. Пожалуйста, подождите.', attemptsLeft: 0);
    }
    try {
      final verifyCodeDTO = '{"email": "$email", "code": "$code"}';
      final response = await dio.post('$apiSiteUrl/api/v1/verify-code', data: verifyCodeDTO);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['token'] != null && data['user'] != null) {
          final int tokenId = 1;

          final tokenData = {
            'id': tokenId,
            'access': data['token'],
            'refresh': data['refresh_token'] ?? ''
          };
          final token = Token.fromJson(tokenData);
          await tokenBox.put(1, token);
          resetAttempts();
          return token;
        } else {
          throw Exception('Ошибка верификации кода: неверный ответ сервера ${response.data}');
        }
      } 
      return null;
    } catch (e, st) {
      _decrementAttempts();
      GetIt.instance<Talker>().handle(e, st, 'Exception on verifyCode');
      if (_attempts > 0 && _attempts < maxAttempts) {
         throw AttemptsExceededException('Неверный код. Осталось попыток: ${maxAttempts - _attempts}', attemptsLeft: maxAttempts - _attempts);
      } else if (isBlocked) {
         throw AttemptsExceededException('Слишком много попыток. Пожалуйста, подождите.', attemptsLeft: 0);
      }
      throw Exception('Неизвестная ошибка: $e');
    }
  }
}
