import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFD8EAFE),
        borderRadius: BorderRadius.circular(27),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Color(0xFF2E475E)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Search for tools, books...',
              style: TextStyle(
                color: Color(0xFF6A7A89),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFF14883E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Explore',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
