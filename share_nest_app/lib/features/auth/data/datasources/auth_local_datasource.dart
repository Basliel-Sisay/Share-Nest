import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._db);

  final DatabaseHelper _db;

  Future<void> saveUser(UserModel user) async {
    final database = await _db.database;
    await database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser() async {
    final database = await _db.database;
    final rows = await database.query('users', limit: 1);
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<String?> getToken() async {
    final user = await getUser();
    return user?.token;
  }

  Future<void> deleteUser() async {
    final database = await _db.database;
    await database.delete('users');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
