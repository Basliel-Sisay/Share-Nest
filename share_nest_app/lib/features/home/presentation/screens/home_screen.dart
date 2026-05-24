import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/app_providers.dart';
import '../widgets/home_item_card.dart';
import '../widgets/home_search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _openReservation(
    BuildContext context,
    WidgetRef ref, {
    required String resourceId,
    required String title,
  }) {
    ref.read(reservationDraftProvider.notifier).setDraft(
          ReservationDraft(
            resourceId: resourceId,
            resourceTitle: title,
          ),
        );
    context.push('/reservation');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(resourcesProvider);
    final searchQuery = ref.watch(homeSearchProvider);
    // Define the required order of resource IDs
    const requiredOrder = [
      'woodworking-kit',
      'python-programming',
      'power-drill',
      'english-textbook',
      'book-of-daniel',
      'camping-tent',
      'step-ladder',
      'book-of-moses',
      'kitchen-kits',
      'plastic-chairs',
    ];

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
                Icon(
                  Icons.eco,
                  color: Colors.black,
                  size: 26,
                ),
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
      body: SafeArea(
        child: resourcesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (allResources) {
            final featured = filterResources(
              allResources,
              query: searchQuery,
              category: 'All Resources',
              availableOnly: true,
            );

            final nearYou = featured.isNotEmpty
                ? featured
                : allResources.where((r) => r.isAvailable).toList();

            // Sort nearYou by requiredOrder
            final sortedNearYou = [
              for (final id in requiredOrder)
                ...nearYou.where((r) => r.id == id)
            ];

            if (sortedNearYou.isEmpty) {
              return const Center(child: Text('No resources available yet'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'What do you need for your today?',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 45, 55, 66),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const HomeSearchBar(),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Available Near You',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 21, 34, 51),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/browse'),
                        child: const Text('View all →'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...sortedNearYou.map((resource) {
                    final isPrimary = resource.category == 'Tools';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: HomeItemCard(
                        title: resource.title,
                        owner: resource.ownerName,
                        distance: resource.distance,
                        status: resource.statusText,
                        actionText: isPrimary ? 'Request Loan' : 'Pre-book',
                        imagePath: resource.imagePath,
                        isActionPrimary: isPrimary,
                        onTap: () => context.push('/item/${resource.id}'),
                        onActionTap: () {
                          if (isPrimary) {
                            _openReservation(
                              context,
                              ref,
                              resourceId: resource.id,
                              title: resource.title,
                            );
                          } else {
                            context.push('/item/${resource.id}');
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
