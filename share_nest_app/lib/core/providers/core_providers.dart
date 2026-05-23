import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../network/api_client.dart';
import '../network/dio_client.dart';
import '../storage/secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final dioProvider = Provider<Dio>((ref) {
  return DioClient(
    storage: ref.watch(secureStorageProvider),
    apiClient: ref.watch(apiClientProvider),
  ).dio;
});
