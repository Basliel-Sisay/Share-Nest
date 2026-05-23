import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<({UserModel user, String token})> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _client.post('/api/auth/signup', {
      'name': name,
      'email': email,
      'password': password,
    });
    return (
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      token: data['token'] as String,
    );
  }

  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    final data = await _client.post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    return (
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      token: data['token'] as String,
    );
  }

  Future<UserModel> fetchMe(String token) async {
    final client = _clientWithToken(token);
    final data = await client.getOne('/api/auth/me');
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  ApiClient _clientWithToken(String token) {
    return _client.withAuthToken(token);
  }
}
