import 'package:flutter/material.dart';

void showReservationModal({
  required BuildContext context,
  required String title,
  required String? imagePath,
  required String date,
  required String time,
  required VoidCallback onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ReservationConfirmationModal(
      title: title,
      imagePath: imagePath,
      date: date,
      time: time,
      onConfirm: onConfirm,
    ),
  );
}

class ReservationConfirmationModal extends StatelessWidget {
  final String title;
  final String? imagePath;
  final String date;
  final String time;
  final VoidCallback onConfirm;

  const ReservationConfirmationModal({
    Key? key,
    required this.title,
    this.imagePath,
    required this.date,
    required this.time,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 244, 246, 248),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirm Reservation',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 38, 50, 56),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 94, 138, 99),
                    borderRadius: BorderRadius.circular(16),
                    image: imagePath != null
                        ? DecorationImage(
                            image: imagePath!.startsWith('http')
                                ? NetworkImage(imagePath!)
                                : AssetImage(imagePath!) as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1592417817098-8f3d6eb18865?q=80&w=600&auto=format&fit=crop',
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 208, 226, 255),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'PREMIUM TOOL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 0, 67, 206),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'SELECT DATE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.grey,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 216, 231, 250),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Color.fromARGB(255, 46, 107, 64), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 26, 37, 44),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.calendar_month, color: Color.fromARGB(255, 26, 37, 44), size: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'PICK TIME',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.grey,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 216, 231, 250),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Color.fromARGB(255, 46, 107, 64), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 26, 37, 44),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 26, 37, 44)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 130, 52),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
                shadowColor: const Color.fromARGB(102, 30, 130, 52),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Confirm Reservation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'CANCELLATION AVAILABLE UP TO 2 HOURS\nBEFORE START',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: 0.5,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
