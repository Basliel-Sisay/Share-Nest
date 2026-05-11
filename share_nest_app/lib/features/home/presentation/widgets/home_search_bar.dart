import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 234, 254),
        borderRadius: BorderRadius.circular(27),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Color.fromARGB(255, 46, 71, 94)),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Search for tools, books...',
              style: TextStyle(
                color: Color.fromARGB(255, 106, 122, 137),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 136, 62),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Explore',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
