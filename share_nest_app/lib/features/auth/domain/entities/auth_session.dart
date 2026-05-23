class AuthSession {
  final String id;
  final String userId;
  final String token;
  final String refreshToken;
  final DateTime expiresAt;
  final bool isActive;

  const AuthSession({
    required this.id,
    required this.userId,
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
    required this.isActive,
  });

  bool get isValid => isActive && expiresAt.isAfter(DateTime.now());
}
