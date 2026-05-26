import 'package:flutter/material.dart';

class OwnerInfoTile extends StatelessWidget {
  const OwnerInfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: const Color.fromARGB(255, 230, 234, 238),
          child: Icon(icon, size: 14, color: const Color.fromARGB(255, 87, 99, 114)),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                color: Color.fromARGB(255, 120, 131, 146),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 30, 44, 58),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
