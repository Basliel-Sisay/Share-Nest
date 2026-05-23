class LoanItem {
  const LoanItem({
    required this.id,
    required this.resourceId,
    required this.title,
    required this.ownerId,
    required this.ownerName,
    required this.borrowerId,
    required this.borrowerName,
    required this.statusText,
    required this.dateText,
    required this.pickupDate,
    required this.returnDate,
    this.pickupTime = '',
    this.returnTime = '',
    this.statusColorArgb = 0xFFF3E5F5,
    this.statusTextColorArgb = 0xFF7B1FA2,
  });

  final String id;
  final String resourceId;
  final String title;
  final String ownerId;
  final String ownerName;
  final String borrowerId;
  final String borrowerName;
  final String statusText;
  final String dateText;
  final DateTime pickupDate;
  final DateTime returnDate;
  final String pickupTime;
  final String returnTime;
  final int statusColorArgb;
  final int statusTextColorArgb;

  bool get isPending => statusText == 'PENDING';
  bool get isApproved => statusText == 'APPROVED' || statusText == 'CONFIRMED';
  bool get isConfirmed => statusText == 'CONFIRMED';
  bool get isActive => statusText == 'ACTIVE';
  bool get isReturned => statusText == 'RETURNED';
  bool get isCancelled => statusText == 'CANCELLED';
  bool get isRejected => statusText == 'REJECTED';
  bool get isExtended => statusText == 'EXTENDED';

  LoanItem copyWith({
    String? dateText,
    DateTime? returnDate,
    String? statusText,
  }) {
    return LoanItem(
      id: id,
      resourceId: resourceId,
      title: title,
      ownerId: ownerId,
      ownerName: ownerName,
      borrowerId: borrowerId,
      borrowerName: borrowerName,
      statusText: statusText ?? this.statusText,
      dateText: dateText ?? this.dateText,
      pickupDate: pickupDate,
      returnDate: returnDate ?? this.returnDate,
      pickupTime: pickupTime,
      returnTime: returnTime,
      statusColorArgb: statusColorArgb,
      statusTextColorArgb: statusTextColorArgb,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'resource_id': resourceId,
        'title': title,
        'owner_id': ownerId,
        'owner_name': ownerName,
        'borrower_id': borrowerId,
        'borrower_name': borrowerName,
        'status_text': statusText,
        'date_text': dateText,
        'pickup_date': pickupDate.toIso8601String(),
        'return_date': returnDate.toIso8601String(),
        'pickup_time': pickupTime,
        'return_time': returnTime,
        'status_color': statusColorArgb,
        'status_text_color': statusTextColorArgb,
      };

  factory LoanItem.fromMap(Map<String, dynamic> map) {
    return LoanItem(
      id: map['id'] as String,
      resourceId: map['resource_id'] as String,
      title: map['title'] as String,
      ownerId: (map['owner_id'] as String?) ?? '',
      ownerName: map['owner_name'] as String,
      borrowerId: (map['borrower_id'] as String?) ?? '',
      borrowerName: (map['borrower_name'] as String?) ?? '',
      statusText: map['status_text'] as String,
      dateText: map['date_text'] as String,
      pickupDate: DateTime.parse(map['pickup_date'] as String),
      returnDate: DateTime.parse(map['return_date'] as String),
      pickupTime: (map['pickup_time'] as String?) ?? '',
      returnTime: (map['return_time'] as String?) ?? '',
      statusColorArgb: map['status_color'] as int? ?? 0xFFF3E5F5,
      statusTextColorArgb: map['status_text_color'] as int? ?? 0xFF7B1FA2,
    );
  }
}
