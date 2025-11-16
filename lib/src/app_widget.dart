import 'package:classgrao/src/auth_wrapper.dart';
import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:classgrao/src/ui/classification_form/classification_form_page.dart';
import 'package:classgrao/src/ui/home/home_page.dart';
import 'package:classgrao/src/ui/login/login_page.dart';
import 'package:classgrao/src/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppWidget extends ConsumerStatefulWidget {
  const AppWidget({super.key});

  @override
  ConsumerState<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends ConsumerState<AppWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authServiceProvider).initializeAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassGrão',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        '/splash': (_) => const SplashPage(),
        '/auth': (_) => const AuthWrapper(),
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/classification-form': (_) => const ClassificationFormPage(),
        '/account': (_) => const ClassificationFormPage(),
      },
    );
  }
}
