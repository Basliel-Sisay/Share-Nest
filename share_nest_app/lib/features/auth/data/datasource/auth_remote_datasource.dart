import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.signup(
      name: name,
      email: email,
      password: password,
    );
    if (!response.success || response.data == null) {
      throw Exception(response.error ?? 'Signup failed');
    }
    return AuthResponseModel.fromJson(response.data!);
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.login(
      email: email,
      password: password,
    );
    if (!response.success || response.data == null) {
      throw Exception(response.error ?? 'Login failed');
    }
    return AuthResponseModel.fromJson(response.data!);
  }

  Future<void> logout(String token) async {
    final response = await _apiClient.logout(token);
    if (!response.success) {
      throw Exception(response.error ?? 'Logout failed');
    }
  }

  Future<void> deleteAccount(String token) async {
    final response = await _apiClient.deleteAccount(token);
    if (!response.success) {
      throw Exception(response.error ?? 'Delete account failed');
    }
  }

  Future<UserModel?> validateToken(String token) async {
    final response = await _apiClient.validateToken(token);
    if (!response.success || response.data == null) return null;
    return UserModel.fromJson(response.data!['user'] as Map<String, dynamic>);
  }
}
