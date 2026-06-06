import 'package:flutter_test/flutter_test.dart';
import 'package:share_nest_app/data/models/resource_item.dart';
import 'package:share_nest_app/data/models/reservation_item.dart';
import 'package:share_nest_app/data/models/loan_item.dart';
import 'package:share_nest_app/features/auth/data/models/user_model.dart';

void main() {
  group('Model Serialization Tests', () {
    test('UserModel serialization', () {
      final user = UserModel(
        id: 'user-1',
        name: 'Test User',
        email: 'test@example.com',
        role: 'user',
        token: 'token-123',
        imagePath: 'path/to/image.png',
      );

      final map = user.toMap();
      expect(map['id'], 'user-1');
      expect(map['name'], 'Test User');

      final fromMap = UserModel.fromMap(map);
      expect(fromMap.id, user.id);
      expect(fromMap.name, user.name);
      expect(fromMap.token, user.token);
    });

    test('ResourceItem serialization', () {
      final resource = ResourceItem(
        id: 'res-1',
        title: 'Drill',
        ownerId: 'owner-1',
        ownerName: 'Owner',
        distance: '1km',
        rating: 4.5,
        category: 'Tools',
        description: 'Power drill',
        imagePath: 'assets/drill.png',
      );

      final map = resource.toMap();
      expect(map['id'], 'res-1');
      expect(map['is_available'], 1);

      final fromMap = ResourceItem.fromMap(map);
      expect(fromMap.id, resource.id);
      expect(fromMap.isAvailable, true);
    });
    test('ReservationItem serialization', () {
      final now = DateTime.now();
      final reservation = ReservationItem(
        id: 'rev-1',
        resourceId: 'res-1',
        title: 'Drill',
        ownerId: 'owner-1',
        borrowerId: 'user-1',
        pickupLocation: 'Hub',
        pickupDate: now,
        returnDate: now.add(const Duration(days: 1)),
        pickupTime: '10:00 AM',
        returnTime: '11:00 AM',
      );

      final map = reservation.toMap();
      expect(map['id'], 'rev-1');

      final fromMap = ReservationItem.fromMap(map);
      expect(fromMap.id, reservation.id);
      expect(fromMap.pickupDate.day, reservation.pickupDate.day);
    });

    test('LoanItem serialization', () {
      final now = DateTime.now();
      final loan = LoanItem(
        id: 'loan-1',
        resourceId: 'res-1',
        title: 'Drill',
        ownerId: 'owner-1',
        ownerName: 'Owner',
        borrowerId: 'user-1',
        borrowerName: 'User',
        statusText: 'PENDING',
        dateText: 'Today',
        pickupDate: now,
        returnDate: now.add(const Duration(days: 1)),
        imagePath: 'assets/drill.png',
      );

      final map = loan.toMap();
      expect(map['id'], 'loan-1');

      final fromMap = LoanItem.fromMap(map);
      expect(fromMap.id, loan.id);
      expect(fromMap.statusText, 'PENDING');
    });
  });
}
