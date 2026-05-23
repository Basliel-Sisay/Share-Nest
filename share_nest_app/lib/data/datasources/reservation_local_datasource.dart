import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../models/reservation_item.dart';

class ReservationLocalDataSource {
  ReservationLocalDataSource(this._db);

  final DatabaseHelper _db;

  Future<List<ReservationItem>> getAll() async {
    final database = await _db.database;
    final rows = await database.query('reservations');
    return rows.map(ReservationItem.fromMap).toList();
  }

  Future<void> insert(ReservationItem item) async {
    final database = await _db.database;
    await database.insert(
      'reservations',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAll(List<ReservationItem> items) async {
    final database = await _db.database;
    final batch = database.batch();
    for (final item in items) {
      batch.insert(
        'reservations',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> update(ReservationItem item) async {
    final database = await _db.database;
    await database.update(
      'reservations',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> delete(String id) async {
    final database = await _db.database;
    await database.delete('reservations', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final database = await _db.database;
    final result =
        await database.rawQuery('SELECT COUNT(*) as c FROM reservations');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
