import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'HOME',
                isActive: currentIndex == 0,
                onTap: () {
                  if (currentIndex != 0) context.go('/home');
                },
                ),
                _buildNavItem(
                icon: Icons.search,
                label: 'BROWSE',
                isActive: currentIndex == 1,
                onTap: () {
                  if (currentIndex != 1) context.go('/browse');
                },
                ),
                _buildAddButton(context),
                _buildNavItem(
                icon: Icons.handshake_outlined,
                label: 'LOANS',
                isActive: currentIndex == 3,
                onTap: () {
                  if (currentIndex != 3) context.go('/loans');
                },
                ),
                _buildNavItem(
                icon: Icons.person_outline,
                label: 'PROFILE',
                isActive: currentIndex == 4,
                onTap: () {
                  if (currentIndex != 4) context.go('/profile');
                },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primaryGreen : AppColors.textGrey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppColors.primaryGreen : AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (currentIndex != 2) context.go('/add');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: currentIndex == 2 ? AppColors.primaryGreen : AppColors.lightGreen,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: currentIndex == 2 ? Colors.white : AppColors.primaryGreen,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              'ADD',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: currentIndex == 2 ? Colors.white : AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
