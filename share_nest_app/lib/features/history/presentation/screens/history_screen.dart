import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/history_item_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 21, 125, 58),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Sharing History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'ShareNest',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Your Impact',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 22, 36, 52),
                ),
              ),
              SizedBox(height: 18),
              Text(
                'RECENT CHANGES',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 73, 83, 95),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              HistoryItemTile(
                itemName: 'Power Drill',
                borrower: 'Elias Debalke',
                period: 'APR 12 - APR 14, 2026',
                stateLabel: 'RETURNED',
                stateColor: Color.fromARGB(255, 80, 190, 98),
                imagePath: 'assets/images/drill.png',
              ),
              HistoryItemTile(
                itemName: '6-Step Ladder',
                borrower: 'Haymanot Samson',
                period: 'DUE BACK TOMORROW',
                stateLabel: 'IN USE',
                stateColor: Color.fromARGB(255, 184, 217, 247),
                imagePath: 'assets/images/ladder.png',
              ),
              HistoryItemTile(
                itemName: '4-Person Tent',
                borrower: 'Kirubel Awoke',
                period: 'MAR 24 - MAR 28, 2026',
                stateLabel: 'ARCHIVED',
                stateColor: Color.fromARGB(255, 212, 224, 239),
                imagePath: 'assets/images/tent.png',
              ),
              HistoryItemTile(
                itemName: 'Juice Extractor',
                borrower: 'Elias Debalke',
                period: 'FEB 15 - FEB 16, 2023',
                stateLabel: 'RETURNED',
                stateColor: Color.fromARGB(255, 80, 190, 98),
                imagePath: 'assets/images/juice_extractor.png',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 74,
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 206, 206, 206),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => context.go('/home'),
              child: const _HistoryNavItem(
                  icon: Icons.home_outlined, label: 'HOME'),
            ),
            const _HistoryNavItem(
              icon: Icons.history,
              label: 'HISTORY',
              isActive: true,
            ),
            GestureDetector(
              onTap: () {},
              child: const _HistoryNavItem(
                  icon: Icons.help_outline, label: 'HELP'),
            ),
            GestureDetector(
              onTap: () => context.go('/settings'),
              child: const _HistoryNavItem(
                  icon: Icons.settings, label: 'SETTINGS'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryNavItem extends StatelessWidget {
  const _HistoryNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 188, 232, 200),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 29, 121, 64), size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color.fromARGB(255, 29, 121, 64),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color.fromARGB(255, 98, 114, 130), size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(255, 98, 114, 130),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
