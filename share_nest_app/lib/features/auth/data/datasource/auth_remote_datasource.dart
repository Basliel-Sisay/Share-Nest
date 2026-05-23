import 'package:dio/dio.dart';

import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/signup',
      data: {'name': name, 'email': email, 'password': password},
    );
    return _parseAuthResponse(response);
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return _parseAuthResponse(response);
  }

  Future<void> logout(String token) async {
    final response = await _dio.post<Map<String, dynamic>>('/auth/logout');
    _ensureSuccess(response);
  }

  Future<void> deleteAccount(String token) async {
    final response = await _dio.delete<Map<String, dynamic>>('/auth/account');
    _ensureSuccess(response);
  }

  Future<UserModel?> validateToken(String token) async {
    final response = await _dio.get<Map<String, dynamic>>('/auth/validate');
    final data = response.data;
    if (data == null || data['error'] != null) return null;
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  AuthResponseModel _parseAuthResponse(Response<Map<String, dynamic>> response) {
    final data = response.data;
    if (data == null) {
      throw Exception('Empty response');
    }
    final error = data['error'] as String?;
    if (error != null) {
      throw Exception(error);
    }
    return AuthResponseModel.fromJson(data);
  }

  void _ensureSuccess(Response<Map<String, dynamic>> response) {
    final data = response.data;
    final error = data?['error'] as String?;
    if (error != null) {
      throw Exception(error);
    }
  }
}
