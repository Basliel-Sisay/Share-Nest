import 'dart:io' show Platform;

import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  static sqflite.Database? _database;

  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<sqflite.Database> _initDatabase() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      final factory = databaseFactoryFfi;
      final dbPath = await factory.getDatabasesPath();
      final path = p.join(dbPath, 'sharenest.db');
      return factory.openDatabase(
        path,
        options: sqflite.OpenDatabaseOptions(
          version: 3,
          onCreate: (db, version) => _onCreate(db),
          onUpgrade: (db, oldVersion, newVersion) => _onUpgrade(db, oldVersion, newVersion),
        ),
      );
    }

    final dbPath = await sqflite.getDatabasesPath();
    final path = p.join(dbPath, 'sharenest.db');
    return sqflite.openDatabase(
      path,
      version: 3,
      onCreate: (db, version) => _onCreate(db),
      onUpgrade: (db, oldVersion, newVersion) => _onUpgrade(db, oldVersion, newVersion),
    );
  }

  Future<void> _onCreate(sqflite.Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL DEFAULT '',
        role TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sessions (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        token TEXT NOT NULL,
        expiresAt TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS auth_tokens (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        accessToken TEXT NOT NULL,
        refreshToken TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');
    await _createItemsTables(db);
  }

  Future<void> _createItemsTables(sqflite.Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS items (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        ownerId TEXT NOT NULL,
        ownerName TEXT NOT NULL,
        distance TEXT,
        rating REAL,
        status TEXT,
        imagePath TEXT,
        cachedAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cache_metadata (
        cacheKey TEXT PRIMARY KEY,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE users ADD COLUMN password TEXT NOT NULL DEFAULT ""',
      );
    }
    if (oldVersion < 3) {
      await _createItemsTables(db);
    }
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return db.insert(table, data, conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    return db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('auth_tokens');
    await db.delete('sessions');
    await db.delete('users');
    await db.delete('items');
    await db.delete('cache_metadata');
  }

  // --- Items cache (Person 3: SQLite helper) ---

  Future<List<Map<String, dynamic>>> getAllItems() async {
    return query('items', orderBy: 'title ASC');
  }

  Future<void> replaceAllItems(List<Map<String, dynamic>> rows) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('items');
      for (final row in rows) {
        await txn.insert(
          'items',
          row,
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<DateTime?> getCacheUpdatedAt(String cacheKey) async {
    final results = await query(
      'cache_metadata',
      where: 'cacheKey = ?',
      whereArgs: [cacheKey],
    );
    if (results.isEmpty) return null;
    return DateTime.tryParse(results.first['updatedAt'] as String);
  }

  Future<void> setCacheUpdatedAt(String cacheKey, DateTime updatedAt) async {
    await insert('cache_metadata', {
      'cacheKey': cacheKey,
      'updatedAt': updatedAt.toIso8601String(),
    });
  }
}
