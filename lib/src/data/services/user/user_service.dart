import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/user_model.dart';
import 'package:classgrao/src/data/repositories/user/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_service.g.dart';

@riverpod
UserService userService(Ref ref) {
  return UserService(ref.watch(userRepositoryProvider));
}

class UserService {
  final UserRepository _repository;

  UserService(this._repository);

  Future<Result<List<UserModel>>> getUsers() async {
    return await _repository.getUsers();
  }

  Future<Result<UserModel>> getUserById(int id) async {
    return await _repository.getUserById(id);
  }

  Future<Result<UserModel>> createUser({
    required String username,
    required String password,
    required String name,
    required String role,
    bool active = true,
  }) async {
    final request = CreateUserRequest(
      username: username,
      password: password,
      name: name,
      role: role,
      active: active,
    );

    return await _repository.createUser(request);
  }

  Future<Result<UserModel>> updateUser({
    required int id,
    String? username,
    String? password,
    String? name,
    String? role,
    bool? active,
  }) async {
    final request = UpdateUserRequest(
      username: username,
      password: password,
      name: name,
      role: role,
      active: active,
    );

    return await _repository.updateUser(id, request);
  }

  Future<Result<Nil>> deleteUser(int id) async {
    return await _repository.deleteUser(id);
  }
}
