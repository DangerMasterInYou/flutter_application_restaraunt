import '../login.dart';

abstract class AbstractLoginRepository {
  Future<Token?> postLogin(String email, String password);
}
