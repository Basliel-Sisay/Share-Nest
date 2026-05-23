import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../models/resource_item.dart';

class ResourceLocalDataSource {
  ResourceLocalDataSource(this._db);

  final DatabaseHelper _db;

  Future<List<ResourceItem>> getAll() async {
    final database = await _db.database;
    final rows = await database.query('resources', orderBy: 'title ASC');
    return rows.map(ResourceItem.fromMap).toList();
  }

  Future<ResourceItem?> getById(String id) async {
    final database = await _db.database;
    final rows = await database.query(
      'resources',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ResourceItem.fromMap(rows.first);
  }

  Future<void> insertAll(List<ResourceItem> items) async {
    final database = await _db.database;
    final batch = database.batch();
    for (final item in items) {
      batch.insert(
        'resources',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insert(ResourceItem item) async {
    final database = await _db.database;
    await database.insert(
      'resources',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> count() async {
    final database = await _db.database;
    final result =
        await database.rawQuery('SELECT COUNT(*) as c FROM resources');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
