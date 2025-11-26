import 'dart:io';
import 'dart:typed_data';

import 'package:classgrao/src/core/widgets/app_bottom_navigate.dart';
import 'package:classgrao/src/core/widgets/app_button.dart';
import 'package:classgrao/src/core/widgets/app_image_upload.dart';
import 'package:classgrao/src/core/widgets/app_input.dart';
import 'package:classgrao/src/core/widgets/app_text_area.dart';
import 'package:classgrao/src/ui/classification_form/classification_form_view_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassificationFormPage extends ConsumerStatefulWidget {
  const ClassificationFormPage({super.key});

  @override
  ConsumerState<ClassificationFormPage> createState() =>
      _ClassificationFormPageState();
}

class _ClassificationFormPageState
    extends ConsumerState<ClassificationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Uint8List? _imageBytes;
  String? _imageName;
  String? _imageError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(
        classificationFormViewModelProvider,
        (previous, next) {
          if (next.status == ClassificationFormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Enviado para análise com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            _clearForm();
          } else if (next.status == ClassificationFormStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro: ${next.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    });
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        if (file.name.isEmpty) {
          setState(() {
            _imageError = 'Arquivo inválido. Selecione uma imagem válida.';
          });
          return;
        }

        Uint8List? bytes = file.bytes;

        if (bytes == null && file.path != null) {
          try {
            final fileBytes = await File(file.path!).readAsBytes();
            bytes = Uint8List.fromList(fileBytes);
          } catch (e) {
            setState(() {
              _imageError = 'Erro ao ler o arquivo da imagem';
            });
            return;
          }
        }

        if (bytes == null) {
          setState(() {
            _imageError = 'Não foi possível carregar a imagem';
          });
          return;
        }

        setState(() {
          _imageBytes = bytes;
          _imageName = file.name;
          _imageError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _imageBytes = null;
      _imageName = null;
    });
  }

  Future<void> _submitForm() async {
    setState(() {
      if (_imageBytes == null) {
        _imageError = 'Por favor, adicione uma imagem';
      } else if (_imageName == null || _imageName!.isEmpty) {
        _imageError = 'Nome do arquivo é obrigatório';
      } else {
        _imageError = null;
      }
    });

    final isValidForm = _formKey.currentState!.validate();
    final hasImage = _imageBytes != null;
    final hasName = _imageName != null && _imageName!.isNotEmpty;

    if (isValidForm && hasImage && hasName) {
      await ref
          .read(classificationFormViewModelProvider.notifier)
          .submitClassification(
            title: _titleController.text,
            description: _descriptionController.text,
            imageBytes: _imageBytes!,
            imageName: _imageName!,
          );
    }
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _imageBytes = null;
      _imageName = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(classificationFormViewModelProvider);
    final isLoading = state.status == ClassificationFormStatus.loading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Nova Classificação',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Classificação',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Adicione uma foto do grupo e preencha as informações',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 24),
              // Alerta amarelo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFBC02D),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFF57F17),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Importante!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF57F17),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'A imagem deve ser tirada a aproximadamente 15 cm de altura, com boa iluminação e fundo preto.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppImageUpload(
                label: 'Imagem',
                imageBytes: _imageBytes,
                imageName: _imageName,
                onPickImage: _pickImage,
                onRemoveImage: _removeImage,
                errorText: _imageError,
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _titleController,
                label: 'Título da Análise *',
                hint: 'Digite o título',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AppTextArea(
                controller: _descriptionController,
                label: 'Descrição',
                hint: 'Adicione detalhes sobre a análise...',
                maxLines: 6,
                maxLength: 500,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  if (value.trim().length < 10) {
                    return 'A descrição deve ter pelo menos 10 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Enviar para Análise',
                onPressed: _submitForm,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 1),
    );
  }
}
