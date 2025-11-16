// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classification_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(classificationService)
const classificationServiceProvider = ClassificationServiceProvider._();

final class ClassificationServiceProvider
    extends
        $FunctionalProvider<
          ClassificationService,
          ClassificationService,
          ClassificationService
        >
    with $Provider<ClassificationService> {
  const ClassificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classificationServiceHash();

  @$internal
  @override
  $ProviderElement<ClassificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClassificationService create(Ref ref) {
    return classificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClassificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClassificationService>(value),
    );
  }
}

String _$classificationServiceHash() =>
    r'8aef394ee90575d5924d690981d7de1b69b54736';
