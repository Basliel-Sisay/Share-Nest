import '../../core/network/api_client.dart';
import '../models/loan_item.dart';

class LoanRemoteDataSource {
  LoanRemoteDataSource({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<LoanItem>> fetchAll() async {
    final rows = await _client.getList('/api/loans');
    return rows.map(LoanItem.fromMap).toList();
  }

  Future<LoanItem> extendLoan(String loanId, DateTime newReturnDate) async {
    final row = await _client.patch(
      '/api/loans/$loanId/extend',
      {'return_date': newReturnDate.toIso8601String()},
    );
    return LoanItem.fromMap(row);
  }
}
