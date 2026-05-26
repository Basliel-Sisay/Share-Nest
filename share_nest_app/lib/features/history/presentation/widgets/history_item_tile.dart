import 'package:flutter/material.dart';
import '../../../../core/widgets/resource_image.dart';

class HistoryItemTile extends StatelessWidget {
  const HistoryItemTile({
    super.key,
    required this.itemName,
    required this.borrower,
    required this.period,
    required this.stateLabel,
    required this.stateColor,
    this.imagePath,
  });

  final String itemName;
  final String borrower;
  final String period;
  final String stateLabel;
  final Color stateColor;
  final String? imagePath;

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
            child: imagePath != null
                ? ResourceImage(
                    path: imagePath!,
                    height: 60,
                    width: 72,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 60,
                    width: 72,
                    color: const Color.fromRGBO(238, 238, 238, 1),
                    child: const Icon(
                      Icons.inventory_2,
                      color: Color.fromRGBO(158, 158, 158, 1),
                    ),
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
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(22, 36, 52, 1),
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
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(20, 51, 32, 1),
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
                      backgroundColor: Color.fromRGBO(228, 234, 241, 1),
                      child: Icon(
                        Icons.person,
                        size: 11,
                        color: Color.fromRGBO(84, 98, 115, 1),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Lent to $borrower',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromRGBO(78, 89, 103, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  period,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(91, 103, 116, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color.fromRGBO(17, 125, 55, 1),
          ),
        ],
      ),
    );
  }
}
