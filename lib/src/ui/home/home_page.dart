import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:classgrao/src/ui/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleLogout() async {
    final authService = ref.read(authServiceProvider);
    final result = await authService.logout();

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
    final currentUserAsync = ref.watch(currentUserProvider);
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Domínio'),
        foregroundColor: Colors.black,
        elevation: 1, // Sombra leve
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              currentUserAsync.when(
                data: (user) {
                  if (user == null) {
                    return const Text('Nenhum usuário autenticado.');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuário autenticado:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('ID: ${user.id}'),
                      Text('Nome: ${user.name}'),
                      Text('Username: ${user.username}'),
                      Text('Role: ${user.role}'),
                      Text('Ativo: ${user.active}'),
                      const SizedBox(height: 12),
                      FutureBuilder<String?>(
                        future: authService.getToken(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Carregando token...');
                          }
                          if (snapshot.hasError) {
                            return Text(
                              'Erro ao carregar token: ${snapshot.error}',
                            );
                          }
                          final token = snapshot.data;
                          return SelectableText(
                            'Token: ${token ?? "não disponível"}',
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, st) => Text('Erro ao obter usuário: $err'),
              ),
              Center(
                child: Text(
                  'Página Home - Em construção',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
