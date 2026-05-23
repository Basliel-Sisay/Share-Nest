import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';

class _Keys {
  static const accessToken = 'sharenest_access_token';
  static const refreshToken = 'sharenest_refresh_token';
  static const cachedUser = 'sharenest_cached_user';
}

class SecureStorageService {
  const SecureStorageService(this._storage);
  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _Keys.accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: _Keys.accessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _Keys.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: _Keys.refreshToken);
  }

  Future<void> saveUser(UserModel user) async {
    final json = jsonEncode(user.toJson());
    await _storage.write(key: _Keys.cachedUser, value: json);
  }

  Future<UserModel?> getUser() async {
    try {
      final raw = await _storage.read(key: _Keys.cachedUser);
      if (raw == null) return null;
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await clearAll();
      return null;
    }
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  return SecureStorageService(storage);
});