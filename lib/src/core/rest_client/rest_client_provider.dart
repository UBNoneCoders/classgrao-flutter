import 'package:dio/dio.dart';
import 'package:classgrao/src/core/config/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rest_client_provider.g.dart';

@Riverpod(keepAlive: true)
Dio restClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dio.options.headers['Content-Type'] = 'application/json';
  dio.interceptors.addAll([
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  ]);

  return dio;
}
