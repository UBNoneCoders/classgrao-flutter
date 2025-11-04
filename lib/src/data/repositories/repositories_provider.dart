import 'package:dio/dio.dart';
import 'package:classgrao/src/data/repositories/auth/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repositories_provider.g.dart';

@riverpod
Dio dioProvider(Ref ref) {
  return Dio();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final dio = ref.read(dioProviderProvider);
  return AuthRepository(dio);
}
