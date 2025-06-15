import '../profile.dart';
abstract class AbstractProfilesRepository {
  Future<Profile> getProfile();
  Future<void> postResetPassword(Profile cart);
}
