import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/user_model.dart';
import 'package:classgrao/src/data/services/user/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_view_model.g.dart';

@riverpod
class UsersViewModel extends _$UsersViewModel {
  @override
  FutureOr<List<UserModel>> build() async {
    return await loadUsers();
  }

  Future<List<UserModel>> loadUsers() async {
    final service = ref.read(userServiceProvider);
    final result = await service.getUsers();

    return switch (result) {
      Success(value: final list) => list,
      Failure(error: final e) => throw e,
    };
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    try {
      final users = await loadUsers();
      state = AsyncData(users);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<Result<UserModel>> createUser({
    required String username,
    required String password,
    required String name,
    required String role,
    bool active = true,
  }) async {
    final service = ref.read(userServiceProvider);
    final result = await service.createUser(
      username: username,
      password: password,
      name: name,
      role: role,
      active: active,
    );

    if (result is Success) {
      await refresh();
    }

    return result;
  }

  Future<Result<UserModel>> updateUser({
    required int id,
    String? username,
    String? password,
    String? name,
    String? role,
    bool? active,
  }) async {
    final service = ref.read(userServiceProvider);
    final result = await service.updateUser(
      id: id,
      username: username,
      password: password,
      name: name,
      role: role,
      active: active,
    );

    if (result is Success) {
      await refresh();
    }

    return result;
  }

  Future<Result<Nil>> deleteUser(int id) async {
    final service = ref.read(userServiceProvider);
    final result = await service.deleteUser(id);

    if (result is Success) {
      await refresh();
    }

    return result;
  }
}

@riverpod
class UserDetailsViewModel extends _$UserDetailsViewModel {
  @override
  FutureOr<UserModel?> build(int userId) async {
    return await loadUser(userId);
  }

  Future<UserModel?> loadUser(int userId) async {
    final service = ref.read(userServiceProvider);
    final result = await service.getUserById(userId);

    return switch (result) {
      Success(value: final user) => user,
      Failure(error: final e) => throw e,
    };
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    try {
      final user = await loadUser(userId);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
