/// Domain entity for a shareable resource/item.
class Item {
  final String id;
  final String title;
  final String description;
  final String category;
  final String ownerId;
  final String ownerName;
  final String? distance;
  final double? rating;
  final String? status;
  final String? imagePath;

  const Item({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.ownerId,
    required this.ownerName,
    this.distance,
    this.rating,
    this.status,
    this.imagePath,
  });
}
