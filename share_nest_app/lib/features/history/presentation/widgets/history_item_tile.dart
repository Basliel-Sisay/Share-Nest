import 'package:flutter/material.dart';

class HistoryItemTile extends StatelessWidget {
  const HistoryItemTile({
    super.key,
    required this.itemName,
    required this.borrower,
    required this.period,
    required this.stateLabel,
    required this.stateColor,
    required this.imagePath,
  });

  final String itemName;
  final String borrower;
  final String period;
  final String stateLabel;
  final Color stateColor;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset(
              imagePath,
              height: 60,
              width: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        itemName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF162434),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: stateColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        stateLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF143320),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 9,
                      backgroundColor: Color(0xFFE4EAF1),
                      child: Icon(
                        Icons.person,
                        size: 11,
                        color: Color(0xFF546273),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Lent to $borrower',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4E5967),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  period,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5B6774),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF117D37)),
        ],
      ),
    );
  }
}
