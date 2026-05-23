import '../../core/network/api_client.dart';
import '../models/loan_item.dart';

class LoanRemoteDataSource {
  LoanRemoteDataSource({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<LoanItem>> fetchAll() async {
    final rows = await _client.getList('/api/loans');
    return rows.map(LoanItem.fromMap).toList();
  }

  Future<LoanItem> create(Map<String, dynamic> data) async {
    final row = await _client.post('/api/loans', data);
    return LoanItem.fromMap(row);
  }

  Future<LoanItem> updateStatus(String loanId, String status) async {
    final row = await _client.patch(
      '/api/loans/$loanId/status',
      {'status': status},
    );
    return LoanItem.fromMap(row);
  }

  Future<LoanItem> extendLoan(String loanId, DateTime newReturnDate) async {
    final row = await _client.patch(
      '/api/loans/$loanId/extend',
      {'return_date': newReturnDate.toIso8601String()},
    );
    return LoanItem.fromMap(row);
  }
}
