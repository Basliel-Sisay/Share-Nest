import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav.dart';
import '../widgets/loan_item_card.dart';

class MyLoanScreen extends StatelessWidget {
  const MyLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShareNest'),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.eco),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.primaryGreen,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Activity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Track your current shares and upcoming bookings',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Tab Buttons (Loans / Reservations)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBlue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Center(
                              child: Text(
                                'Loans',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Reservations',
                              style: TextStyle(
                                color: AppColors.textGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Active Loans
                  const LoanItemCard(
                    title: 'DeWalt Power Drill',
                    ownerName: 'Sarah Yabets',
                    statusText: 'DUE IN 2 DAYS',
                    statusColor: Colors.green, // Adjust to exact green
                    statusTextColor: Colors.white,
                    dateText: 'Return by June 24, 6:00 PM',
                    isUpcoming: false,
                    buttonText: 'Message Sarah',
                  ),
                  const LoanItemCard(
                    title: '4 Person Camping Tent',
                    ownerName: 'Kirubel Awoke',
                    statusText: 'ACTIVE',
                    statusColor: AppColors.cardBlue,
                    statusTextColor: AppColors.primaryGreen,
                    dateText: 'Borrowed for 4 more days',
                    isUpcoming: false,
                    buttonText: 'Extend Loan',
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Upcoming Reservations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Upcoming Reservation Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.chair_alt_outlined, color: AppColors.textGrey, size: 40),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Event Chairs (Set of 10)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'CONFIRMED',
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Pickup from Jemo 1',
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.darkGreen),
                            SizedBox(width: 4),
                            Text('July 12 - July 14', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                            SizedBox(width: 12),
                            Icon(Icons.location_on_outlined, size: 14, color: AppColors.darkGreen),
                            SizedBox(width: 4),
                            Text('0.8 Km away', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('View Details'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
    );
  }
}
