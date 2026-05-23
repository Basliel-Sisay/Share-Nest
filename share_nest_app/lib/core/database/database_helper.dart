import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'share_nest.db';
  static const _dbVersion = 2;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          token TEXT NOT NULL DEFAULT ''
        )
      ''');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE resources (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
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
        owner_name TEXT NOT NULL,
        status_text TEXT NOT NULL,
        date_text TEXT NOT NULL,
        return_date TEXT NOT NULL,
        status_color INTEGER NOT NULL,
        status_text_color INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        token TEXT NOT NULL DEFAULT ''
      )
    ''');
    await db.execute('''
      CREATE TABLE reservations (
        id TEXT PRIMARY KEY,
        resource_id TEXT NOT NULL,
        title TEXT NOT NULL,
        pickup_location TEXT NOT NULL,
        pickup_date TEXT NOT NULL,
        return_date TEXT NOT NULL,
        pickup_time TEXT NOT NULL,
        return_time TEXT NOT NULL,
        distance TEXT,
        status TEXT
      )
    ''');
  }
}
