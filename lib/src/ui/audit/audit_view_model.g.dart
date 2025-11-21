// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuditViewModel)
const auditViewModelProvider = AuditViewModelProvider._();

final class AuditViewModelProvider
    extends $AsyncNotifierProvider<AuditViewModel, List<AuditLogModel>> {
  const AuditViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditViewModelHash();

  @$internal
  @override
  AuditViewModel create() => AuditViewModel();
}

String _$auditViewModelHash() => r'f986003cc8dde5f1938bc141cd0269ba3eea4d76';

abstract class _$AuditViewModel extends $AsyncNotifier<List<AuditLogModel>> {
  FutureOr<List<AuditLogModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<AuditLogModel>>, List<AuditLogModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AuditLogModel>>, List<AuditLogModel>>,
              AsyncValue<List<AuditLogModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
