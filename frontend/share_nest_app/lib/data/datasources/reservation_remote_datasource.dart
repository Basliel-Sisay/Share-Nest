import '../../core/network/api_client.dart';
import '../models/reservation_item.dart';

class ReservationRemoteDataSource {
  ReservationRemoteDataSource({ApiClient? client})
      : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<ReservationItem>> fetchAll() async {
    final rows = await _client.getList('/api/reservations');
    return rows.map(ReservationItem.fromMap).toList();
  }

  Future<ReservationItem> create(Map<String, dynamic> data) async {
    final row = await _client.post('/api/reservations', data);
    return ReservationItem.fromMap(row);
  }

  Future<ReservationItem> update(String id, Map<String, dynamic> data) async {
    final row = await _client.put('/api/reservations/$id', data);
    return ReservationItem.fromMap(row);
  }

  Future<void> delete(String id) async {
    await _client.delete('/api/reservations/$id');
  }
}
