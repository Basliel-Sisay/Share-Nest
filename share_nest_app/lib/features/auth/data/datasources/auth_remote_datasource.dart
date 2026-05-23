import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
class AuthRemoteDataSource{
  AuthRemoteDataSource({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<({UserModel user, String token})> signup({required String name, required String email, required String password}) async{
    final data = await _client.post('/api/auth/signup', {
      'name': name,
      'email': email,
      'password': password,
    });
    return _parseAuthResponse(data);
  }

  Future<({UserModel user, String token})> login({required String email,required String password}) async{
    final data = await _client.post('/api/auth/login', {
      'email': email,
      'password': password,
    });
    return _parseAuthResponse(data);
  }

  Future<UserModel> fetchMe(String token) async{
    final client = _client.withAuthToken(token);
    final data = await client.getOne('/api/auth/me');
    final userJson = data['user'];
    if (userJson is! Map<String, dynamic>) {
      throw ApiException('Invalid profile response from server');
    }
    return UserModel.fromJson(userJson);
  }

  Future<void> deleteAccount(String token) async{
    final client = _client.withAuthToken(token);
    await client.delete('/api/auth/account');
  }

  ({UserModel user, String token}) _parseAuthResponse(
    Map<String, dynamic> data,
  ) {
    final userJson = data['user'];
    final token = data['token'];
    if (userJson is! Map<String, dynamic>) {
      throw ApiException(
        'Server returned an invalid signup/login response '
        'Is the ShareNest backend running on ${ApiConfig.baseUrl}?',
      );
    }
    if (token is! String || token.isEmpty){
      throw ApiException('Server did not return an auth token');
    }
    return (user: UserModel.fromJson(userJson), token: token);
  }
}
