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

  Future<ReservationItem> create(ReservationItem item) async {
    final row = await _client.post('/api/reservations', item.toMap());
    return ReservationItem.fromMap(row);
  }
}
