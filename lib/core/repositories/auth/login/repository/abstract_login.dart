import '../login.dart';

abstract class AbstractLoginRepository {
  Future<Token?> postLogin(String email, String password);
  Future<bool> sendVerificationCode(String email);
  Future<Token?> verifyCode(String email, String code);
  void resetAttempts();
}
