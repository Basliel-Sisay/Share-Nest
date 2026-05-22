class ApiConstants {
  ApiConstants._();

  /// Base URL for Dio (mock interceptor handles requests locally).
  static const String baseUrl = 'https://api.sharenest.local/v1';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Cache is considered stale after this duration.
  static const Duration cacheStaleDuration = Duration(minutes: 5);

  static const String itemsCacheKey = 'items';
}
