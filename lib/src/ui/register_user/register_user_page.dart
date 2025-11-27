import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/core/widgets/app_button.dart';
import 'package:classgrao/src/core/widgets/app_input.dart';
import 'package:classgrao/src/ui/register_user/register_user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterUserPage extends ConsumerStatefulWidget {
  const RegisterUserPage({super.key});

  @override
  ConsumerState<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends ConsumerState<RegisterUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
        title: const Text('Cadastro'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Preencha os dados para cadastrar um novo usuário',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _nameController,
                label: 'Nome do Usuário *',
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
                label: 'Usuário *',
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
                label: 'Senha *',
                hint: 'Digite a senha',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar Senha *',
                hint: 'Digite a senha novamente',
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Cadastrar Usuário',
                onPressed: _registerUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = ref.read(registerUserViewModelProvider.notifier);

      final result = await viewModel.registerUser(
        name: _nameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        switch (result) {
          case Success():
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuário cadastrado com sucesso'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          case Failure(error: final error):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao cadastrar usuário: $error'),
                backgroundColor: Colors.red,
              ),
            );
        }
      }
    }
  }
}
