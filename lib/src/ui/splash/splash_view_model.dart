import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_view_model.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  String? build() {
    return null;
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    final authService = ref.read(authServiceProvider);
    final isAuthenticated = await authService.isAuthenticated();
    final user = await authService.getCurrentUser();

    if (isAuthenticated && user != null) {
      await authService.initializeAuth();
      state = '/home';
    } else {
      state = '/login';
    }
  }
}
