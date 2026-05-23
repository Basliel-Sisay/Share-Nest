import 'dart:math';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<User> signup(String name, String email, String password) async {
    final localExists = await _localDataSource.emailExists(email);
    if (localExists) {
      throw Exception('Email already registered');
    }

    UserModel userModel;
    String token;
    String refreshToken;

    try {
      final response = await _remoteDataSource.signup(
        name: name,
        email: email,
        password: password,
      );
      userModel = response.user.copyWith(password: password);
      token = response.token;
      refreshToken = response.refreshToken;
    } catch (_) {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      userModel = UserModel(
        id: id,
        name: name,
        email: email,
        password: password,
        role: 'regular_user',
        createdAt: DateTime.now().toIso8601String(),
      );
      token = 'offline_token_$id';
      refreshToken = 'offline_refresh_$id';
    }

    await _localDataSource.cacheUser(userModel);
    await _localDataSource.cacheSession(
      userId: userModel.id,
      token: token,
      refreshToken: refreshToken,
    );
    return userModel.toEntity();
  }

  @override
  Future<User> login(String email, String password) async {
    final cached = await _localDataSource.getUserByEmailAndPassword(
      email,
      password,
    );
    if (cached != null) {
      final token = 'offline_token_${cached.id}_${Random().nextInt(99999)}';
      await _localDataSource.cacheSession(
        userId: cached.id,
        token: token,
        refreshToken: 'offline_refresh_${cached.id}',
      );
      return cached.toEntity();
    }

    final response = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    final userModel = response.user.copyWith(password: password);
    await _localDataSource.cacheUser(userModel);
    await _localDataSource.cacheSession(
      userId: response.user.id,
      token: response.token,
      refreshToken: response.refreshToken,
    );
    return response.user.toEntity();
  }

  @override
  Future<void> logout() async {
    final token = await _localDataSource.getStoredToken();
    if (token != null) {
      try {
        await _remoteDataSource.logout(token);
      } catch (_) {}
    }
    await _localDataSource.clearAll();
  }

  @override
  Future<void> deleteAccount() async {
    final token = await _localDataSource.getStoredToken();
    if (token != null) {
      try {
        await _remoteDataSource.deleteAccount(token);
      } catch (_) {}
    }
    await _localDataSource.clearAll();
  }

  @override
  Future<User?> getCurrentUser() async {
    final cached = await _localDataSource.getCachedUser();
    return cached?.toEntity();
  }

  @override
  Future<String?> getToken() async {
    return _localDataSource.getStoredToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _localDataSource.getStoredToken();
    return token != null;
  }

  @override
  Future<User> restoreSession() async {
    final cachedUser = await _localDataSource.getCachedUser();
    if (cachedUser != null) {
      return cachedUser.toEntity();
    }
    throw Exception('No cached session found');
  }
}
