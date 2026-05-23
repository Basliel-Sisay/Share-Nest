import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_state.dart';
import '../../data/datasource/auth_local_datasource.dart';
import '../../data/datasource/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/providers/core_providers.dart';

bool _isAuthenticatedGlobal = false;

bool get isAuthenticated => _isAuthenticatedGlobal;

final _authChanges = ValueNotifier<int>(0);

ValueNotifier<int> get authChanges => _authChanges;

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = AuthRemoteDataSource(ref.watch(dioProvider));
  final local = AuthLocalDataSource(
    ref.watch(appDatabaseProvider),
    ref.watch(secureStorageProvider),
  );
  return AuthRepositoryImpl(remote, local);
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _restoreSession();
    return const AuthState.unknown();
  }

  void _setState(AuthState newState) {
    state = newState;
    _isAuthenticatedGlobal = newState.status == AuthStatus.authenticated;
    _authChanges.value++;
  }

  Future<void> _restoreSession() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final loggedIn = await repo.isLoggedIn();
      if (loggedIn) {
        final user = await repo.restoreSession();
        _setState(AuthState.authenticated(user));
      } else {
        _setState(const AuthState.unauthenticated());
      }
    } catch (_) {
      _setState(const AuthState.unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    _setState(const AuthState.loading());
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(email, password);
      _setState(AuthState.authenticated(user));
    } catch (e) {
      _setState(AuthState.error(e.toString()));
    }
  }

  Future<void> signup(String name, String email, String password) async {
    _setState(const AuthState.loading());
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signup(name, email, password);
      _setState(AuthState.authenticated(user));
    } catch (e) {
      _setState(AuthState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();
    } catch (_) {}
    _setState(const AuthState.unauthenticated());
  }

  Future<void> deleteAccount() async {
    _setState(const AuthState.loading());
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.deleteAccount();
      _setState(const AuthState.unauthenticated());
    } catch (e) {
      _setState(AuthState.error(e.toString()));
    }
  }

  void clearError() {
    _setState(state.copyWith(error: null));
  }
}
