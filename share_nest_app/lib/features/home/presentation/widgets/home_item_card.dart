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
          color: const Color(0xFFE4E9F2),
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
                fontSize: 29 / 2,
                fontWeight: FontWeight.w800,
                color: Color(0xFF152233),
              ),
            ),
            const SizedBox(height: 7),
            Row(
              children: [
                const CircleAvatar(
                  radius: 9,
                  backgroundColor: Color(0xFF7AC75E),
                  child: Icon(Icons.person, size: 12, color: Color(0xFF13431B)),
                ),
                const SizedBox(width: 6),
                Text(
                  '$owner  •  $distance away',
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF5B6673)),
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
                  color: const Color(0xFF1D9E4F),
                ),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D9E4F),
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
                    ? const Color(0xFF45B353)
                    : const Color(0xFFC6DAF3),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                actionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActionPrimary
                      ? const Color(0xFF0C2A0F)
                      : const Color(0xFF23476E),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
