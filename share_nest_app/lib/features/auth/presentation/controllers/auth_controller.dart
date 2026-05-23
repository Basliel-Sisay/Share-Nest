import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  final UserModel? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _tryAutoLogin();
    return const AuthState();
  }

  Future<void> _tryAutoLogin() async {
    final repo = ref.read(authRepositoryProvider);
    final user = await repo.tryAutoLogin();
    if (user != null) {
      state = AuthState(user: user);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(email: email, password: password);
      state = AuthState(user: user);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _formatError(e),
      );
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signup(
        name: name,
        email: email,
        password: password,
      );
      state = AuthState(user: user);
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _formatError(e),
      );
    }
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AuthState();
  }

  String _formatError(Exception e) {
    if (e is ApiException) return e.message;
    final msg = e.toString();
    return msg.replaceFirst(RegExp(r'^\w+Exception:\s*'), '');
  }
}

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(DatabaseHelper.instance);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    local: ref.watch(authLocalDataSourceProvider),
    remote: ref.watch(authRemoteDataSourceProvider),
  );
});

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
