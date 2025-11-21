import 'package:classgrao/src/core/exceptions/app_exception.dart';
import 'package:classgrao/src/core/rest_client/rest_client_provider.dart';
import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(ref.read(restClientProvider));
}

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<Result<List<UserModel>>> getUsers() async {
    try {
      final response = await _dio.get('/users');

      if (response.statusCode == 200) {
        // Acessa a estrutura aninhada corretamente
        final data = response.data['data'] as Map<String, dynamic>;
        final List<dynamic> usersList = data['users'] as List;
        final users = usersList
            .map((json) => UserModel.fromJson(json))
            .toList();
        return Success(users);
      } else {
        return Failure(
          AppException('Erro ao buscar usuários'),
        );
      }
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(AppException('Erro inesperado: $e'));
    }
  }

  Future<Result<UserModel>> getUserById(int id) async {
    try {
      final response = await _dio.get('/users/$id');

      if (response.statusCode == 200) {
        // Verifique se a resposta do GET também tem essa estrutura
        // Se sim, ajuste da mesma forma:
        final data = response.data['data'];
        final user = UserModel.fromJson(data);
        return Success(user);
      } else {
        return Failure(
          AppException('Erro ao buscar usuário'),
        );
      }
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(AppException('Erro inesperado: $e'));
    }
  }

  Future<Result<UserModel>> createUser(CreateUserRequest request) async {
    try {
      final response = await _dio.post(
        '/users',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Ajuste se a resposta também tiver estrutura aninhada
        final data = response.data['data'];
        final user = UserModel.fromJson(data);
        return Success(user);
      } else {
        return Failure(
          AppException('Erro ao criar usuário'),
        );
      }
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(AppException('Erro inesperado: $e'));
    }
  }

  Future<Result<UserModel>> updateUser(
    int id,
    UpdateUserRequest request,
  ) async {
    try {
      final response = await _dio.put(
        '/users/$id',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data']['user'];
        final user = UserModel.fromJson(data);

        return Success(user);
      } else {
        return Failure(
          AppException('Erro ao atualizar usuário'),
        );
      }
    } on DioException catch (e) {
      return Failure(_handleDioError(e));
    } catch (e) {
      return Failure(AppException('Erro inesperado: $e'));
    }
  }

  Future<Result<Nil>> deleteUser(int id) async {
    try {
      final response = await _dio.delete('/users/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return successOfNil();
      } else {
        return Failure(
          AppException('Erro ao deletar usuário'),
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
      return AppException('Usuário não encontrado');
    } else if (e.response?.statusCode == 409) {
      return AppException('Usuário já existe');
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
