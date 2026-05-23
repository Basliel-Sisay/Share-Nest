import 'dart:io';

/// Base URL for the ShareNest Node.js API.
///
/// Override when testing on a physical device:
/// `flutter run --dart-define=API_BASE_URL=http://192.168.x.x:3000`
class ApiConfig {
  static const _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3001';
    }
    return 'http://localhost:3001';
  }

  static Uri uri(String path) => Uri.parse('$baseUrl$path');
}
