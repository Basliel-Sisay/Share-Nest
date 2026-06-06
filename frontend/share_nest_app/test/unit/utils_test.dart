import 'package:flutter_test/flutter_test.dart';
import 'package:share_nest_app/core/providers/app_providers.dart';
import 'package:share_nest_app/data/models/resource_item.dart';
void main() {
  group('Utility Function Tests', () {
    test('slugifyTitle handles normal strings', () {
      expect(slugifyTitle('Lawn Mower'), 'lawn-mower');
      expect(slugifyTitle('Kitchen Kit 2023'), 'kitchen-kit-2023');
    });

    test('slugifyTitle handles special characters', () {
      expect(slugifyTitle('Tool & Equipment!'), 'tool-equipment');
      expect(slugifyTitle('   Trimmed   '), 'trimmed');
    });

    test('filterResources filters by category', () {
      final items = [
        _mockResource(id: '1', title: 'A', category: 'Tools'),
        _mockResource(id: '2', title: 'B', category: 'Books'),
      ];

      final filtered = filterResources(items, query: '', category: 'Tools');
      expect(filtered.length, 1);
      expect(filtered.first.id, '1');
    });

    test('filterResources filters by query', () {
      final items = [
        _mockResource(id: '1', title: 'Lawn Mower', category: 'Tools'),
        _mockResource(id: '2', title: 'Drill', category: 'Tools'),
      ];

      final filtered = filterResources(items, query: 'drill', category: 'All Resources');
      expect(filtered.length, 1);
      expect(filtered.first.id, '2');
    });

    test('filterResources filters by availability', () {
      final items = [
        _mockResource(id: '1', title: 'A', isAvailable: true),
        _mockResource(id: '2', title: 'B', isAvailable: false),
      ];

      final filtered = filterResources(items, query: '', category: 'All Resources', availableOnly: true);
      expect(filtered.length, 1);
      expect(filtered.first.id, '1');
    });
  });
}
ResourceItem _mockResource({
  required String id,
  required String title,
  String category = 'Tools',
  bool isAvailable = true,
}) {
  return ResourceItem(
    id: id,
    title: title,
    ownerId: 'owner',
    ownerName: 'Owner',
    distance: '1km',
    rating: 5.0,
    category: category,
    description: 'Desc',
    imagePath: 'path',
    isAvailable: isAvailable,
  );
}
