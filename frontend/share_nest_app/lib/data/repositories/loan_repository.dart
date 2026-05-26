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

  Future<LoanItem> requestLoan(Map<String, dynamic> data) async {
    try {
      final created = await _remote.create(data);
      await _local.insert(created);
      return created;
    } catch (_) {
      final fallback = LoanItem(
        id: data['id'] as String? ?? 'loan-${DateTime.now().millisecondsSinceEpoch}',
        resourceId: data['resource_id'] as String,
        title: data['title'] as String,
        ownerId: data['owner_id'] as String,
        ownerName: data['owner_name'] as String? ?? '',
        borrowerId: data['borrower_id'] as String? ?? '',
        borrowerName: data['borrower_name'] as String? ?? 'You',
        statusText: 'PENDING',
        dateText: 'Request submitted',
        pickupDate: DateTime.parse(data['pickup_date'] as String),
        returnDate: DateTime.parse(data['return_date'] as String),
        imagePath: data['image_path'] as String? ?? '',
        pickupTime: data['pickup_time'] as String? ?? '',
        returnTime: data['return_time'] as String? ?? '',
      );
      await _local.insert(fallback);
      return fallback;
    }
  }

  Future<LoanItem> updateLoanStatus(String loanId, String status) async {
    try {
      final updated = await _remote.updateStatus(loanId, status);
      await _local.update(updated);
      return updated;
    } catch (_) {
      final loans = await getLoans();
      final loan = loans.firstWhere((l) => l.id == loanId);
      final updated = loan.copyWith(statusText: status);
      await _local.update(updated);
      return updated;
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
