import 'package:classgrao/src/core/widgets/analysis_list.dart';
import 'package:classgrao/src/core/widgets/app_bottom_navigate.dart';
import 'package:classgrao/src/core/widgets/home_app_bar.dart';
import 'package:classgrao/src/core/widgets/search_bar_widget.dart';
import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:classgrao/src/ui/home/home_view_model.dart';
import 'package:classgrao/src/ui/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<void> _handleLogout() async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();

    ref.invalidate(isAuthenticatedProvider);
    ref.invalidate(currentUserProvider);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final classificationsAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: HomeAppBar(onLogout: _handleLogout),
      bottomNavigationBar: const AppBottomNavigationBar(
        currentIndex: 0,
      ),
      body: classificationsAsync.when(
        data: (classifications) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SearchBarWidget(),
                  const SizedBox(height: 24),
                  AnalysisList(classifications: classifications),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erro: $e')),
      ),
    );
  }
}
