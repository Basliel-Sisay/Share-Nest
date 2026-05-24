import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../core/widgets/resource_image.dart';
import '../../../../data/models/loan_item.dart';
import '../../../../data/models/reservation_item.dart';
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
          TextButton(onPressed: () => ctx.pop(false), child: const Text('No')),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(reservationsProvider.notifier).deleteReservation(id);
  }

  Future<void> _confirmReservation(String id) async {
    try {
      final api = ref.read(apiClientProvider);
      await api.patch('/api/reservations/$id/status', {'status': 'CONFIRMED'});
      await ref.read(reservationsProvider.notifier).deleteReservation(id); // force refresh
      ref.invalidate(reservationsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation confirmed')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    }
  }

  void _showReservationActions(ReservationItem r, String currentUserId, String currentUserRole) {
    final isOwner = r.ownerId == currentUserId;
    final isAdmin = currentUserRole == 'admin';

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            if (r.isPending && (isOwner || isAdmin)) ...[
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Confirm Reservation'),
                onTap: () {
                  ctx.pop();
                  _confirmReservation(r.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Reject Reservation'),
                onTap: () {
                  ctx.pop();
                  _cancelReservation(r.id);
                },
              ),
            ],
            if (r.isPending || r.isConfirmed) ...[
              ListTile(
                leading: const Icon(Icons.cancel_outlined, color: Colors.orange),
                title: const Text('Cancel'),
                onTap: () {
                  ctx.pop();
                  _cancelReservation(r.id);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLoanActions(LoanItem loan, String currentUserId, String currentUserRole) {
    final isOwner = loan.ownerId == currentUserId;
    final isBorrower = loan.borrowerId == currentUserId;
    final isAdmin = currentUserRole == 'admin';

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            if (loan.isPending && (isOwner || isAdmin)) ...[
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Confirm'),
                onTap: () {
                  ctx.pop();
                  _updateLoanStatus(loan.id, 'CONFIRMED');
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Reject'),
                onTap: () {
                  ctx.pop();
                  _updateLoanStatus(loan.id, 'REJECTED');
                },
              ),
            ],
            if ((loan.isPending || loan.isApproved || loan.isActive) && (isBorrower || isOwner || isAdmin)) ...[
              ListTile(
                leading: const Icon(Icons.cancel_outlined, color: Colors.orange),
                title: const Text('Cancel'),
                onTap: () {
                  ctx.pop();
                  _updateLoanStatus(loan.id, 'CANCELLED');
                },
              ),
            ],
            if (loan.isActive && (isOwner || isAdmin)) ...[
              ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Colors.grey),
                title: const Text('Mark as Returned'),
                onTap: () {
                  ctx.pop();
                  _updateLoanStatus(loan.id, 'RETURNED');
                },
              ),
            ],
            if (loan.isActive || loan.isApproved || loan.isExtended) ...[
              ListTile(
                leading: const Icon(Icons.update, color: Colors.blue),
                title: const Text('Extend Loan'),
                onTap: () {
                  ctx.pop();
                  _extendLoan(loan.id, loan.returnDate);
                },
              ),
            ],
            if (!loan.isPending && !loan.isApproved && !loan.isActive && !loan.isExtended) ...[
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
                                borrowerName: loan.borrowerName,
                                isOwner: currentUser?.id == loan.ownerId,
                                statusText: loan.statusText,
                                dateText: loan.dateText,
                                buttonText: 'Manage',
                                statusColor: Color(loan.statusColorArgb),
                                statusTextColor:
                                    Color(loan.statusTextColorArgb),
                                onButtonPressed: () {
                                  if (currentUser != null) {
                                    _showLoanActions(loan, currentUser.id, currentUser.role);
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
                        final allResources = ref.watch(resourcesProvider);
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
                              (r) {
                                final imagePath = allResources.maybeWhen(
                                  data: (resources) {
                                    final resource = resources.firstWhereOrNull(
                                      (res) => res.id == r.resourceId,
                                    );
                                    return resource?.imagePath ?? 'assets/images/drill.png';
                                  },
                                  orElse: () => 'assets/images/drill.png',
                                );
                                return _ReservationCard(
                                  title: r.title,
                                  status: r.status,
                                  location: r.pickupLocation,
                                  dateRange: r.dateRangeLabel,
                                  distance: r.distance,
                                  imagePath: imagePath,
                                  onViewDetails: () =>
                                      context.push('/item/${r.resourceId}'),
                                  onCancel: r.isPending || r.isConfirmed
                                      ? () => _cancelReservation(r.id)
                                      : null,
                                  onManage: (currentUser != null && (r.ownerId == currentUser.id || currentUser.role == 'admin') && r.isPending)
                                      ? () => _showReservationActions(r, currentUser.id, currentUser.role)
                                      : null,
                                );
                              },
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
                        final allResources = ref.watch(resourcesProvider);
                        final imagePath = allResources.maybeWhen(
                          data: (resources) {
                            final resource = resources.firstWhereOrNull(
                              (res) => res.id == r.resourceId,
                            );
                            return resource?.imagePath ?? 'assets/images/drill.png';
                          },
                          orElse: () => 'assets/images/drill.png',
                        );
                        return _ReservationCard(
                          title: r.title,
                          status: r.status,
                          location: r.pickupLocation,
                          dateRange: r.dateRangeLabel,
                          distance: r.distance,
                          imagePath: imagePath,
                          onViewDetails: () =>
                              context.push('/item/${r.resourceId}'),
                          onCancel: r.isPending || r.isConfirmed
                              ? () => _cancelReservation(r.id)
                              : null,
                          onManage: (currentUser != null && (r.ownerId == currentUser.id || currentUser.role == 'admin') && r.isPending)
                              ? () => _showReservationActions(r, currentUser.id, currentUser.role)
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
    required this.imagePath,
    required this.onViewDetails,
    this.onCancel,
    this.onManage,
  });

  final String title;
  final String status;
  final String location;
  final String dateRange;
  final String distance;
  final String imagePath;
  final VoidCallback onViewDetails;
  final VoidCallback? onCancel;
  final VoidCallback? onManage;

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ResourceImage(
                path: imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.contain,
              ),
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
              if (onManage != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onManage,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Manage', style: TextStyle(color: Colors.white)),
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
