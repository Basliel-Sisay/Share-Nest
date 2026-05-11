import 'package:flutter/material.dart';

class HomeItemCard extends StatelessWidget {
  const HomeItemCard({
    super.key,
    required this.title,
    required this.owner,
    required this.distance,
    required this.status,
    required this.actionText,
    required this.imagePath,
    this.isActionPrimary = true,
    required this.onTap,
  });

  final String title;
  final String owner;
  final String distance;
  final String status;
  final String actionText;
  final String imagePath;
  final bool isActionPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 233, 242),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                height: 118,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 21, 34, 51),
              ),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const CircleAvatar(
                  radius: 9,
                  backgroundColor: Color.fromARGB(255, 122, 199, 94),
                  child: Icon(Icons.person, size: 12, color: Color.fromARGB(255, 19, 67, 27)),
                ),
                const SizedBox(width: 6),
                Text(
                  '$owner  •  $distance away',
                  style:
                      const TextStyle(fontSize: 12, color: Color.fromARGB(255, 91, 102, 115)),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                Icon(
                  isActionPrimary
                      ? Icons.check_circle_outline
                      : Icons.event_available,
                  size: 16,
                  color: const Color.fromARGB(255, 29, 158, 79),
                ),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 29, 158, 79),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActionPrimary
                    ? const Color.fromARGB(255, 69, 179, 83)
                    : const Color.fromARGB(255, 198, 218, 243),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                actionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActionPrimary
                      ? const Color.fromARGB(255, 12, 42, 15)
                      : const Color.fromARGB(255, 35, 71, 110),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
