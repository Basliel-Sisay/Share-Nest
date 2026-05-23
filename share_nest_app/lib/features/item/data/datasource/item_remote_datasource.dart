import 'package:dio/dio.dart';

import '../models/item_dto.dart';

class ItemRemoteDataSource {
  final Dio _dio;

  ItemRemoteDataSource(this._dio);

  Future<List<ItemDto>> fetchItems() async {
    final response = await _dio.get<Map<String, dynamic>>('/items');
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Empty response from /items',
      );
    }
    final error = data['error'] as String?;
    if (error != null) {
      throw Exception(error);
    }
    final list = data['items'] as List<dynamic>? ?? [];
    return list
        .map((e) => ItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
