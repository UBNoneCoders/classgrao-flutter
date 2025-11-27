// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RegisterUserViewModel)
const registerUserViewModelProvider = RegisterUserViewModelProvider._();

final class RegisterUserViewModelProvider
    extends $AsyncNotifierProvider<RegisterUserViewModel, void> {
  const RegisterUserViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerUserViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerUserViewModelHash();

  @$internal
  @override
  RegisterUserViewModel create() => RegisterUserViewModel();
}

String _$registerUserViewModelHash() =>
    r'4c4a1a62243bae61a6daadc59cb53d56a30db382';

abstract class _$RegisterUserViewModel extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
