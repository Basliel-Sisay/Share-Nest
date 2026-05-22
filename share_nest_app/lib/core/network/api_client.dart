import 'dart:math';

class ApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? error;

  ApiResponse({required this.success, this.data, this.error});
}

class ApiClient {
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  final Map<String, Map<String, dynamic>> _users = {};
  final Map<String, String> _tokens = {};

  Future<ApiResponse> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_users.values.any((u) => u['email'] == email)) {
      return ApiResponse(success: false, error: 'Email already registered');
    }

    final id = Random().nextInt(99999).toString();
    final token = 'token_${id}_${DateTime.now().millisecondsSinceEpoch}';

    final user = <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': 'regular_user',
      'createdAt': DateTime.now().toIso8601String(),
    };

    _users[id] = user;
    _tokens[token] = id;

    return ApiResponse(success: true, data: {
      'user': {...user}..remove('password'),
      'token': token,
      'refreshToken': 'refresh_$token',
    });
  }

  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final user = _users.values.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );
      final id = user['id'] as String;
      final token = 'token_${id}_${DateTime.now().millisecondsSinceEpoch}';
      _tokens[token] = id;

      return ApiResponse(success: true, data: {
        'user': {...user}..remove('password'),
        'token': token,
        'refreshToken': 'refresh_$token',
      });
    } catch (_) {
      return ApiResponse(success: false, error: 'Invalid email or password');
    }
  }

  Future<ApiResponse> logout(String token) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tokens.remove(token);
    return ApiResponse(success: true);
  }

  Future<ApiResponse> deleteAccount(String token) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final userId = _tokens.remove(token);
    if (userId != null) {
      _users.remove(userId);
    }
    return ApiResponse(success: true);
  }

  Future<ApiResponse> validateToken(String token) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final userId = _tokens[token];
    if (userId == null) {
      return ApiResponse(success: false, error: 'Invalid token');
    }
    final user = _users[userId];
    if (user == null) {
      return ApiResponse(success: false, error: 'User not found');
    }
    return ApiResponse(success: true, data: {
      'user': {...user}..remove('password'),
    });
  }
}
