import 'package:classgrao/src/data/repositories/auth/auth_repository.dart';
import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'services_provider.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthService(ref.read(authRepositoryProvider), ref);
}
