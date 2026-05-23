import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
class ApiException implements Exception{
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient{
  ApiClient({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  Future<List<Map<String, dynamic>>> getList(String path) async{
    final response = await _client.get(
      ApiConfig.uri(path),
      headers: _headers,
    );
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body);
    if (decoded is! List){
      throw ApiException('Expected JSON array from $path');
    }
    return decoded.cast<Map<String, dynamic>>();
  }
  Future<Map<String, dynamic>> getOne(String path) async{
    final response = await _client.get(
      ApiConfig.uri(path),
      headers: _headers,
    );
    _ensureSuccess(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async{
    final response = await _client.post(
      ApiConfig.uri(path),
      headers: _headers,
      body: jsonEncode(body),
    );
    _ensureSuccess(response, okStatuses: {200, 201});
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> patch(String path,Map<String, dynamic> body) async{
    final response = await _client.patch(
      ApiConfig.uri(path),
      headers: _headers,
      body: jsonEncode(body),
    );
    _ensureSuccess(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Map<String, String> get _headers =>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  void _ensureSuccess(http.Response response, {
    Set<int> okStatuses = const {200},
  }){
    if (okStatuses.contains(response.statusCode)){
      return;
    } 
    String message = response.body;
    try{
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      message = json['error']?.toString() ?? message;
    } catch (_){
      
    }
    throw ApiException(
      message.isEmpty ? 'Request failed' : message,
      statusCode: response.statusCode,
    );
  }
}
