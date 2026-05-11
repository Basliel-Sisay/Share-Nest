import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../widgets/resource_card.dart';

class BrowseResourcesScreen extends StatelessWidget {
  const BrowseResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopSection(),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  _SearchField(),
                  SizedBox(height: 16),
                  _CategoryList(),
                  SizedBox(height: 24),

                  ResourceCard(
                    title: 'Woodworking Kit',
                    ownerName: 'Abrham Tesfaye',
                    distance: '200m',
                    rating: 4.9,
                    category: 'Tools',
                    description:
                        'Woodworking kits, all-in-one sets that provide the essential tools and materials needed to craft, build, or repair wooden projects with ease',
                  ),

                  ResourceCard(
                    title: 'English Text Book',
                    ownerName: 'Sarah Kinde',
                    distance: '1.2km',
                    rating: 5.0,
                    category: 'Books',
                    description:
                        'Grade 11 English Textbook for Ethiopian students.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(
        currentIndex: 1,
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('ShareNest'),
      leading: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(Icons.eco),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.help_outline),
        ),
      ],
    );
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 24,
      ),
      color: AppColors.primaryGreen,
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

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
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
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          _CategoryChip(
            title: 'All Resources',
            selected: true,
          ),
          SizedBox(width: 8),
          _CategoryChip(
            title: 'Tools',
          ),
          SizedBox(width: 8),
          _CategoryChip(
            title: 'Books',
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String title;
  final bool selected;

  const _CategoryChip({
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primaryGreen
            : AppColors.cardBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: selected
              ? Colors.white
              : AppColors.textDark,
          fontWeight:
              selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}