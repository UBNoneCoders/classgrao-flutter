import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:classgrao/src/ui/home/home_page.dart';
import 'package:classgrao/src/ui/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(isAuthenticatedProvider);

    return authAsync.when(
      data: (isAuthenticated) {
        if (isAuthenticated) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      error: (error, stack) => const LoginPage(),
    );
  }
}
