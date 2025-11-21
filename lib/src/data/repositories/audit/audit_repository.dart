import 'package:classgrao/src/core/exceptions/app_exception.dart';
import 'package:classgrao/src/core/rest_client/rest_client_provider.dart';
import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/audit_model.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audit_repository.g.dart';

@riverpod
AuditRepository auditRepository(Ref ref) {
  return AuditRepository(ref.read(restClientProvider));
}

class AuditRepository {
  final Dio _dio;

  AuditRepository(this._dio);

  Future<Result<List<AuditLogModel>>> getAuditLogs() async {
    try {
      final response = await _dio.get('/audits');

      if (response.statusCode == 200) {
        final auditResponse = AuditResponse.fromJson(response.data);

        if (!auditResponse.status) {
          return Failure(
            AppException(auditResponse.message),
          );
        }

        return Success(auditResponse.data.auditLogs);
      } else {
        return Failure(
          AppException('Erro ao buscar logs de auditoria'),
        );
      }
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(AppException('Erro inesperado: $e'));
    }
  }

  AppException _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return AppException('Não autorizado');
    } else if (e.response?.statusCode == 403) {
      return AppException('Acesso negado');
    } else if (e.response?.statusCode == 404) {
      return AppException('Recurso não encontrado');
    } else if (e.response?.statusCode == 500) {
      return AppException('Erro no servidor. Tente novamente mais tarde');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return AppException('Tempo de conexão esgotado');
    } else if (e.type == DioExceptionType.connectionError) {
      return AppException('Erro de conexão. Verifique sua internet');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return AppException('Tempo de resposta esgotado');
    }

    // Tenta extrair mensagem de erro da resposta
    if (e.response?.data != null && e.response?.data is Map) {
      final message = e.response?.data['message'];
      if (message != null) {
        return AppException(message.toString());
      }
    }

    return AppException('Erro de conexão: ${e.message}');
  }
}
