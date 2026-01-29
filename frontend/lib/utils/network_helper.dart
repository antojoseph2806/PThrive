import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class NetworkHelper {
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static Future<bool> checkConnectivity() async {
    // For web platform, always return true since we can't check connectivity the same way
    try {
      if (identical(0, 0.0)) {
        // This is a compile-time check for web
        return true;
      }
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      // On web or if check fails, assume connected
      return true;
    }
  }

  static Future<http.Response> getWithTimeout(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    try {
      return await http
          .get(url, headers: headers)
          .timeout(connectionTimeout);
    } on TimeoutException {
      throw NetworkException('Connection timeout. Please try again.');
    } on SocketException {
      throw NetworkException('No internet connection. Please check your network.');
    } catch (e) {
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

  static Future<http.Response> postWithTimeout(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      return await http
          .post(url, headers: headers, body: body)
          .timeout(connectionTimeout);
    } on TimeoutException {
      throw NetworkException('Connection timeout. Please try again.');
    } on SocketException {
      throw NetworkException('No internet connection. Please check your network.');
    } catch (e) {
      throw NetworkException('Network error: ${e.toString()}');
    }
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => message;
}
