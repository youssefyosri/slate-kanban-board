import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../env/app_config.dart';
import '../storage/secure_storage_provider.dart';
import 'api_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final secureStorage = ref.watch(secureAuthStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(ApiInterceptor(secureStorage));

  if (config.environment == Environment.dev) {
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  return dio;
});