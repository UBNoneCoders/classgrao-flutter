import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/user_model.dart';
import 'package:classgrao/src/data/services/user/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_user_view_model.g.dart';

@riverpod
class EditUserViewModel extends _$EditUserViewModel {
  @override
  FutureOr<void> build() {}

  Future<Result<UserModel>> updateUser({
    required int id,
    String? username,
    String? password,
    String? name,
  }) async {
    final service = ref.read(userServiceProvider);

    final result = await service.updateUser(
      id: id,
      username: username,
      password: password,
      name: name,
    );

    return result;
  }
}
