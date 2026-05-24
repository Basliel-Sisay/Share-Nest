import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../widgets/history_item_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _viewMode = 'Borrowing'; // or 'Lending'

  Future<void> _updateStatus(String loanId, String status) async {
    try {
      await ref.read(loansProvider.notifier).updateLoanStatus(loanId, status);
      // Refresh resources to update availability status in the UI
      await ref.read(resourcesProvider.notifier).refresh();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loan status updated to $status')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loansAsync = ref.watch(loansProvider);
    final currentUser = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 21, 125, 58),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Sharing History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'ShareNest',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: loansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (loans) {
          final userId = currentUser?.id ?? '';
          
          final filteredLoans = _viewMode == 'Borrowing'
              ? loans.where((l) => l.borrowerId == userId).toList()
              : loans.where((l) => l.ownerId == userId).toList();

          final active = filteredLoans.where((l) => l.isActive || l.isApproved || l.isPending).toList();
          final completed = filteredLoans.where((l) => l.isReturned || l.isCancelled || l.isRejected).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Borrowing', label: Text('Borrowing'), icon: Icon(Icons.download)),
                    ButtonSegment(value: 'Lending', label: Text('Lending'), icon: Icon(Icons.upload)),
                  ],
                  selected: {_viewMode},
                  onSelectionChanged: (val) => setState(() => _viewMode = val.first),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (active.isNotEmpty) ...[
                        const Text(
                          'ACTIVE REQUESTS',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 73, 83, 95),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...active.map((loan) {
                          final isOwner = loan.ownerId == userId;
                          return HistoryItemTile(
                            itemName: loan.title,
                            borrower: isOwner ? loan.borrowerName : loan.ownerName,
                            period: loan.dateText,
                            stateLabel: loan.statusText,
                            stateColor: Color(loan.statusColorArgb),
                            isOwner: isOwner,
                            onApprove: (isOwner && loan.isPending) ? () => _updateStatus(loan.id, 'APPROVED') : null,
                            onReject: (isOwner && loan.isPending) ? () => _updateStatus(loan.id, 'REJECTED') : null,
                            onCancel: (!isOwner && loan.isPending) ? () => _updateStatus(loan.id, 'CANCELLED') : null,
                            onReturn: (isOwner && loan.isApproved) ? () => _updateStatus(loan.id, 'RETURNED') : null,
                          );
                        }),
                        const SizedBox(height: 24),
                      ],
                      if (completed.isNotEmpty) ...[
                        const Text(
                          'COMPLETED',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 73, 83, 95),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...completed.map((loan) {
                          final isOwner = loan.ownerId == userId;
                          return HistoryItemTile(
                            itemName: loan.title,
                            borrower: isOwner ? loan.borrowerName : loan.ownerName,
                            period: loan.dateText,
                            stateLabel: loan.statusText,
                            stateColor: Color(loan.statusColorArgb),
                            isOwner: isOwner,
                          );
                        }),
                        const SizedBox(height: 18),
                      ],
                      if (filteredLoans.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  _viewMode == 'Borrowing' 
                                    ? 'You haven\'t borrowed anything yet.' 
                                    : 'You haven\'t lent anything yet.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 74,
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 206, 206, 206),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => context.go('/home'),
              child: const _HistoryNavItem(
                  icon: Icons.home_outlined, label: 'HOME'),
            ),
            const _HistoryNavItem(
              icon: Icons.history,
              label: 'HISTORY',
              isActive: true,
            ),
            GestureDetector(
              onTap: () => context.push('/help-center'),
              child: const _HistoryNavItem(
                  icon: Icons.help_outline, label: 'HELP'),
            ),
            GestureDetector(
              onTap: () => context.go('/settings'),
              child: const _HistoryNavItem(
                  icon: Icons.settings, label: 'SETTINGS'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryNavItem extends StatelessWidget {
  const _HistoryNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 188, 232, 200),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 29, 121, 64), size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(255, 29, 121, 64),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color.fromARGB(255, 98, 114, 130), size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 98, 114, 130),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
