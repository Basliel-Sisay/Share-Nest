import 'package:dio/dio.dart';
import '../api_client.dart';

class MockApiInterceptor extends Interceptor {
  final ApiClient _apiClient;

  MockApiInterceptor(this._apiClient);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final response = await _handleRequest(options);
      handler.resolve(response);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  Future<Response<dynamic>> _handleRequest(RequestOptions options) async {
    final path = options.path;
    final method = options.method.toUpperCase();
    final token = _extractBearerToken(options);

    ApiResponse apiResponse;

    if (path == '/auth/signup' && method == 'POST') {
      final data = options.data as Map<String, dynamic>? ?? {};
      apiResponse = await _apiClient.signup(
        name: data['name'] as String? ?? '',
        email: data['email'] as String? ?? '',
        password: data['password'] as String? ?? '',
      );
    } else if (path == '/auth/login' && method == 'POST') {
      final data = options.data as Map<String, dynamic>? ?? {};
      apiResponse = await _apiClient.login(
        email: data['email'] as String? ?? '',
        password: data['password'] as String? ?? '',
      );
    } else if (path == '/auth/logout' && method == 'POST') {
      apiResponse = await _apiClient.logout(token ?? '');
    } else if (path == '/auth/account' && method == 'DELETE') {
      apiResponse = await _apiClient.deleteAccount(token ?? '');
    } else if (path == '/auth/validate' && method == 'GET') {
      apiResponse = await _apiClient.validateToken(token ?? '');
    } else if (path == '/items' && method == 'GET') {
      apiResponse = await _apiClient.fetchItems();
    } else {
      apiResponse = ApiResponse(
        success: false,
        error: 'No mock handler for $method $path',
      );
    }

    final statusCode = apiResponse.success ? 200 : 400;
    return Response(
      requestOptions: options,
      statusCode: statusCode,
      data: apiResponse.success
          ? apiResponse.data
          : {'error': apiResponse.error},
    );
  }

  String? _extractBearerToken(RequestOptions options) {
    final auth = options.headers['Authorization'] as String?;
    if (auth == null || !auth.startsWith('Bearer ')) return null;
    return auth.substring(7);
  }
}
