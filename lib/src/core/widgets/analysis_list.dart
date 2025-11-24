import 'package:classgrao/src/core/widgets/analysis_card.dart';
import 'package:classgrao/src/data/models/classification_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalysisList extends StatelessWidget {
  final List<ClassificationModel> classifications;

  const AnalysisList({
    super.key,
    required this.classifications,
  });

  @override
  Widget build(BuildContext context) {
    if (classifications.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildList(context),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Listagem de Análises',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${classifications.length} ${classifications.length == 1 ? "análise" : "análises"}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return Column(
      children: classifications.map((classification) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnalysisCard(
            title: classification.title,
            date: _formatDate(classification.createdAt),
            status: _getStatus(classification.hasClassificated),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/classification-details',
                arguments: classification,
              );
            },
            imagePath: classification.imagePath ?? '',
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma análise encontrada',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie sua primeira análise para começar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Sem data';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoje às ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Ontem às ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  String _getStatus(bool? hasClassificated) {
    if (hasClassificated == null || hasClassificated == false) {
      return 'Pendente';
    }
    return 'Classificada';
  }
}
