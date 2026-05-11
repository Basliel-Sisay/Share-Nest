import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../widgets/home_item_card.dart';
import '../widgets/home_search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 12, 143, 58),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'NEST  🌿',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Text(
                      'ShareNest',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'What do you need for your today?',
                style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 45, 55, 66)),
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
                    onPressed: () {
                      context.go('/item');
                    },
                    child: const Text('View all →'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              HomeItemCard(
                title: 'Power Drill',
                owner: 'Mike R.',
                distance: '0.8 miles',
                status: 'Available Today',
                actionText: 'Request Loan',
                imagePath: 'assets/images/drill.png',
                onTap: () => context.push('/item'),
              ),
              const SizedBox(height: 16),
              HomeItemCard(
                title: 'Python Programming',
                owner: 'Sarah W.',
                distance: '1.2 miles',
                status: 'Free from Mar 15',
                actionText: 'Pre-book',
                imagePath: 'assets/images/python_book.png',
                isActionPrimary: false,
                onTap: () {
                  context.push('/item');
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 14, right: 12),
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 12, 143, 58),
          onPressed: () {
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      bottomNavigationBar: Container(
        height: 74,
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 215, 238, 219),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const _HomeNavItem(icon: Icons.home, label: 'HOME', isActive: true),
            GestureDetector(
              onTap: () {
                context.go('/');
              },
              child: const _HomeNavItem(icon: Icons.search, label: 'BROWSE'),
            ),
            GestureDetector(
              onTap: () {
              },
              child: const _HomeNavItem(
                  icon: Icons.add_circle_outline, label: 'ADD'),
            ),
            GestureDetector(
              onTap: () => context.go('/loans'),
              child: const _HomeNavItem(
                  icon: Icons.layers_outlined, label: 'LOANS'),
            ),
            GestureDetector(
              onTap: () {
                context.go('/profile');
              },
              child: const _HomeNavItem(
                  icon: Icons.person_outline, label: 'PROFILE'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color.fromARGB(255, 11, 141, 57) : const Color.fromARGB(255, 96, 112, 129);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 19),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
