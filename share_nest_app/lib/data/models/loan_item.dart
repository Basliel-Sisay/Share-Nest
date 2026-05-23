class LoanItem {
  const LoanItem({
    required this.id,
    required this.resourceId,
    required this.title,
    required this.ownerName,
    required this.statusText,
    required this.dateText,
    required this.returnDate,
    this.statusColorArgb = 0xFF4CAF50,
    this.statusTextColorArgb = 0xFFFFFFFF,
  });

  final String id;
  final String resourceId;
  final String title;
  final String ownerName;
  final String statusText;
  final String dateText;
  final DateTime returnDate;
  final int statusColorArgb;
  final int statusTextColorArgb;

  LoanItem copyWith({
    String? dateText,
    DateTime? returnDate,
    String? statusText,
  }) {
    return LoanItem(
      id: id,
      resourceId: resourceId,
      title: title,
      ownerName: ownerName,
      statusText: statusText ?? this.statusText,
      dateText: dateText ?? this.dateText,
      returnDate: returnDate ?? this.returnDate,
      statusColorArgb: statusColorArgb,
      statusTextColorArgb: statusTextColorArgb,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'resource_id': resourceId,
        'title': title,
        'owner_name': ownerName,
        'status_text': statusText,
        'date_text': dateText,
        'return_date': returnDate.toIso8601String(),
        'status_color': statusColorArgb,
        'status_text_color': statusTextColorArgb,
      };

  factory LoanItem.fromMap(Map<String, dynamic> map) {
    return LoanItem(
      id: map['id'] as String,
      resourceId: map['resource_id'] as String,
      title: map['title'] as String,
      ownerName: map['owner_name'] as String,
      statusText: map['status_text'] as String,
      dateText: map['date_text'] as String,
      returnDate: DateTime.parse(map['return_date'] as String),
      statusColorArgb: map['status_color'] as int? ?? 0xFF4CAF50,
      statusTextColorArgb: map['status_text_color'] as int? ?? 0xFFFFFFFF,
    );
  }
}
