import '../../../../core/database/app_database.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  final AppDatabase _database;
  final SecureStorage _storage;

  AuthLocalDataSource(this._database, this._storage);

  Future<void> cacheUser(UserModel user) async {
    await _database.insert('users', user.toDb());
  }

  Future<UserModel?> getCachedUser() async {
    final userId = await _storage.getUserId();
    if (userId == null) return null;
    final results = await _database.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (results.isEmpty) return null;
    return UserModel.fromDb(results.first);
  }

  Future<UserModel?> getUserByEmailAndPassword(
    String email,
    String password,
  ) async {
    final results = await _database.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isEmpty) return null;
    return UserModel.fromDb(results.first);
  }

  Future<bool> emailExists(String email) async {
    final results = await _database.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> cacheSession({
    required String userId,
    required String token,
    required String refreshToken,
  }) async {
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(days: 30));
    await _database.insert('sessions', {
      'id': _generateId(),
      'userId': userId,
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
      'isActive': 1,
    });
    await _database.insert('auth_tokens', {
      'id': _generateId(),
      'userId': userId,
      'accessToken': token,
      'refreshToken': refreshToken,
    });
    await _storage.saveAccessToken(token);
    await _storage.saveRefreshToken(refreshToken);
    await _storage.saveUserId(userId);
  }

  Future<String?> getStoredToken() async {
    return _storage.getAccessToken();
  }

  Future<void> clearAll() async {
    await _database.clearAll();
    await _storage.clearAll();
  }
}
