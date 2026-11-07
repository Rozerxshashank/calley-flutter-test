import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiClient {
  static const Duration timeoutDuration = Duration(seconds: 6);

  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .get(uri, headers: headers ?? defaultHeaders)
          .timeout(timeoutDuration);

      return _processResponse(response);
    } on SocketException {
      throw ApiException('Network connection failed');
    } on HttpException {
      throw ApiException('HTTP Service error');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  static Future<dynamic> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await http
          .post(
            uri,
            headers: headers ?? defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeoutDuration);

      return _processResponse(response);
    } on SocketException {
      throw ApiException('Network connection failed');
    } on HttpException {
      throw ApiException('HTTP Service error');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  static dynamic _processResponse(http.Response response) {
    debugPrint('API [${response.statusCode}] ${response.request?.url}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return {'message': response.body};
      }
    } else {
      String errorMessage = 'Request failed with code ${response.statusCode}';
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('message')) {
          errorMessage = decoded['message'];
        }
      } catch (_) {
        if (response.body.isNotEmpty && response.body.length < 100) {
          errorMessage = response.body;
        }
      }
      throw ApiException(errorMessage, response.statusCode);
    }
  }
}

