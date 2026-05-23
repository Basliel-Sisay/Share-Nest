import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../data/datasources/admin_remote_datasource.dart';

class AdminLoanManagementScreen extends ConsumerStatefulWidget {
  const AdminLoanManagementScreen({super.key});

  @override
  ConsumerState<AdminLoanManagementScreen> createState() => _AdminLoanManagementScreenState();
}

class _AdminLoanManagementScreenState extends ConsumerState<AdminLoanManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final loansAsync = ref.watch(loansProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text('All Loans', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: loansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (loans) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: loans.length,
          itemBuilder: (_, i) {
            final loan = loans[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(loan.title),
                subtitle: Text(
                  '${loan.borrowerName} -> ${loan.ownerName} | ${loan.statusText}',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (status) => _adminUpdateLoanStatus(loan.id, status),
                  itemBuilder: (_) => [
                    if (loan.isPending) ...[
                      const PopupMenuItem(value: 'CONFIRMED', child: Text('Confirm')),
                      const PopupMenuItem(value: 'REJECTED', child: Text('Reject')),
                    ],
                    if (loan.isPending || loan.isApproved || loan.isActive)
                      const PopupMenuItem(value: 'CANCELLED', child: Text('Cancel')),
                    if (loan.isActive) ...[
                      const PopupMenuItem(value: 'RETURNED', child: Text('Mark Returned')),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _adminUpdateLoanStatus(String loanId, String status) async {
    try {
      final api = ref.read(apiClientProvider);
      await AdminRemoteDataSource(client: api).updateLoanStatus(loanId, status);
      await ref.read(loansProvider.notifier).updateLoanStatus(loanId, status);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loan $status')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }
}
