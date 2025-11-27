// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccountViewModel)
const accountViewModelProvider = AccountViewModelProvider._();

final class AccountViewModelProvider
    extends $AsyncNotifierProvider<AccountViewModel, void> {
  const AccountViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountViewModelHash();

  @$internal
  @override
  AccountViewModel create() => AccountViewModel();
}

String _$accountViewModelHash() => r'def5ab892eedaf80a7d66681af8c7d37222e5989';

abstract class _$AccountViewModel extends $AsyncNotifier<void> {
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
