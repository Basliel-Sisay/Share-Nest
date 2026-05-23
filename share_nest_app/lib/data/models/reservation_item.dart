class ReservationItem {
  const ReservationItem({
    required this.id,
    required this.resourceId,
    required this.title,
    required this.pickupLocation,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupTime,
    required this.returnTime,
    this.distance = '0.8 Km away',
    this.status = 'CONFIRMED',
  });

  final String id;
  final String resourceId;
  final String title;
  final String pickupLocation;
  final DateTime pickupDate;
  final DateTime returnDate;
  final String pickupTime;
  final String returnTime;
  final String distance;
  final String status;

  String get dateRangeLabel {
    final pickup =
        '${_month(pickupDate)} ${pickupDate.day} - ${_month(returnDate)} ${returnDate.day}';
    return pickup;
  }

  static String _month(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[d.month - 1];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'resource_id': resourceId,
        'title': title,
        'pickup_location': pickupLocation,
        'pickup_date': pickupDate.toIso8601String(),
        'return_date': returnDate.toIso8601String(),
        'pickup_time': pickupTime,
        'return_time': returnTime,
        'distance': distance,
        'status': status,
      };

  factory ReservationItem.fromMap(Map<String, dynamic> map) {
    return ReservationItem(
      id: map['id'] as String,
      resourceId: map['resource_id'] as String,
      title: map['title'] as String,
      pickupLocation: map['pickup_location'] as String,
      pickupDate: DateTime.parse(map['pickup_date'] as String),
      returnDate: DateTime.parse(map['return_date'] as String),
      pickupTime: map['pickup_time'] as String,
      returnTime: map['return_time'] as String,
      distance: (map['distance'] as String?) ?? '0.8 Km away',
      status: (map['status'] as String?) ?? 'CONFIRMED',
    );
  }
}
