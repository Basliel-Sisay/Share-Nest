import '../domain/entities/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({
    required this.status,
    this.user,
    this.error,
  });

  const AuthState.unknown()
      : status = AuthStatus.unknown,
        user = null,
        error = null;

  const AuthState.authenticated(User user)
      : status = AuthStatus.authenticated,
        user = user,
        error = null;

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        error = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        error = null;

  const AuthState.error(String error)
      : status = AuthStatus.error,
        user = null,
        error = error;

  AuthState copyWith({AuthStatus? status, User? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
