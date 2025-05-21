import '../profile.dart';
abstract class AbstractProfilesRepository {
  Future<Profile> getProfilesList();
  Future<void> postResetPassword(Profile cart);
}
