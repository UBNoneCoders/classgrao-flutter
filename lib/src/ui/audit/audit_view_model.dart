import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/audit_model.dart';
import 'package:classgrao/src/data/services/audit/audit_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audit_view_model.g.dart';

@riverpod
class AuditViewModel extends _$AuditViewModel {
  @override
  FutureOr<List<AuditLogModel>> build() async {
    return await loadAuditLogs();
  }

  Future<List<AuditLogModel>> loadAuditLogs() async {
    final service = ref.read(auditServiceProvider);
    final result = await service.getAuditLogs();

    return switch (result) {
      Success(value: final list) => list,
      Failure(error: final e) => throw e,
    };
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    try {
      final logs = await loadAuditLogs();
      state = AsyncData(logs);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Métodos auxiliares para filtrar logs
  List<AuditLogModel> filterByCategory(String category) {
    final currentState = state.value;
    if (currentState == null) return [];

    final service = ref.read(auditServiceProvider);
    return service.filterByCategory(currentState, category);
  }

  List<AuditLogModel> filterByUserId(int userId) {
    final currentState = state.value;
    if (currentState == null) return [];

    final service = ref.read(auditServiceProvider);
    return service.filterByUserId(currentState, userId);
  }

  Map<String, List<AuditLogModel>> groupByDate() {
    final currentState = state.value;
    if (currentState == null) return {};

    final service = ref.read(auditServiceProvider);
    return service.groupByDate(currentState);
  }
}
