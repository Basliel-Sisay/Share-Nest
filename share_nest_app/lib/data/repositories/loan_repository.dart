import 'package:intl/intl.dart';

import '../datasources/loan_local_datasource.dart';
import '../datasources/loan_remote_datasource.dart';
import '../datasources/seed_data.dart';
import '../models/loan_item.dart';

class LoanRepository {
  LoanRepository({
    required LoanLocalDataSource local,
    required LoanRemoteDataSource remote,
  })  : _local = local,
        _remote = remote;

  final LoanLocalDataSource _local;
  final LoanRemoteDataSource _remote;

  Future<List<LoanItem>> getLoans({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _local.getAll();
      if (cached.isNotEmpty) return cached;
    }

    try {
      final remote = await _remote.fetchAll();
      await _local.insertAll(remote);
      return remote;
    } catch (_) {
      final fallback = SeedData.loans();
      await _local.insertAll(fallback);
      return fallback;
    }
  }

  Future<LoanItem> extendLoan(String loanId, DateTime newReturnDate) async {
    try {
      final updated = await _remote.extendLoan(loanId, newReturnDate);
      await _local.update(updated);
      return updated;
    } catch (_) {
      final loans = await getLoans();
      final loan = loans.firstWhere((l) => l.id == loanId);
      final formatted = DateFormat('MMMM d, h:mm a').format(newReturnDate);
      final updated = loan.copyWith(
        returnDate: newReturnDate,
        dateText: 'Return by $formatted',
        statusText: 'EXTENDED',
      );
      await _local.update(updated);
      return updated;
    }
  }
}
