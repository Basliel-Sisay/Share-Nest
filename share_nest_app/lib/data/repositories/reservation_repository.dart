import '../datasources/reservation_local_datasource.dart';
import '../datasources/reservation_remote_datasource.dart';
import '../datasources/seed_data.dart';
import '../models/reservation_item.dart';

class ReservationRepository {
  ReservationRepository({
    required ReservationLocalDataSource local,
    required ReservationRemoteDataSource remote,
  })  : _local = local,
        _remote = remote;

  final ReservationLocalDataSource _local;
  final ReservationRemoteDataSource _remote;

  Future<List<ReservationItem>> getReservations({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _local.getAll();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final remote = await _remote.fetchAll();
      await _local.insertAll(remote);
      return remote;
    } catch (_) {
      final fallback = SeedData.reservations();
      await _local.insertAll(fallback);
      return fallback;
    }
  }

  Future<ReservationItem> createReservation(ReservationItem item) async {
    try {
      final created = await _remote.create(item.toMap());
      await _local.insert(created);
      return created;
    } catch (_) {
      await _local.insert(item);
      return item;
    }
  }

  Future<ReservationItem> updateReservation(ReservationItem item) async {
    try {
      final updated = await _remote.update(item.id, item.toMap());
      await _local.update(updated);
      return updated;
    } catch (_) {
      await _local.update(item);
      return item;
    }
  }

  Future<void> deleteReservation(String id) async {
    try {
      await _remote.delete(id);
    } catch (_) {}
    await _local.delete(id);
  }
}
