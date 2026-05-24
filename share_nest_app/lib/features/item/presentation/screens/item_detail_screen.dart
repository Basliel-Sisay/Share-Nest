import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/widgets/resource_image.dart';
import '../../../../data/models/loan_item.dart';
import '../widgets/owner_info_tile.dart';

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.resourceId});

  final String resourceId;

  void _startReservation(BuildContext context, WidgetRef ref, String title) {
    ref.read(reservationDraftProvider.notifier).setDraft(
          ReservationDraft(resourceId: resourceId, resourceTitle: title),
        );
    context.push('/reservation');
  }

  Future<void> _requestBorrow(
      BuildContext context, WidgetRef ref, String title, String ownerId, String ownerName) async {
    final user = ref.watch(authProvider).user;
    if (user == null) return;

    final now = DateTime.now();
    final pickup = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (pickup == null || !context.mounted) return;

    final ret = await showDatePicker(
      context: context,
      initialDate: pickup.add(const Duration(days: 1)),
      firstDate: pickup,
      lastDate: pickup.add(const Duration(days: 90)),
    );
    if (ret == null || !context.mounted) return;

    final timeFormat = DateFormat.jm();
    final pickupTime = const TimeOfDay(hour: 10, minute: 0);
    final returnTime = const TimeOfDay(hour: 16, minute: 0);
    final pickupDt = DateTime(pickup.year, pickup.month, pickup.day, pickupTime.hour, pickupTime.minute);
    final returnDt = DateTime(ret.year, ret.month, ret.day, returnTime.hour, returnTime.minute);

    final loan = LoanItem(
      id: 'loan-${DateTime.now().millisecondsSinceEpoch}',
      resourceId: resourceId,
      title: title,
      ownerId: ownerId,
      ownerName: ownerName,
      borrowerId: user.id,
      borrowerName: user.name,
      statusText: 'PENDING',
      dateText: 'Pending confirmation',
      pickupDate: pickupDt,
      returnDate: returnDt,
      pickupTime: timeFormat.format(pickupDt),
      returnTime: timeFormat.format(returnDt),
      statusColorArgb: 0xFFF3E5F5,
      statusTextColorArgb: 0xFF7B1FA2,
    );

    try {
      await ref.read(loansProvider.notifier).requestLoan(loan.toMap());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loan request submitted. Awaiting confirmation')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to request loan: $e')),
      );
    }
  }

  void _deleteResource(BuildContext context, WidgetRef ref, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Resource'),
        content: const Text('Are you sure you want to delete this resource?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(resourcesProvider.notifier).deleteResource(id);
    if (!context.mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourceAsync = ref.watch(resourceByIdProvider(resourceId));
    final currentUser = ref.watch(authProvider).user;

    return Scaffold(
      body: SafeArea(
        child: resourceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (resource) {
            if (resource == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Resource not found'),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Go back'),
                    ),
                  ],
                ),
              );
            }

            final backLabel =
                resource.category == 'Books' ? 'Back To Books' : 'Back To Tools';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: InkWell(
                      onTap: () => context.pop(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_back_ios_new, size: 18),
                          const SizedBox(width: 4),
                          Text(backLabel),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 16, 28, 43),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ResourceImage(
                        path: resource.imagePath,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resource.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 22, 36, 53),
                          ),
                        ),
                        const SizedBox(height: 18),
                        OwnerInfoTile(
                          title: 'Owned by',
                          value: resource.ownerName,
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 10),
                        OwnerInfoTile(
                          title: 'Location',
                          value: resource.location.isNotEmpty
                              ? resource.location
                              : 'Nearby',
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          resource.description,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 81, 97, 115),
                            height: 1.45,
                          ),
                        ),
                        if (resource.condition.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 233, 248),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Item Condition and Usage',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text('• ${resource.condition}'),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        if (currentUser?.id == resource.ownerId) ...[
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                  ),
                                  onPressed: () => context.push('/edit-resource/${resource.id}'),
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('Edit'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                  ),
                                  onPressed: () => _deleteResource(context, ref, resource.id),
                                  icon: const Icon(Icons.delete, size: 18),
                                  label: const Text('Delete'),
                                ),
                              ),
                            ],
                          ),
                          ] else ...[
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 25, 130, 209),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                  ),
                                  onPressed: () => _startReservation(
                                    context,
                                    ref,
                                    resource.title,
                                  ),
                                  child: const Text('Reserve Now'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 23, 166, 67),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                  ),
                                  onPressed: () => _requestBorrow(
                                    context,
                                    ref,
                                    resource.title,
                                    resource.ownerId,
                                    resource.ownerName,
                                  ),
                                  child: const Text('Request to Borrow'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
