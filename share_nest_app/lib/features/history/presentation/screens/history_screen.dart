import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/../../core/routing/app_router.dart'; // Adjust this import path to where your AppRouter is
import '../widgets/history_item_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF157D3A),
        leading: IconButton(
          onPressed: () => context
              .go(AppRouter.homePath), // Changed from HomeRoutes.homePath
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Sharing History',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'ShareNest',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28 / 2),
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
                  fontSize: 52 / 2,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF162434),
                ),
              ),
              SizedBox(height: 18),
              Text(
                'RECENT CHANGES',
                style: TextStyle(
                  fontSize: 36 / 2,
                  color: Color(0xFF49535F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              HistoryItemTile(
                itemName: 'Power Drill',
                borrower: 'Elias Debalke',
                period: 'APR 12 - APR 14, 2026',
                stateLabel: 'RETURNED',
                stateColor: Color(0xFF50BE62),
                imagePath: 'assets/images/drill.png',
              ),
              HistoryItemTile(
                itemName: '6-Step Ladder',
                borrower: 'Haymanot Samson',
                period: 'DUE BACK TOMORROW',
                stateLabel: 'IN USE',
                stateColor: Color(0xFFB8D9F7),
                imagePath: 'assets/images/ladder.png',
              ),
              HistoryItemTile(
                itemName: '4-Person Tent',
                borrower: 'Kirubel Awoke',
                period: 'MAR 24 - MAR 28, 2026',
                stateLabel: 'ARCHIVED',
                stateColor: Color(0xFFD4E0EF),
                imagePath: 'assets/images/tent.png',
              ),
              HistoryItemTile(
                itemName: 'Juice Extractor',
                borrower: 'Elias Debalke',
                period: 'FEB 15 - FEB 16, 2023',
                stateLabel: 'RETURNED',
                stateColor: Color(0xFF50BE62),
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
          color: const Color(0xFFCECECE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => context
                  .go(AppRouter.homePath), // Changed from HomeRoutes.homePath
              child: const _HistoryNavItem(
                  icon: Icons.home_outlined, label: 'HOME'),
            ),
            const _HistoryNavItem(
              icon: Icons.history,
              label: 'HISTORY',
              isActive: true,
            ),
            GestureDetector(
              onTap: () => context
                  .go(AppRouter.historyPath), // Added navigation for Help
              child: const _HistoryNavItem(
                  icon: Icons.help_outline, label: 'HELP'),
            ),
            GestureDetector(
              onTap: () => context
                  .go(AppRouter.historyPath), // Added navigation for Settings
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
          color: const Color(0xFFBCE8C8),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1D7940), size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1D7940),
                fontWeight: FontWeight.w700,
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
        Icon(icon, color: const Color(0xFF627282), size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF627282),
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
