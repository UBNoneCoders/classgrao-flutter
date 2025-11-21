import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/audit_model.dart';
import 'package:classgrao/src/data/repositories/audit/audit_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audit_service.g.dart';

@riverpod
AuditService auditService(Ref ref) {
  return AuditService(ref.watch(auditRepositoryProvider));
}

class AuditService {
  final AuditRepository _repository;

  AuditService(this._repository);

  Future<Result<List<AuditLogModel>>> getAuditLogs() async {
    return await _repository.getAuditLogs();
  }

  // Métodos auxiliares para filtrar logs por tipo de ação
  List<AuditLogModel> filterByCategory(
    List<AuditLogModel> logs,
    String category,
  ) {
    return logs.where((log) => log.actionCategory == category).toList();
  }

  List<AuditLogModel> filterByUserId(
    List<AuditLogModel> logs,
    int userId,
  ) {
    return logs.where((log) => log.userId == userId).toList();
  }

  List<AuditLogModel> filterByDateRange(
    List<AuditLogModel> logs,
    DateTime startDate,
    DateTime endDate,
  ) {
    return logs.where((log) {
      return log.createdAt.isAfter(startDate) &&
          log.createdAt.isBefore(endDate);
    }).toList();
  }

  // Método para agrupar logs por data
  Map<String, List<AuditLogModel>> groupByDate(List<AuditLogModel> logs) {
    final Map<String, List<AuditLogModel>> grouped = {};

    for (final log in logs) {
      final dateKey =
          '${log.createdAt.day.toString().padLeft(2, '0')}/${log.createdAt.month.toString().padLeft(2, '0')}/${log.createdAt.year}';

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(log);
    }

    return grouped;
  }
}
