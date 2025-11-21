import 'package:classgrao/src/auth_wrapper.dart';
import 'package:classgrao/src/data/models/classification_model.dart';
import 'package:classgrao/src/data/models/user_model.dart';
import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:classgrao/src/ui/account/account_page.dart';
import 'package:classgrao/src/ui/audit/audit_page.dart';
import 'package:classgrao/src/ui/classification_details/classification_details_page.dart';
import 'package:classgrao/src/ui/classification_form/classification_form_page.dart';
import 'package:classgrao/src/ui/edit_account/edit_account_page.dart';
import 'package:classgrao/src/ui/home/home_page.dart';
import 'package:classgrao/src/ui/login/login_page.dart';
import 'package:classgrao/src/ui/register_user/register_user_page.dart';
import 'package:classgrao/src/ui/splash/splash_page.dart';
import 'package:classgrao/src/ui/users_page/users_page.dart';
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
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00695C),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const SplashPage(),
      routes: {
        '/splash': (_) => const SplashPage(),
        '/auth': (_) => const AuthWrapper(),
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/classification-form': (_) => const ClassificationFormPage(),
        '/classification-details': (context) {
          final classification =
              ModalRoute.of(context)!.settings.arguments as ClassificationModel;
          return ClassificationDetailsPage(classification: classification);
        },
        '/account': (_) => const AccountPage(),
        '/edit-account': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as UserModel;
          return EditAccountPage(user: user);
        },
        '/users': (_) => const UsersPage(),
        '/audit': (_) => const AuditPage(),
        '/register-user': (_) => const RegisterUserPage(),
      },
    );
  }
}
