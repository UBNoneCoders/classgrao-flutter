import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/core/widgets/app_loading.dart';
import 'package:classgrao/src/data/models/user_model.dart';
import 'package:classgrao/src/ui/users_page/users_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/register-user');
            },
          ),
        ],
      ),
      body: usersAsync.when(
        data: (users) => _buildUsersList(context, ref, users),
        loading: () => const AppLoading(),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(usersViewModelProvider.notifier).refresh();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersList(
    BuildContext context,
    WidgetRef ref,
    List<UserModel> users,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Total de Usuários',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              Text(
                users.length.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(usersViewModelProvider.notifier).refresh();
            },
            child: users.isEmpty
                ? const Center(
                    child: Text('Nenhum usuário encontrado'),
                  )
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF00695C),
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.role),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.active ? Icons.check_circle : Icons.cancel,
                              color: user.active ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-account',
                                      arguments: user,
                                    );
                                    break;
                                  case 'toggle_active':
                                    _toggleUserActive(ref, user);
                                    break;
                                  case 'delete':
                                    _showDeleteUserDialog(context, ref, user);
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 20),
                                      SizedBox(width: 8),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'toggle_active',
                                  child: Row(
                                    children: [
                                      Icon(
                                        user.active
                                            ? Icons.block
                                            : Icons.check_circle,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        user.active ? 'Desativar' : 'Ativar',
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Excluir',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }


  void _toggleUserActive(WidgetRef ref, UserModel user) async {
    await ref
        .read(usersViewModelProvider.notifier)
        .updateUser(
          id: user.id,
          active: !user.active,
        );
  }

  void _showDeleteUserDialog(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Usuário'),
        content: Text(
          'Tem certeza que deseja excluir o usuário "${user.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);

              final result = await ref
                  .read(usersViewModelProvider.notifier)
                  .deleteUser(user.id);

              if (context.mounted) {
                switch (result) {
                  case Success():
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuário excluído com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  case Failure(error: final error):
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
