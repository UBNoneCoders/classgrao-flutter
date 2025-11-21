// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UsersViewModel)
const usersViewModelProvider = UsersViewModelProvider._();

final class UsersViewModelProvider
    extends $AsyncNotifierProvider<UsersViewModel, List<UserModel>> {
  const UsersViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usersViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usersViewModelHash();

  @$internal
  @override
  UsersViewModel create() => UsersViewModel();
}

String _$usersViewModelHash() => r'4c82b0295462a1715190920b379c6784d5869fb8';

abstract class _$UsersViewModel extends $AsyncNotifier<List<UserModel>> {
  FutureOr<List<UserModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<UserModel>>, List<UserModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<UserModel>>, List<UserModel>>,
              AsyncValue<List<UserModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UserDetailsViewModel)
const userDetailsViewModelProvider = UserDetailsViewModelFamily._();

final class UserDetailsViewModelProvider
    extends $AsyncNotifierProvider<UserDetailsViewModel, UserModel?> {
  const UserDetailsViewModelProvider._({
    required UserDetailsViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'userDetailsViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userDetailsViewModelHash();

  @override
  String toString() {
    return r'userDetailsViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserDetailsViewModel create() => UserDetailsViewModel();

  @override
  bool operator ==(Object other) {
    return other is UserDetailsViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userDetailsViewModelHash() =>
    r'71e9c28e2dbacfcf052ec2d98b033c20de292c41';

final class UserDetailsViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          UserDetailsViewModel,
          AsyncValue<UserModel?>,
          UserModel?,
          FutureOr<UserModel?>,
          int
        > {
  const UserDetailsViewModelFamily._()
    : super(
        retry: null,
        name: r'userDetailsViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserDetailsViewModelProvider call(int userId) =>
      UserDetailsViewModelProvider._(argument: userId, from: this);

  @override
  String toString() => r'userDetailsViewModelProvider';
}

abstract class _$UserDetailsViewModel extends $AsyncNotifier<UserModel?> {
  late final _$args = ref.$arg as int;
  int get userId => _$args;

  FutureOr<UserModel?> build(int userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<UserModel?>, UserModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserModel?>, UserModel?>,
              AsyncValue<UserModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
