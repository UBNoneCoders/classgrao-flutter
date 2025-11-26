import 'package:classgrao/src/core/widgets/analysis_list.dart';
import 'package:classgrao/src/core/widgets/app_bottom_navigate.dart';
import 'package:classgrao/src/core/widgets/home_app_bar.dart';
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
  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const Text(
            'Tem certeza que deseja sair da sua conta?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                final authService = ref.read(authServiceProvider);
                await authService.logout();

                ref.invalidate(isAuthenticatedProvider);
                ref.invalidate(currentUserProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sessão encerrada com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00695C),
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleRefresh() async {
    await ref.refresh(homeViewModelProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final classificationsAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: HomeAppBar(onLogout: () => _showLogoutConfirmation(context, ref)),
      bottomNavigationBar: const AppBottomNavigationBar(
        currentIndex: 0,
      ),
      body: classificationsAsync.when(
        data: (classifications) {
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnalysisList(classifications: classifications),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Center(child: Text('Erro: $e')),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
