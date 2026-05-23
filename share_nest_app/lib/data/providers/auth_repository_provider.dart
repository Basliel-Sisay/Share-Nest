import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class AuthResult {
  const AuthResult({required this.user, required this.accessToken});
  final UserModel user;
  final String accessToken;
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}

abstract class AuthRepository {
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  Future<AuthResult> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> deleteAccount();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError(
    'authRepositoryProvider must be overridden by Person 3.',
  );
});