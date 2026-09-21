import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static String get _defaultBaseUrl =>
      defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:5000/api'
      : 'http://localhost:5000/api';

  final http.Client client;
  final String baseUrl;

  ApiClient({http.Client? client, String? baseUrl})
    : client = client ?? http.Client(),
      baseUrl = baseUrl ?? _defaultBaseUrl;

  Future<http.Response> get(String path) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl$path'));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> delete(String path) async {
    try {
      final response = await client.delete(Uri.parse('$baseUrl$path'));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      final error = json.decode(response.body)['error'] ?? 'Unknown error';
      throw Exception('HTTP ${response.statusCode}: $error');
    }
  }
}
