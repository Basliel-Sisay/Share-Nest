import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../widgets/history_item_tile.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansProvider);

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loansAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (loans) {
            final completed = loans.where((l) => l.isReturned || l.isCancelled || l.isRejected).toList();
            final active = loans.where((l) => l.isActive || l.isApproved || l.isPending).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Impact',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 22, 36, 52),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (completed.isNotEmpty) ...[
                    const Text(
                      'COMPLETED',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 73, 83, 95),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...completed.map((loan) => HistoryItemTile(
                      itemName: loan.title,
                      borrower: loan.borrowerName,
                      period: loan.dateText,
                      stateLabel: loan.statusText,
                      stateColor: Color(loan.statusColorArgb),
                    )),
                    const SizedBox(height: 18),
                  ],
                  if (active.isNotEmpty) ...[
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 73, 83, 95),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...active.map((loan) => HistoryItemTile(
                      itemName: loan.title,
                      borrower: loan.borrowerName,
                      period: loan.dateText,
                      stateLabel: loan.statusText,
                      stateColor: Color(loan.statusColorArgb),
                    )),
                    const SizedBox(height: 18),
                  ],
                  if (completed.isEmpty && active.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No loan history yet. Start sharing!'),
                    ),
                ],
              ),
            );
          },
        ),
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
              onTap: () {},
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
