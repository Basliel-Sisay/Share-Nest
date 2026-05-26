import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../models/loan_item.dart';

class LoanLocalDataSource {
  LoanLocalDataSource(this._db);

  final DatabaseHelper _db;

  Future<List<LoanItem>> getAll() async {
    final database = await _db.database;
    final rows = await database.query('loans');
    return rows.map(LoanItem.fromMap).toList();
  }

  Future<void> insertAll(List<LoanItem> items) async {
    final database = await _db.database;
    final batch = database.batch();
    for (final item in items) {
      batch.insert(
        'loans',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> insert(LoanItem item) async {
    final database = await _db.database;
    await database.insert(
      'loans',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(LoanItem item) async {
    final database = await _db.database;
    await database.update(
      'loans',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> delete(String id) async {
    final database = await _db.database;
    await database.delete('loans', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final database = await _db.database;
    final result = await database.rawQuery('SELECT COUNT(*) as c FROM loans');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
