import 'package:dio/dio.dart';
import 'package:classgrao/src/core/exceptions/app_exception.dart';
import 'package:classgrao/src/core/rest_client/rest_client_provider.dart';
import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/auth_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(restClientProvider));
}

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<Result<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);

        if (!authResponse.status) {
          return Failure(
            AppException(authResponse.message),
          );
        }

        return Success(authResponse);
      } else {
        return Failure(
          AppException('Erro ao fazer login'),
        );
      }
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(AppException('Erro inesperado: $e'));
    }
  }

  Future<Result<Nil>> logout(String token) async {
    try {
      await _dio.post(
        '/logout',
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );
      return successOfNil();
    } on DioException catch (e) {
      print('Erro ao fazer logout no servidor: $e');
      return successOfNil();
    } catch (e) {
      return successOfNil();
    }
  }

  AppException _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return AppException('Credenciais inválidas');
    } else if (e.response?.statusCode == 404) {
      return AppException('Usuário não encontrado');
    } else if (e.response?.statusCode == 500) {
      return AppException('Erro no servidor. Tente novamente mais tarde');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return AppException('Tempo de conexão esgotado');
    } else if (e.type == DioExceptionType.connectionError) {
      return AppException('Erro de conexão. Verifique sua internet');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return AppException('Tempo de resposta esgotado');
    }
    return AppException('Erro de conexão: ${e.message}');
  }
}
