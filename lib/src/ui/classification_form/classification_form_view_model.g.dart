// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classification_form_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ClassificationFormViewModel)
const classificationFormViewModelProvider =
    ClassificationFormViewModelProvider._();

final class ClassificationFormViewModelProvider
    extends
        $NotifierProvider<
          ClassificationFormViewModel,
          ClassificationFormState
        > {
  const ClassificationFormViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classificationFormViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classificationFormViewModelHash();

  @$internal
  @override
  ClassificationFormViewModel create() => ClassificationFormViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClassificationFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClassificationFormState>(value),
    );
  }
}

String _$classificationFormViewModelHash() =>
    r'37032a335732527f0f995d427b3e06c664611631';

abstract class _$ClassificationFormViewModel
    extends $Notifier<ClassificationFormState> {
  ClassificationFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<ClassificationFormState, ClassificationFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ClassificationFormState, ClassificationFormState>,
              ClassificationFormState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
