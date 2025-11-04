// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginViewModel)
const loginViewModelProvider = LoginViewModelProvider._();

final class LoginViewModelProvider
    extends $AsyncNotifierProvider<LoginViewModel, AuthResponse?> {
  const LoginViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginViewModelHash();

  @$internal
  @override
  LoginViewModel create() => LoginViewModel();
}

String _$loginViewModelHash() => r'244c11e57f876cf5b37004674795ffcded9aad38';

abstract class _$LoginViewModel extends $AsyncNotifier<AuthResponse?> {
  FutureOr<AuthResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AuthResponse?>, AuthResponse?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthResponse?>, AuthResponse?>,
              AsyncValue<AuthResponse?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
