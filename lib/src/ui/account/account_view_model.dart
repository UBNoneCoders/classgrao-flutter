import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:classgrao/src/data/services/user/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_view_model.g.dart';

@riverpod
class AccountViewModel extends _$AccountViewModel {
  @override
  FutureOr<void> build() {}

  Future<Result<Nil>> logout() async {
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

    if (result is Success) {
      ref.invalidate(isAuthenticatedProvider);
      ref.invalidate(currentUserProvider);
    }

    return result;
  }

  Future<Result<Nil>> deleteAccount(int userId) async {
    state = const AsyncValue.loading();

    final userService = ref.read(userServiceProvider);
    final result = await userService.deleteUser(userId);

    state = switch (result) {
      Success() => const AsyncValue.data(null),
      Failure(error: final error) => AsyncValue.error(
        error,
        StackTrace.current,
      ),
    };

    if (result is Success) {
      // Após deletar, fazer logout
      final authService = ref.read(authServiceProvider);
      await authService.logout();

      ref.invalidate(isAuthenticatedProvider);
      ref.invalidate(currentUserProvider);
    }

    return result;
  }
}
