import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../data/models/loan_item.dart';
import '../widgets/loan_item_card.dart';

class MyLoanScreen extends ConsumerStatefulWidget {
  const MyLoanScreen({super.key});

  @override
  ConsumerState<MyLoanScreen> createState() => _MyLoanScreenState();
}

class _MyLoanScreenState extends ConsumerState<MyLoanScreen> {
  int _tabIndex = 0;

  Future<void> _extendLoan(String loanId, DateTime currentReturn) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: currentReturn.add(const Duration(days: 3)),
      firstDate: currentReturn,
      lastDate: currentReturn.add(const Duration(days: 90)),
    );
    if (newDate == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentReturn),
    );
    if (time == null) return;

    final extended = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      time.hour,
      time.minute,
    );

    await ref.read(loansProvider.notifier).extendLoan(loanId, extended);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Loan extended to ${DateFormat('MMMM d, h:mm a').format(extended)}',
        ),
      ),
    );
  }

  Future<void> _updateLoanStatus(String loanId, String status) async {
    await ref.read(loansProvider.notifier).updateLoanStatus(loanId, status);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Loan $status')),
    );
  }

  Future<void> _cancelReservation(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Reservation'),
        content: const Text('Are you sure you want to cancel this reservation?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(reservationsProvider.notifier).deleteReservation(id);
  }

  void _showLoanActions(LoanItem loan, String currentUserId) {
    final isOwner = loan.ownerId == currentUserId;
    final isBorrower = loan.borrowerId == currentUserId;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            if (loan.isPending && isOwner) ...[
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Approve'),
                onTap: () {
                  Navigator.pop(ctx);
                  _updateLoanStatus(loan.id, 'APPROVED');
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Reject'),
                onTap: () {
                  Navigator.pop(ctx);
                  _updateLoanStatus(loan.id, 'REJECTED');
                },
              ),
            ],
            if ((loan.isPending || loan.isApproved) && (isBorrower || isOwner)) ...[
              ListTile(
                leading: const Icon(Icons.cancel_outlined, color: Colors.orange),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(ctx);
                  _updateLoanStatus(loan.id, 'CANCELLED');
                },
              ),
            ],
            if (loan.isActive && isOwner) ...[
              ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Colors.grey),
                title: const Text('Mark as Returned'),
                onTap: () {
                  Navigator.pop(ctx);
                  _updateLoanStatus(loan.id, 'RETURNED');
                },
              ),
            ],
            if (loan.isActive || loan.isApproved) ...[
              ListTile(
                leading: const Icon(Icons.update, color: Colors.blue),
                title: const Text('Extend Loan'),
                onTap: () {
                  Navigator.pop(ctx);
                  _extendLoan(loan.id, loan.returnDate);
                },
              ),
            ],
            if (!loan.isPending && !loan.isApproved && !loan.isActive) ...[
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.grey),
                title: const Text('No actions available'),
                enabled: false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loansAsync = ref.watch(loansProvider);
    final reservationsAsync = ref.watch(reservationsProvider);
    final currentUser = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Row(
              children: [
                Text(
                  'NEST_ ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.eco, color: Colors.black, size: 26),
              ],
            ),
            Text(
              'ShareNest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.green,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Activity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Track your current shares and upcoming bookings',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBlue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _tabIndex = 0),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _tabIndex == 0
                                    ? AppColors.primaryGreen
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: Text(
                                  'Loans',
                                  style: TextStyle(
                                    color: _tabIndex == 0
                                        ? Colors.white
                                        : AppColors.textGrey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _tabIndex = 1),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _tabIndex == 1
                                    ? AppColors.primaryGreen
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: Text(
                                  'Reservations',
                                  style: TextStyle(
                                    color: _tabIndex == 1
                                        ? Colors.white
                                        : AppColors.textGrey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_tabIndex == 0)
                    loansAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (e, _) => Text('Error: $e'),
                      data: (loans) => Column(
                        children: loans
                            .map(
                              (loan) => LoanItemCard(
                                title: loan.title,
                                ownerName: loan.ownerName,
                                statusText: loan.statusText,
                                dateText: loan.dateText,
                                buttonText: 'Manage',
                                statusColor: Color(loan.statusColorArgb),
                                statusTextColor:
                                    Color(loan.statusTextColorArgb),
                                onButtonPressed: () {
                                  if (currentUser != null) {
                                    _showLoanActions(loan, currentUser.id);
                                  }
                                },
                              ),
                            )
                            .toList(),
                      ),
                    )
                  else
                    reservationsAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (e, _) => Text('Error: $e'),
                      data: (reservations) {
                        if (reservations.isEmpty) {
                          return const Text('No reservations yet.');
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Reservations',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...reservations.map(
                              (r) => _ReservationCard(
                                title: r.title,
                                status: r.status,
                                location: r.pickupLocation,
                                dateRange: r.dateRangeLabel,
                                distance: r.distance,
                                onViewDetails: () =>
                                    context.push('/item/${r.resourceId}'),
                                onCancel: r.isPending || r.isConfirmed
                                    ? () => _cancelReservation(r.id)
                                    : null,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  if (_tabIndex == 0) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Upcoming Reservations',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    reservationsAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                      data: (reservations) {
                        if (reservations.isEmpty) {
                          return const Text(
                            'No upcoming reservations.',
                            style: TextStyle(color: AppColors.textGrey),
                          );
                        }
                        final r = reservations.first;
                        return _ReservationCard(
                          title: r.title,
                          status: r.status,
                          location: r.pickupLocation,
                          dateRange: r.dateRangeLabel,
                          distance: r.distance,
                          onViewDetails: () =>
                              context.push('/item/${r.resourceId}'),
                          onCancel: r.isPending || r.isConfirmed
                              ? () => _cancelReservation(r.id)
                              : null,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  const _ReservationCard({
    required this.title,
    required this.status,
    required this.location,
    required this.dateRange,
    required this.distance,
    required this.onViewDetails,
    this.onCancel,
  });

  final String title;
  final String status;
  final String location;
  final String dateRange;
  final String distance;
  final VoidCallback onViewDetails;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.chair_alt_outlined,
              color: AppColors.textGrey,
              size: 40,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: AppColors.darkGreen,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            location,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: AppColors.darkGreen,
              ),
              const SizedBox(width: 4),
              Text(
                dateRange,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.darkGreen,
              ),
              const SizedBox(width: 4),
              Text(
                distance,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onViewDetails,
                  child: const Text('View Details'),
                ),
              ),
              if (onCancel != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
