import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthStateInitial;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.authenticated(UserModel user) = AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.error(String message) = AuthStateError;
}

extension AuthStateX on AuthState {
  bool get isAuthenticated => this is AuthStateAuthenticated;
  bool get isLoading => this is AuthStateLoading;
  bool get isInitial => this is AuthStateInitial;

  UserModel? get user =>
      this is AuthStateAuthenticated
          ? (this as AuthStateAuthenticated).user
          : null;

  UserRole get role => user?.role ?? UserRole.regularUser;

  bool get isOwner => role.isOwner;
}