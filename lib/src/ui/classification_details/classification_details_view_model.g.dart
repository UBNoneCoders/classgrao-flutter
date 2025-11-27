// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classification_details_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClassificationDetailsViewModel)
const classificationDetailsViewModelProvider =
    ClassificationDetailsViewModelProvider._();

final class ClassificationDetailsViewModelProvider
    extends
        $NotifierProvider<
          ClassificationDetailsViewModel,
          ClassificationDetailsState
        > {
  const ClassificationDetailsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classificationDetailsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classificationDetailsViewModelHash();

  @$internal
  @override
  ClassificationDetailsViewModel create() => ClassificationDetailsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClassificationDetailsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClassificationDetailsState>(value),
    );
  }
}

String _$classificationDetailsViewModelHash() =>
    r'5167746e79bd91487362eb08d90bea4a5daf515a';

abstract class _$ClassificationDetailsViewModel
    extends $Notifier<ClassificationDetailsState> {
  ClassificationDetailsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<ClassificationDetailsState, ClassificationDetailsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ClassificationDetailsState,
                ClassificationDetailsState
              >,
              ClassificationDetailsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
