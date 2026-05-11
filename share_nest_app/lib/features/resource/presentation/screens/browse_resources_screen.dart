import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../widgets/resource_card.dart';

class BrowseResourcesScreen extends StatelessWidget {
  const BrowseResourcesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShareNest'),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.eco),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.primaryGreen,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            width: double.infinity,
            child: const Text(
              'Explore Resources',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'What do you need today?',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
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
                        _buildCategoryChip('All Resources', isSelected: true),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Tools'),
                        const SizedBox(width: 8),
                        _buildCategoryChip('Books'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const ResourceCard(
                    title: 'Woodworking Kit',
                    ownerName: 'Abrham Tesfaye',
                    distance: '200m',
                    rating: 4.9,
                    category: 'Tools',
                    description: 'Woodworking kits, all-in-one sets that provide the essential tools and materials needed to craft, build, or repair wooden projects with ease',
                  ),
                  const ResourceCard(
                    title: 'English Text Book',
                    ownerName: 'Sarah Kinde',
                    distance: '1.2km',
                    rating: 5.0,
                    category: 'Books',
                    description: 'Grade 11 English Textbook for Ethiopian students.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryGreen : AppColors.cardBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
