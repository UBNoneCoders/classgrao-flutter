// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_user_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditUserViewModel)
const editUserViewModelProvider = EditUserViewModelProvider._();

final class EditUserViewModelProvider
    extends $AsyncNotifierProvider<EditUserViewModel, void> {
  const EditUserViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editUserViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editUserViewModelHash();

  @$internal
  @override
  EditUserViewModel create() => EditUserViewModel();
}

String _$editUserViewModelHash() => r'e9d3a8380d2cc8f0ec74af56029c3a3680de4bfe';

abstract class _$EditUserViewModel extends $AsyncNotifier<void> {
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
