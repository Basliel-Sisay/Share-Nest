import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signup(String name, String email, String password);
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<void> deleteAccount();
  Future<User?> getCurrentUser();
  Future<String?> getToken();
  Future<bool> isLoggedIn();
  Future<User> restoreSession();
}
