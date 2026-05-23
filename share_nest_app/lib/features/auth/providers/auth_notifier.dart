import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/models/user_model.dart';
import '../../../core/utils/secure_storage_service.dart';
import '../../../data/providers/auth_repository_provider.dart';
import 'auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _checkExistingSession();
    return const AuthState.initial();
  }

  SecureStorageService get _storage => ref.read(secureStorageServiceProvider);

  Future<void> _checkExistingSession() async {
    final token = await _storage.getAccessToken();
    if (token == null) {
      state = const AuthState.unauthenticated();
      return;
    }
    final cachedUser = await _storage.getUser();
    if (cachedUser != null) {
      state = AuthState.authenticated(cachedUser.copyWith(accessToken: token));
    } else {
      await _storage.clearAll();
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.login(email: email, password: password);
      await _storage.saveAccessToken(result.accessToken);
      await _storage.saveUser(result.user);
      state = AuthState.authenticated(
        result.user.copyWith(accessToken: result.accessToken),
      );
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (_) {
      state = const AuthState.error('Something went wrong. Please try again.');
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.signup(
        name: name,
        email: email,
        password: password,
      );
      await _storage.saveAccessToken(result.accessToken);
      await _storage.saveUser(result.user);
      state = AuthState.authenticated(
        result.user.copyWith(accessToken: result.accessToken),
      );
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (_) {
      state = const AuthState.error('Registration failed. Please try again.');
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();
    } catch (_) {
      // Still log out locally even if network fails
    } finally {
      await _storage.clearAll();
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> deleteAccount() async {
    state = const AuthState.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.deleteAccount();
      await _storage.clearAll();
      state = const AuthState.unauthenticated();
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (_) {
      state = const AuthState.error('Could not delete account. Try again later.');
    }
  }

  void clearError() {
    if (state is AuthStateError) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> updateUser(UserModel updated) async {
    await _storage.saveUser(updated);
    state = AuthState.authenticated(updated);
  }
}

@riverpod
UserModel? currentUser(CurrentUserRef ref) {
  return ref.watch(authNotifierProvider).user;
}

@riverpod
UserRole currentUserRole(CurrentUserRoleRef ref) {
  return ref.watch(authNotifierProvider).role;
}

@riverpod
bool isResourceOwner(IsResourceOwnerRef ref) {
  return ref.watch(authNotifierProvider).isOwner;
}