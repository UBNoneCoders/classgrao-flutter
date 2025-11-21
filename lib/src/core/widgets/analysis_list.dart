import 'package:classgrao/src/core/widgets/analysis_card.dart';
import 'package:classgrao/src/data/models/classification_model.dart';
import 'package:flutter/material.dart';

class AnalysisList extends StatelessWidget {
  final List<ClassificationModel> classifications;

  const AnalysisList({
    super.key,
    required this.classifications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Listagem de Análises',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildAnalysisList(context),
      ],
    );
  }

  Widget _buildAnalysisList(BuildContext context) {
    return Column(
      children: classifications.map((classification) {
        return AnalysisCard(
          title: classification.title,
          date: classification.createdAt?.toString().substring(0, 10) ?? 'Sem data',
          status: classification.hasClassificated == true
              ? "Classificada"
              : "Pendente",
          onTap: () {
            Navigator.pushNamed(
              context,
              '/classification-details',
              arguments: classification,
            );
          },
          imagePath: classification.imagePath ?? '',
        );
      }).toList(),
    );
  }
}
