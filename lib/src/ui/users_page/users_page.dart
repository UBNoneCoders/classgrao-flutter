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
        data: (users) => _buildContent(context, ref, users),
        loading: () => const AppLoading(),
        error: (error, stack) => _buildErrorState(context, ref, error),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<UserModel> users,
  ) {
    return Column(
      children: [
        _buildSimpleHeader(users),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(usersViewModelProvider.notifier).refresh();
            },
            child: users.isEmpty
                ? _buildEmptyState()
                : _buildUsersList(context, ref, users),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleHeader(List<UserModel> users) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total de Usuários',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            users.length.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(
    BuildContext context,
    WidgetRef ref,
    List<UserModel> users,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _UserCard(
          user: user,
          onEdit: () => Navigator.pushNamed(
            context,
            '/edit-account',
            arguments: user,
          ),
          onToggleActive: () => _toggleUserActive(ref, user),
          onDelete: () => _showDeleteUserDialog(context, ref, user),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum usuário encontrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione o primeiro usuário',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar usuários',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(usersViewModelProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00695C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
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
          'Tem certeza que deseja excluir o usuário "${user.name}"?\n\nEsta ação não pode ser desfeita.',
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

              if (!context.mounted) return;

              switch (result) {
                case Success():
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Usuário excluído com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                case Failure(:final error):
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  const _UserCard({
    required this.user,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildAvatar(),
                const SizedBox(width: 16),
                Expanded(child: _buildUserInfo()),
                _buildActionsMenu(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 28,
      backgroundColor: const Color(0xFF00695C),
      child: Center(
        child: Text(
          user.name[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _buildStatusBadge(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          user.username,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        _buildRoleBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: user.active ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: user.active ? Colors.green[200]! : Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            user.active ? Icons.check_circle : Icons.cancel,
            color: user.active ? Colors.green[700] : Colors.red[700],
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            user.active ? 'Ativo' : 'Inativo',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: user.active ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge() {
    final isAdmin = user.role == 'ADMIN';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAdmin ? Colors.purple[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isAdmin ? 'Administrador' : 'Usuário',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAdmin ? Colors.purple[700] : Colors.blue[700],
        ),
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'toggle_active':
            onToggleActive();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 20, color: Colors.blue),
              SizedBox(width: 12),
              Text('Editar'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle_active',
          child: Row(
            children: [
              Icon(
                user.active ? Icons.block : Icons.check_circle,
                size: 20,
                color: user.active ? Colors.orange : Colors.green,
              ),
              const SizedBox(width: 12),
              Text(user.active ? 'Desativar' : 'Ativar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: 12),
              Text('Excluir', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
