class ResourceItem {
  const ResourceItem({
    required this.id,
    required this.title,
    required this.ownerName,
    required this.distance,
    required this.rating,
    required this.category,
    required this.description,
    required this.imagePath,
    this.location = '',
    this.condition = '',
    this.statusText = 'Available Today',
    this.isAvailable = true,
  });

  final String id;
  final String title;
  final String ownerName;
  final String distance;
  final double rating;
  final String category;
  final String description;
  final String imagePath;
  final String location;
  final String condition;
  final String statusText;
  final bool isAvailable;

  ResourceItem copyWith({
    String? id,
    String? title,
    String? ownerName,
    String? distance,
    double? rating,
    String? category,
    String? description,
    String? imagePath,
    String? location,
    String? condition,
    String? statusText,
    bool? isAvailable,
  }) {
    return ResourceItem(
      id: id ?? this.id,
      title: title ?? this.title,
      ownerName: ownerName ?? this.ownerName,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      location: location ?? this.location,
      condition: condition ?? this.condition,
      statusText: statusText ?? this.statusText,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'owner_name': ownerName,
        'distance': distance,
        'rating': rating,
        'category': category,
        'description': description,
        'image_path': imagePath,
        'location': location,
        'condition': condition,
        'status_text': statusText,
        'is_available': isAvailable ? 1 : 0,
      };

  factory ResourceItem.fromMap(Map<String, dynamic> map) {
    return ResourceItem(
      id: map['id'] as String,
      title: map['title'] as String,
      ownerName: map['owner_name'] as String,
      distance: map['distance'] as String,
      rating: (map['rating'] as num).toDouble(),
      category: map['category'] as String,
      description: map['description'] as String,
      imagePath: map['image_path'] as String,
      location: (map['location'] as String?) ?? '',
      condition: (map['condition'] as String?) ?? '',
      statusText: (map['status_text'] as String?) ?? 'Available Today',
      isAvailable: (map['is_available'] as int? ?? 1) == 1,
    );
  }
}
