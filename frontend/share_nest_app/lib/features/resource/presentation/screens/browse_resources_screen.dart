import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/app_providers.dart';
import '../widgets/resource_card.dart';

class BrowseResourcesScreen extends ConsumerStatefulWidget {
  const BrowseResourcesScreen({super.key});

  @override
  ConsumerState<BrowseResourcesScreen> createState() =>
      _BrowseResourcesScreenState();
}

class _BrowseResourcesScreenState extends ConsumerState<BrowseResourcesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openReservation(String resourceId, String title, String imagePath) {
    ref.read(reservationDraftProvider.notifier).setDraft(
          ReservationDraft(
            resourceId: resourceId,
            resourceTitle: title,
            imagePath: imagePath,
          ),
        );
    context.push('/reservation');
  }

  @override
  Widget build(BuildContext context) {
    final resourcesAsync = ref.watch(resourcesProvider);
    final searchQuery = ref.watch(browseSearchProvider);
    final category = ref.watch(browseCategoryProvider);

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSection(),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: resourcesAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (all) {
                  final filtered = filterResources(
                    all,
                    query: searchQuery,
                    category: category,
                    availableOnly: false,
                  );

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (v) => ref
                            .read(browseSearchProvider.notifier)
                            .setQuery(v),
                        decoration: InputDecoration(
                          hintText: 'What do you need today?',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.textGrey,
                          ),
                          filled: true,
                          fillColor: AppColors.cardBlue,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _CategoryChip(
                              title: 'All Resources',
                              selected: category == 'All Resources',
                              onTap: () => ref
                                  .read(browseCategoryProvider.notifier)
                                  .setCategory('All Resources'),
                            ),
                            const SizedBox(width: 8),
                            _CategoryChip(
                              title: 'Tools',
                              selected: category == 'Tools',
                              onTap: () => ref
                                  .read(browseCategoryProvider.notifier)
                                  .setCategory('Tools'),
                            ),
                            const SizedBox(width: 8),
                            _CategoryChip(
                              title: 'Books',
                              selected: category == 'Books',
                              onTap: () => ref
                                  .read(browseCategoryProvider.notifier)
                                  .setCategory('Books'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              'No resources match your search.',
                              style: TextStyle(color: AppColors.textGrey),
                            ),
                          ),
                        )
                      else
                        ...filtered.map(
                          (r) => ResourceCard(
                            title: r.title,
                            ownerName: r.ownerName,
                            distance: r.distance,
                            rating: r.rating,
                            category: r.category,
                            description: r.description,
                            imagePath: r.imagePath,
                            onTap: () => context.push('/item/${r.id}'),
                            onRequestLoan: () =>
                                _openReservation(r.id, r.title, r.imagePath),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      color: Colors.green,
      child: const Text(
        'Explore Resources',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : AppColors.cardBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textDark,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
