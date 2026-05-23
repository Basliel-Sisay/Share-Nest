import '../models/loan_item.dart';
import '../models/reservation_item.dart';
import '../models/resource_item.dart';

class SeedData {
  static List<ResourceItem> resources() => [
        const ResourceItem(
          id: 'power-drill',
          title: 'Power Drill',
          ownerId: '',
          ownerName: 'Mike R.',
          distance: '0.8 miles',
          rating: 4.8,
          category: 'Tools',
          description:
              'Compact Drill, built for everyday wall drilling and light home projects. Solid condition with reliable power and steady performance.',
          imagePath: 'assets/images/drill.png',
          location: 'Jemo, Mekanissa',
          condition:
              'Includes 2 rechargeable batteries. Charger and carrying case included.',
          statusText: 'Available Today',
        ),
        const ResourceItem(
          id: 'python-programming',
          title: 'Python Programming',
          ownerId: '',
          ownerName: 'Sarah W.',
          distance: '1.2 miles',
          rating: 4.9,
          category: 'Books',
          description:
              'Comprehensive Python programming guide covering fundamentals, data structures, and practical projects for beginners and intermediates.',
          imagePath: 'assets/images/python_book.png',
          location: 'Bole, Addis Ababa',
          condition: 'Gently used, no missing pages.',
          statusText: 'Free from Mar 15',
        ),
        const ResourceItem(
          id: 'woodworking-kit',
          title: 'Woodworking Kit',
          ownerId: '',
          ownerName: 'Abrham Tesfaye',
          distance: '200m',
          rating: 4.9,
          category: 'Tools',
          description:
              'Woodworking kits, all-in-one sets that provide the essential tools and materials needed to craft, build, or repair wooden projects with ease',
          imagePath: 'assets/images/drill.png',
          location: 'Mekanissa',
          condition: 'Good condition',
        ),
        const ResourceItem(
          id: 'english-textbook',
          title: 'English Text Book',
          ownerId: '',
          ownerName: 'Sarah Kinde',
          distance: '1.2km',
          rating: 5.0,
          category: 'Books',
          description: 'Grade 11 English Textbook for Ethiopian students.',
          imagePath: 'assets/images/python_book.png',
          location: 'Jemo',
          condition: 'Like new',
        ),
        const ResourceItem(
          id: 'event-chairs',
          title: 'Event Chairs (Set of 10)',
          ownerId: '',
          ownerName: 'Community Hub',
          distance: '0.8 Km',
          rating: 4.7,
          category: 'Tools',
          description: 'Set of 10 folding event chairs for parties and gatherings.',
          imagePath: 'assets/images/drill.png',
          location: 'Jemo 1',
          statusText: 'CONFIRMED',
        ),
      ];

  static List<LoanItem> loans() {
    final dueSoon = DateTime.now().add(const Duration(days: 2));
    final activeReturn = DateTime.now().add(const Duration(days: 4));
    final now = DateTime.now();
    return [
      LoanItem(
        id: 'loan-1',
        resourceId: 'power-drill',
        title: 'DeWalt Power Drill',
        ownerId: 'owner-1',
        ownerName: 'Sarah Yabets',
        borrowerId: 'user-1',
        borrowerName: 'You',
        statusText: 'DUE IN 2 DAYS',
        dateText: 'Return by ${_formatDate(dueSoon)}, 6:00 PM',
        pickupDate: now,
        returnDate: dueSoon,
        pickupTime: '10:00 AM',
        returnTime: '6:00 PM',
        statusColorArgb: 0xFF4CAF50,
        statusTextColorArgb: 0xFFFFFFFF,
      ),
      LoanItem(
        id: 'loan-2',
        resourceId: 'woodworking-kit',
        title: '4 Person Camping Tent',
        ownerId: 'owner-2',
        ownerName: 'Kirubel Awoke',
        borrowerId: 'user-1',
        borrowerName: 'You',
        statusText: 'ACTIVE',
        dateText: 'Borrowed for 4 more days',
        pickupDate: now,
        returnDate: activeReturn,
        pickupTime: '10:00 AM',
        returnTime: '6:00 PM',
        statusColorArgb: 0xFFDDE8FC,
        statusTextColorArgb: 0xFF1E8449,
      ),
    ];
  }

  static List<ReservationItem> reservations() {
    return [
      ReservationItem(
        id: 'res-1',
        resourceId: 'event-chairs',
        title: 'Event Chairs (Set of 10)',
        ownerId: 'owner-1',
        borrowerId: 'user-1',
        pickupLocation: 'Pickup from Jemo 1',
        pickupDate: DateTime(2026, 7, 12),
        returnDate: DateTime(2026, 7, 14),
        pickupTime: '10:00 AM',
        returnTime: '04:00 PM',
      ),
    ];
  }

  static String _formatDate(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}
