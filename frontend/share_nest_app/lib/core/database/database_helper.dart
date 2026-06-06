import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseHelperProvider = Provider<DatabaseHelper>(
  (ref) => DatabaseHelper.instance,
);

class DatabaseHelper{
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static const _dbName = 'share_nest.db';
  static const _dbVersion = 7;
  Database? _database;

  Future<Database> get database async{
    _database ??= await _init();
    return _database!;
  }

  Future<Database> _init() async{
    String path;
    if (kIsWeb) {
      path = _dbName;
    } else {
      path = join(await getDatabasesPath(), _dbName);
    }
    
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  Future<bool> _columnExists(Database db, String table, String column) async{
    final result = await db.rawQuery('PRAGMA table_info($table)');
    for (final row in result){
      if (row['name'] == column){
         return true;
        }
    }
    return false;
  }
  Future<void> _addColumnIfNotExists(
      Database db, String table, String columnDef) async{
    final colName = columnDef.split(' ').first;
    if (!await _columnExists(db, table, colName)){
      await db.execute('ALTER TABLE $table ADD COLUMN $columnDef');
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if (oldVersion < 2){
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          token TEXT NOT NULL DEFAULT ''
        )
      ''');
    }
    if (oldVersion < 3){
      await _addColumnIfNotExists(
          db, 'resources', 'owner_id TEXT NOT NULL DEFAULT ""');
      await _addColumnIfNotExists(
          db, 'loans', 'owner_id TEXT NOT NULL DEFAULT ""');
      await _addColumnIfNotExists(
          db, 'loans', 'borrower_id TEXT NOT NULL DEFAULT ""');
      await _addColumnIfNotExists(
          db, 'loans', 'borrower_name TEXT NOT NULL DEFAULT ""');
      await _addColumnIfNotExists(
          db, 'loans', 'pickup_date TEXT NOT NULL DEFAULT ""');
      await _addColumnIfNotExists(
          db, 'loans', 'pickup_time TEXT NOT NULL DEFAULT ""');
      await _addColumnIfNotExists(
          db, 'loans', 'return_time TEXT NOT NULL DEFAULT ""');
      await _addColumnIfNotExists(
          db, 'reservations', 'owner_id TEXT NOT NULL DEFAULT ""');
      await _addColumnIfNotExists(
          db, 'reservations', 'borrower_id TEXT NOT NULL DEFAULT ""');
    }
    if (oldVersion < 4){
      await _addColumnIfNotExists(
          db, 'users', 'role TEXT NOT NULL DEFAULT "user"');
    }
    if (oldVersion < 5){
      await _addColumnIfNotExists(db, 'users', 'imagePath TEXT');
    }
    if (oldVersion < 6){
      await _addColumnIfNotExists(db, 'loans', 'image_path TEXT DEFAULT ""');
    }
    if (oldVersion < 7){
      await _addColumnIfNotExists(db, 'reservations', 'image_path TEXT');
    }
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('resources');
    await db.delete('loans');
    await db.delete('reservations');
    await db.delete('users');
  }

  Future<void> _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE resources (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        owner_id TEXT NOT NULL DEFAULT '',
        owner_name TEXT NOT NULL,
        distance TEXT NOT NULL,
        rating REAL NOT NULL,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        image_path TEXT NOT NULL,
        location TEXT,
        condition TEXT,
        status_text TEXT,
        is_available INTEGER NOT NULL DEFAULT 1
      )
    ''');
    await db.execute('''
      CREATE TABLE loans (
        id TEXT PRIMARY KEY,
        resource_id TEXT NOT NULL,
        title TEXT NOT NULL,
        owner_id TEXT NOT NULL DEFAULT '',
        owner_name TEXT NOT NULL,
        borrower_id TEXT NOT NULL DEFAULT '',
        borrower_name TEXT NOT NULL DEFAULT '',
        status_text TEXT NOT NULL,
        date_text TEXT NOT NULL,
        pickup_date TEXT NOT NULL DEFAULT '',
        return_date TEXT NOT NULL,
        pickup_time TEXT NOT NULL DEFAULT '',
        return_time TEXT NOT NULL DEFAULT '',
        status_color INTEGER NOT NULL,
        status_text_color INTEGER NOT NULL,
        image_path TEXT DEFAULT ''
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'user',
        token TEXT NOT NULL DEFAULT '',
        imagePath TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE reservations (
        id TEXT PRIMARY KEY,
        resource_id TEXT NOT NULL,
        title TEXT NOT NULL,
        owner_id TEXT NOT NULL DEFAULT '',
        borrower_id TEXT NOT NULL DEFAULT '',
        pickup_location TEXT NOT NULL,
        pickup_date TEXT NOT NULL,
        return_date TEXT NOT NULL,
        pickup_time TEXT NOT NULL,
        return_time TEXT NOT NULL,
        distance TEXT,
        status TEXT,
        image_path TEXT
      )
    ''');
  }
}
