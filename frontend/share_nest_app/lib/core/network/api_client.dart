import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../config/api_config.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({http.Client? client, this.authToken})
      : _client = client ?? _createClient();

  static const _timeout = Duration(seconds: 8);
  static const _connectionTimeout = Duration(seconds: 5);

  final http.Client _client;
  final String? authToken;

  static http.Client _createClient() {
    if (kIsWeb) {
      return http.Client();
    }
    final httpClient = HttpClient()
      ..connectionTimeout = _connectionTimeout
      ..idleTimeout = _connectionTimeout;
    return IOClient(httpClient);
  }

  ApiClient withAuthToken(String token) {
    return ApiClient(client: _client, authToken: token);
  }

  Future<List<Map<String, dynamic>>> getList(String path) async {
    final response = await _request(
      _client.get(ApiConfig.uri(path), headers: _headers),
    );
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw ApiException('Expected JSON array from $path');
    }
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getOne(String path) async {
    final response = await _request(
      _client.get(ApiConfig.uri(path), headers: _headers),
    );
    _ensureSuccess(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _request(
      _client.post(
        ApiConfig.uri(path),
        headers: _headers,
        body: jsonEncode(body),
      ),
    );
    _ensureSuccess(response, okStatuses: {200, 201});
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _request(
      _client.put(
        ApiConfig.uri(path),
        headers: _headers,
        body: jsonEncode(body),
      ),
    );
    _ensureSuccess(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> patch(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await _request(
      _client.patch(
        ApiConfig.uri(path),
        headers: _headers,
        body: jsonEncode(body),
      ),
    );
    _ensureSuccess(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> delete(String path) async {
    final response = await _request(
      _client.delete(ApiConfig.uri(path), headers: _headers),
    );
    _ensureSuccess(response, okStatuses: {200, 202, 204});
  }

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  Future<http.Response> _request(Future<http.Response> request) async {
    try {
      return await request.timeout(_timeout);
    } on TimeoutException {
      throw ApiException(
        'Connection timed out. Start the backend: cd backend && npm start',
      );
    } on SocketException {
      throw ApiException(
        'Cannot reach the server at ${ApiConfig.baseUrl}. '
        'Run the backend (npm start in the backend folder).',
      );
    }
  }

  void _ensureSuccess(
    http.Response response, {
    Set<int> okStatuses = const {200},
  }) {
    if (okStatuses.contains(response.statusCode)) {
      return;
    }
    String message = response.body;
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['error'] != null) {
        message = json['error'].toString();
      }
    } catch (_) {}
    throw ApiException(
      message.isEmpty ? 'Request failed' : message,
      statusCode: response.statusCode,
    );
  }
}
