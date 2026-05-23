import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../../../../core/widgets/resource_image.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourceAsync = ref.watch(resourceByIdProvider(resourceId));

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
                                  'Item Condition & Usage',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text('• ${resource.condition}'),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
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
                                onPressed: () => _startReservation(
                                  context,
                                  ref,
                                  resource.title,
                                ),
                                child: const Text('Request to Borrow'),
                              ),
                            ),
                          ],
                        ),
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
