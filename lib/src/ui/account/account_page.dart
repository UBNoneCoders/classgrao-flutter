import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/core/widgets/app_bottom_navigate.dart';
import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:classgrao/src/ui/account/account_view_model.dart';
import 'package:classgrao/src/ui/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Conta'),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Usuário não encontrado'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF00695C),
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00695C),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                if (user.role == 'ADMIN') ...[
                  _buildMenuItem(
                    context,
                    'Auditoria do Sistema',
                    Icons.history,
                    () => Navigator.pushNamed(context, '/audit'),
                  ),
                  _buildMenuItem(
                    context,
                    'Usuários',
                    Icons.people,
                    () => Navigator.pushNamed(context, '/users'),
                  ),
                ] else ...[
                  _buildMenuItem(
                    context,
                    'Editar Conta',
                    Icons.edit,
                    () => Navigator.pushNamed(
                      context,
                      '/edit-user',
                      arguments: user,
                    ),
                  ),
                  _buildMenuItem(
                    context,
                    'Deletar Conta',
                    Icons.delete,
                    () => _showDeleteConfirmation(context, ref),
                    textColor: Colors.red,
                  ),
                ],
                _buildMenuItem(
                  context,
                  'Sair',
                  Icons.logout,
                  () => _showLogoutConfirmation(context, ref),
                  textColor: Colors.red,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erro: $error')),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: textColor ?? Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text(
            'Tem certeza que deseja deletar sua conta? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                final user = await ref.read(currentUserProvider.future);
                if (user == null) return;

                final viewModel = ref.read(accountViewModelProvider.notifier);
                final result = await viewModel.deleteAccount(user.id);

                if (context.mounted) {
                  switch (result) {
                    case Success():
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Conta deletada com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    case Failure(error: final error):
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao deletar conta: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

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

                final viewModel = ref.read(accountViewModelProvider.notifier);
                final result = await viewModel.logout();

                if (context.mounted) {
                  switch (result) {
                    case Success():
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
                    case Failure(error: final error):
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao fazer logout: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                  }
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
}
