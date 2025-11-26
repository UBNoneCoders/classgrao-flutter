import 'dart:convert';

import 'package:classgrao/src/core/exceptions/app_exception.dart';
import 'package:classgrao/src/core/rest_client/rest_client_provider.dart';
import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/auth_model.dart';
import 'package:classgrao/src/data/models/user_model.dart';
import 'package:classgrao/src/data/repositories/auth/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService(ref.watch(authRepositoryProvider), ref);
}

// Provider para verificar se está autenticado
@riverpod
Future<bool> isAuthenticated(Ref ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isAuthenticated();
}

// Provider para obter o usuário atual
@riverpod
Future<UserModel?> currentUser(Ref ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getCurrentUser();
}

// Serviço de autenticação
class AuthService {
  final AuthRepository _repository;
  final Ref _ref;

  AuthService(this._repository, this._ref);

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  Future<Result<AuthData>> login(String username, String password) async {
    final request = LoginRequest(
      username: username,
      password: password,
    );

    final result = await _repository.login(request);

    return switch (result) {
      Success(value: final authResponse) => await _handleLoginSuccess(
        authResponse.data,
      ),
      Failure(error: final error) => Failure(error),
    };
  }

  Future<Result<AuthData>> _handleLoginSuccess(AuthData authData) async {
    try {
      if (authData == null) {
        return Failure(AppException('AuthData inválido'));
      }
      if (authData.token == null || authData.token.isEmpty) {
        return Failure(AppException('Token inválido retornado pela API'));
      }

      await _saveAuthData(authData);

      _setAuthToken(authData.token);

      _ref.invalidate(isAuthenticatedProvider);
      _ref.invalidate(currentUserProvider);

      return Success(authData);
    } catch (e, st) {
      // ignore: avoid_print
      print('[AuthService] _handleLoginSuccess error: $e\n$st');
      return Failure(AppException('Erro ao salvar dados de autenticação'));
    }
  }

  Future<Result<Nil>> logout() async {
    try {
      final token = await getToken();
      final result = await _repository.logout(token ?? '');

      await _clearAuthData();
      _removeAuthToken();

      _ref.invalidate(isAuthenticatedProvider);
      _ref.invalidate(currentUserProvider);

      return result;
    } catch (e, st) {
      // ignore: avoid_print
      print('[AuthService] logout error: $e\n$st');
      return Failure(AppException('Erro ao realizar logout'));
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e, st) {
      // ignore: avoid_print
      print('[AuthService] isAuthenticated error: $e\n$st');
      return false;
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e, st) {
      // ignore: avoid_print
      print('[AuthService] getToken error: $e\n$st');
      return null;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        try {
          return UserModel.fromJson(json.decode(userJson));
        } catch (e) {
          // ignore: avoid_print
          print('[AuthService] getCurrentUser parse error: $e');
          return null;
        }
      }
      return null;
    } catch (e, st) {
      // ignore: avoid_print
      print('[AuthService] getCurrentUser error: $e\n$st');
      return null;
    }
  }

  Future<void> _saveAuthData(AuthData authData) async {
    final prefs = await SharedPreferences.getInstance();

    // defensive: ensure token and user are not null
    final token = authData.token;
    final user = authData.user;
    if (token == null || token.isEmpty) {
      throw AppException('Token inválido ao salvar');
    }
    if (user == null) {
      throw AppException('User inválido ao salvar');
    }

    await prefs.setString(_tokenKey, token);

    final userJson = json.encode(user.toJson());
    await prefs.setString(_userKey, userJson);

    // ignore: avoid_print
    print(
      '[AuthService] saved auth data. token length=${token.length}, userJson=${userJson.substring(0, token.length > 20 ? 20 : userJson.length)}...',
    );
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    // ignore: avoid_print
    print('[AuthService] cleared auth data from SharedPreferences');
  }

  void _setAuthToken(String? token) {
    try {
      if (token == null || token.isEmpty) {
        // ignore: avoid_print
        print(
          '[AuthService] _setAuthToken called with null/empty token, skipping',
        );
        return;
      }

      final dio = _ref.read(restClientProvider);
      if (dio == null) {
        // ignore: avoid_print
        print(
          '[AuthService] restClientProvider returned null, cannot set header',
        );
        return;
      }

      dio.options.headers['Authorization'] = 'Bearer $token';
      // ignore: avoid_print
      print('[AuthService] Authorization header set');
    } catch (e, st) {
      // ignore: avoid_print
      print('[AuthService] Error setting auth token: $e\n$st');
    }
  }

  void _removeAuthToken() {
    try {
      final dio = _ref.read(restClientProvider);
      if (dio == null) {
        // ignore: avoid_print
        print(
          '[AuthService] restClientProvider returned null, cannot remove header',
        );
        return;
      }
      dio.options.headers.remove('Authorization');
      // ignore: avoid_print
      print('[AuthService] Authorization header removed');
    } catch (e, st) {
      // ignore: avoid_print
      print('[AuthService] Error removing auth token: $e\n$st');
    }
  }

  Future<void> initializeAuth() async {
    try {
      final token = await getToken();
      // ignore: avoid_print
      print(
        '[AuthService] initializeAuth token=${token == null ? "null" : "********"}',
      );

      if (token != null && token.isNotEmpty) {
        _setAuthToken(token);

        _ref.invalidate(isAuthenticatedProvider);
        _ref.invalidate(currentUserProvider);
      }
    } catch (e, st) {
      // ignore: avoid_print
      print('[AuthService] initializeAuth error: $e\n$st');
    }
  }
}
