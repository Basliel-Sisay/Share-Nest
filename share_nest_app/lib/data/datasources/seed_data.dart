import '../models/loan_item.dart';
import '../models/reservation_item.dart';
import '../models/resource_item.dart';

class SeedData {
  static int fromARGB(int a, int r, int g, int b) {
    return ((a & 255) << 24) | ((r & 255) << 16) | ((g & 255) << 8) | (b & 255);
  }

  static List<ResourceItem> resources() => [
        const ResourceItem(
          id: 'woodworking-kit',
          title: 'Working Wood Kit',
          ownerId: '',
          ownerName: 'Abrham Tesfaye',
          distance: '200m',
          rating: 4.9,
          category: 'Tools',
          description:
              'Woodworking kits, all-in-one sets that provide the essential tools and materials needed to craft, build, or repair wooden projects with ease',
          imagePath: 'assets/images/wood_kit.jpg',
          location: 'Mekanissa',
          condition: 'Good condition',
          statusText: 'Available Today',
        ),
        const ResourceItem(
          id: 'python-programming',
          title: 'Python Book',
          ownerId: '',
          ownerName: 'Sarah Wolde',
          distance: '1.2 miles',
          rating: 4.9,
          category: 'Books',
          description:
              'Comprehensive Python programming guide covering fundamentals, data structures and practical projects for beginners and intermediates',
          imagePath: 'assets/images/python_book.png',
          location: 'Bole, Addis Ababa',
          condition: 'Gently used, no missing pages',
          statusText: 'Free from Mar 15',
        ),
        const ResourceItem(
          id: 'power-drill',
          title: 'Power Drill',
          ownerId: '',
          ownerName: 'Tinsae Getaneh',
          distance: '0.8 miles',
          rating: 4.8,
          category: 'Tools',
          description:
              'Compact Drill, built for everyday wall drilling and light home projects. Solid condition with reliable power and steady performance',
          imagePath: 'assets/images/drill.png',
          location: 'Jemo, Mekanissa',
          condition:
              'Includes 2 rechargeable batteries. Charger and carrying case included',
          statusText: 'Available Today',
        ),
        const ResourceItem(
          id: 'english-textbook',
          title: 'English Book',
          ownerId: '',
          ownerName: 'Sarah Kinde',
          distance: '1.2km',
          rating: 5.0,
          category: 'Books',
          description: 'Grade 11 English Textbook for Ethiopian students',
          imagePath: 'assets/images/english.jpg',
          location: 'Jemo',
          condition: 'Like new',
          statusText: 'Available Today',
        ),
        const ResourceItem(
          id: 'book-of-daniel',
          title: 'Book of Daniel',
          ownerId: '',
          ownerName: 'Sarah Wolde',
          distance: '1.5 miles',
          rating: 4.9,
          category: 'Books',
          description: 'The Book of Daniel from the Bible, explore ancient prophecy',
          imagePath: 'assets/images/book_of_daniel.jpg',
          location: 'Bole, Addis Ababa',
          condition: 'Good condition',
          statusText: 'Available Today',
        ),
        const ResourceItem(
          id: 'camping-tent',
          title: 'Tent',
          ownerId: '',
          ownerName: 'Edlawit Sewasew',
          distance: '1.0km',
          rating: 4.8,
          category: 'Outdoor',
          description: 'Spacious 4 person tent for your next camping adventure',
          imagePath: 'assets/images/tent.png',
          location: 'Lafto',
          condition: 'Excellent condition',
          statusText: 'Available Today',
        ),
        const ResourceItem(
          id: 'step-ladder',
          title: 'Ladder',
          ownerId: '',
          ownerName: 'Malik Ahmed',
          distance: '1.4km',
          rating: 4.7,
          category: 'Tools',
          description: 'Sturdy aluminum step ladder for home maintenance',
          imagePath: 'assets/images/ladder.png',
          location: 'Garment',
          condition: 'Stable and clean',
          statusText: 'Available Today',
        ),
        const ResourceItem(
          id: 'book-of-moses',
          title: 'Book of Moses',
          ownerId: '',
          ownerName: 'Sarah Wolde',
          distance: '1.6 miles',
          rating: 4.8,
          category: 'Books',
          description: 'The Book of Moses, part of the Pearl of Great Price',
          imagePath: 'assets/images/book_of_moses.jpg',
          location: 'Bole, Addis Ababa',
          condition: 'Well preserved',
          statusText: 'Available Today',
        ),
        const ResourceItem(
          id: 'kitchen-kits',
          title: 'Kitchen Kits',
          ownerId: '',
          ownerName: 'Sarah Kinde',
          distance: '1.2km',
          rating: 5.0,
          category: 'Kitchen',
          description: 'A complete kitchen kits set for all your cooking needs',
          imagePath: 'assets/images/kitchen_kits.jpg',
          location: 'Ayat',
          condition: 'Excellent condition',
          statusText: 'Available Today',
        ),
        const ResourceItem(
          id: 'plastic-chairs',
          title: 'Plastic Chair',
          ownerId: '',
          ownerName: 'Community Hub',
          distance: '0.8 Km',
          rating: 4.7,
          category: 'Furniture',
          description: 'Stackable plastic chairs for events and gatherings',
          imagePath: 'assets/images/plastic_chairs.jpg',
          location: 'Jemo 1',
          condition: 'Clean and sturdy',
          statusText: 'Available Today',
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
        ownerName: 'Tinsae Getaneh',
        borrowerId: 'user-1',
        borrowerName: 'You',
        statusText: 'DUE IN 2 DAYS',
        dateText: 'Return by ${_formatDate(dueSoon)}, 6:00 PM',
        pickupDate: now,
        returnDate: dueSoon,
        pickupTime: '10:00 AM',
        returnTime: '6:00 PM',
        statusColorArgb: fromARGB(255, 76, 175, 80),
        statusTextColorArgb: fromARGB(255, 255, 255, 255),
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
        statusColorArgb: fromARGB(255, 221, 232, 252),
        statusTextColorArgb: fromARGB(255, 30, 132, 73),
      ),
    ];
  }

  static List<ReservationItem> reservations() {
    return [
      ReservationItem(
        id: 'res-1',
        resourceId: 'plastic-chairs',
        title: 'Plastic Chair',
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
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}
