// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classification_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(classificationRepository)
const classificationRepositoryProvider = ClassificationRepositoryProvider._();

final class ClassificationRepositoryProvider
    extends
        $FunctionalProvider<
          ClassificationRepository,
          ClassificationRepository,
          ClassificationRepository
        >
    with $Provider<ClassificationRepository> {
  const ClassificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'classificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$classificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClassificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClassificationRepository create(Ref ref) {
    return classificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClassificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClassificationRepository>(value),
    );
  }
}

String _$classificationRepositoryHash() =>
    r'c011d364a207ff47e2c86102b63463189cde45e4';
