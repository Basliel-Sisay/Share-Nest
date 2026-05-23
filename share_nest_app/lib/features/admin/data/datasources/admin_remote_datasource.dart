import '../../../../core/network/api_client.dart';

class AdminRemoteDataSource {
  AdminRemoteDataSource({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    return _client.getList('/api/admin/users');
  }

  Future<Map<String, dynamic>> updateUserRole(String userId, String role) async {
    return _client.patch('/api/admin/users/$userId/role', {'role': role});
  }

  Future<void> deleteUser(String userId) async {
    await _client.delete('/api/admin/users/$userId');
  }

  Future<List<Map<String, dynamic>>> fetchAllLoans() async {
    return _client.getList('/api/admin/loans');
  }

  Future<List<Map<String, dynamic>>> fetchAllReservations() async {
    return _client.getList('/api/admin/reservations');
  }

  Future<Map<String, dynamic>> updateLoanStatus(String loanId, String status) async {
    return _client.patch('/api/admin/loans/$loanId/status', {'status': status});
  }

  Future<Map<String, dynamic>> updateResource(String id, Map<String, dynamic> data) async {
    return _client.patch('/api/admin/resources/$id', data);
  }

  Future<void> deleteResource(String id) async {
    await _client.delete('/api/admin/resources/$id');
  }

  Future<Map<String, dynamic>> updateReservationStatus(String id, String status) async {
    return _client.patch('/api/admin/reservations/$id/status', {'status': status});
  }

  Future<Map<String, dynamic>> fetchStats() async {
    return _client.getOne('/api/admin/stats');
  }
}
