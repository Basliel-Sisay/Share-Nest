/// Data Transfer Object for items (API JSON and SQLite rows).
class ItemDto {
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
  final String? cachedAt;

  const ItemDto({
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
    this.cachedAt,
  });

  factory ItemDto.fromJson(Map<String, dynamic> json) {
    return ItemDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      distance: json['distance'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      status: json['status'] as String?,
      imagePath: json['imagePath'] as String?,
    );
  }

  factory ItemDto.fromDb(Map<String, dynamic> map) {
    return ItemDto(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      ownerId: map['ownerId'] as String,
      ownerName: map['ownerName'] as String,
      distance: map['distance'] as String?,
      rating: (map['rating'] as num?)?.toDouble(),
      status: map['status'] as String?,
      imagePath: map['imagePath'] as String?,
      cachedAt: map['cachedAt'] as String?,
    );
  }

  Map<String, dynamic> toDb({required DateTime cachedAt}) {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'distance': distance,
      'rating': rating,
      'status': status,
      'imagePath': imagePath,
      'cachedAt': cachedAt.toIso8601String(),
    };
  }
}
