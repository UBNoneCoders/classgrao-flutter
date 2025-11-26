import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/core/widgets/app_button.dart';
import 'package:classgrao/src/core/widgets/app_input.dart';
import 'package:classgrao/src/data/models/user_model.dart';
import 'package:classgrao/src/data/services/auth/auth_service.dart';
import 'package:classgrao/src/ui/edit_user/edit_user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditUserPage extends ConsumerStatefulWidget {
  final UserModel user;

  const EditUserPage({super.key, required this.user});

  @override
  ConsumerState<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends ConsumerState<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _usernameController = TextEditingController(text: widget.user.username);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Nome do Usuário',
                hint: 'Digite o nome completo',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _usernameController,
                label: 'Usuário',
                hint: 'Digite o nome de usuário',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o usuário';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                label: 'Senha (deixe em branco para não alterar)',
                hint: 'Digite a nova senha',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar Senha',
                hint: 'Digite a senha novamente',
                obscureText: true,
                validator: (value) {
                  if (_passwordController.text.isNotEmpty) {
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    if (_passwordController.text.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Salvar Alterações',
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final result = await ref
          .read(editUserViewModelProvider.notifier)
          .updateUser(
            id: widget.user.id,
            name: _nameController.text,
            username: _usernameController.text,
            password: _passwordController.text.isEmpty
                ? null
                : _passwordController.text,
          );

      if (context.mounted) {
        Navigator.pop(context);

        switch (result) {
          case Success():
            // Atualiza os dados do usuário no provider
            ref.invalidate(currentUserProvider);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Conta atualizada com sucesso'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Retorna true indicando sucesso
          case Failure(error: final error):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                backgroundColor: Colors.red,
              ),
            );
        }
      }
    }
  }
}
