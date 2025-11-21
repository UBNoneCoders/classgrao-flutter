import 'package:flutter/material.dart';
import 'package:classgrao/src/data/models/classification_model.dart';
import 'package:classgrao/src/core/config/env.dart';
import 'dart:convert';

class ClassificationDetailsPage extends StatelessWidget {
  final ClassificationModel classification;

  const ClassificationDetailsPage({
    super.key,
    required this.classification,
  });

  String get imageUrl {
    if (classification.imagePath == null || classification.imagePath!.isEmpty) {
      return '';
    }
    return '${Env.supabaseUrl}/storage/v1/object/public/${classification.imagePath}';
  }

  String _formatResult(dynamic result) {
    if (result == null) {
      return 'Nenhum resultado disponível';
    }

    try {
      Map<String, dynamic> resultMap;

      // Se result é um objeto ClassificationResult, converte para Map
      if (result.runtimeType.toString().contains('ClassificationResult')) {
        resultMap = {
          'total_grains': result.totalGrains ?? 0,
          'total_impurities': result.totalImpurities ?? 0,
          'impurities_percentage': result.impuritiesPercentage ?? 0.0,
          'average_area': result.averageArea ?? 0.0,
          'average_circularity': result.averageCircularity ?? 0.0,
          'average_color_bgr': result.averageColorBgr ?? [],
        };
      }
      // Se result já é um Map
      else if (result is Map) {
        resultMap = Map<String, dynamic>.from(result);
      }
      // Se result é uma String JSON
      else if (result is String) {
        resultMap = jsonDecode(result);
      } else {
        return result.toString();
      }

      // Formata o Map para exibição legível
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(resultMap);
    } catch (e) {
      print('Erro ao formatar resultado: $e');
      return 'Erro ao formatar resultado: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Classificação Específica',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Column(
        children: [
          // Área da imagem
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.grey[300],
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Erro ao carregar imagem: $error');
                        print('URL tentada: $imageUrl');
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.hide_image_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Erro ao carregar imagem',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Icon(
                        Icons.hide_image_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                    ),
            ),
          ),

          // Card de detalhes
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      classification.title ?? 'Sem título',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Descrição
                    const Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      classification.description ??
                          'Nenhuma descrição disponível',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Características e Resultado (JSON completo)
                    const Text(
                      'Características',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Exibir JSON do result formatado
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        _formatResult(classification.result),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontFamily: 'monospace',
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacteristicRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
