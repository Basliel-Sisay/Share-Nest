import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import 'api_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/mock_api_interceptor.dart';

class DioClient {
  DioClient._internal(this._dio);

  final Dio _dio;
  Dio get dio => _dio;

  factory DioClient({SecureStorage? storage, ApiClient? apiClient}) {
    final secureStorage = storage ?? SecureStorage();
    final mockApi = apiClient ?? ApiClient();

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      MockApiInterceptor(mockApi),
    ]);

    return DioClient._internal(dio);
  }
}
