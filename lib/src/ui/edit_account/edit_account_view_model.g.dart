// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_account_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditAccountViewModel)
const editAccountViewModelProvider = EditAccountViewModelProvider._();

final class EditAccountViewModelProvider
    extends $AsyncNotifierProvider<EditAccountViewModel, void> {
  const EditAccountViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editAccountViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editAccountViewModelHash();

  @$internal
  @override
  EditAccountViewModel create() => EditAccountViewModel();
}

String _$editAccountViewModelHash() =>
    r'408e1b1a5486409b9ad6a58f757295e52a0ac18b';

abstract class _$EditAccountViewModel extends $AsyncNotifier<void> {
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
