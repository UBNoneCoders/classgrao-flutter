import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/auth_model.dart';
import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  FutureOr<AuthResponse?> build() {
    return null;
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    final authService = ref.read(authServiceProvider);
    final result = await authService.login(username, password);

    state = switch (result) {
      Success(value: final authData) => AsyncValue.data(
        AuthResponse(
          status: true,
          message: 'Login realizado com sucesso',
          data: authData,
        ),
      ),
      Failure(error: final error) => AsyncValue.error(
        error,
        StackTrace.current,
      ),
    };
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();

    final authService = ref.read(authServiceProvider);
    final result = await authService.logout();

    state = switch (result) {
      Success() => const AsyncValue.data(null),
      Failure(error: final error) => AsyncValue.error(
        error,
        StackTrace.current,
      ),
    };
  }
}
