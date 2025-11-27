import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/user_model.dart';
import 'package:classgrao/src/data/services/user/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_user_view_model.g.dart';

@riverpod
class RegisterUserViewModel extends _$RegisterUserViewModel {
  @override
  FutureOr<void> build() {}

  Future<Result<UserModel>> registerUser({
    required String name,
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final service = ref.read(userServiceProvider);

    final result = await service.createUser(
      username: username,
      password: password,
      name: name,
      role: 'USER',
      active: true,
    );

    state = switch (result) {
      Success() => const AsyncValue.data(null),
      Failure(error: final error) => AsyncValue.error(
        error,
        StackTrace.current,
      ),
    };

    return result;
  }
}
