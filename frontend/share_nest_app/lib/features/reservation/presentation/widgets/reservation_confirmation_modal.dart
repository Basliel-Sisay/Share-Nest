import 'package:flutter/material.dart';

void showReservationModal({
  required BuildContext context,
  required String title,
  required String? imagePath,
  required String date,
  required String time,
  required VoidCallback onConfirm,
  bool hasConflict = false,
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
      hasConflict: hasConflict,
    ),
  );
}

class ReservationConfirmationModal extends StatelessWidget {
  final String title;
  final String? imagePath;
  final String date;
  final String time;
  final VoidCallback onConfirm;
  final bool hasConflict;

  const ReservationConfirmationModal({
    Key? key,
    required this.title,
    this.imagePath,
    required this.date,
    required this.time,
    required this.onConfirm,
    this.hasConflict = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Max height constraint to prevent overflow on smaller screens
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 244, 246, 248),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
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
                        Text(
                          hasConflict ? 'Reservation Conflict' : 'Confirm Reservation',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 38, 50, 56),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
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
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    height: 150,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 208, 226, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'PREMIUM TOOL',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 0, 67, 206),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'SELECT DATE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 231, 250),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Color.fromARGB(255, 46, 107, 64), size: 18),
                    const SizedBox(width: 10),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 26, 37, 44),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_month, color: Color.fromARGB(255, 26, 37, 44), size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'PICK TIME',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 231, 250),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Color.fromARGB(255, 46, 107, 64), size: 18),
                    const SizedBox(width: 10),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 26, 37, 44),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 26, 37, 44), size: 18),
                  ],
                ),
              ),
              if (hasConflict) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 254, 241, 241),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromARGB(255, 253, 216, 216),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 249, 215, 215),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.warning_rounded,
                          color: Color.fromARGB(255, 176, 0, 32),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Conflict Warning',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 176, 0, 32),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Warning: This time slot is already reserved by another neighbor. Please choose an alternative morning or afternoon slot.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 140, 40, 40),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: hasConflict ? () => Navigator.pop(context) : onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 30, 130, 52),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hasConflict ? 'Select Alternative Time Slot' : 'Confirm Reservation',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'CANCELLATION AVAILABLE UP TO 2 HOURS\nBEFORE START',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
