import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_provider.dart';

class ApiInterceptor extends Interceptor {
  final SecureAuthStorage _secureStorage;
  ApiInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      debugPrint('🚨 401 Unauthorized: Token expired or invalid.');
      // TODO: Trigger global logout via Riverpod or Event Bus
    } else if (statusCode == 500) {
      debugPrint('🚨 500 Server Error: The backend is currently failing.');
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      debugPrint('🚨 Timeout: The connection took too long.');
    }

    return super.onError(err, handler);
  }
}