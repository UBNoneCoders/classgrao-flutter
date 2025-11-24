import 'package:classgrao/src/core/config/env.dart';
import 'package:classgrao/src/data/models/classification_model.dart';
import 'package:flutter/material.dart';

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

  String get resultImageUrl {
    if (classification.resultImagePath == null ||
        classification.resultImagePath!.isEmpty) {
      return '';
    }
    return '${Env.supabaseUrl}/storage/v1/object/public/${classification.resultImagePath}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _ClassificationImage(imageUrl: imageUrl),
          ),
          Expanded(
            flex: 3,
            child: _DetailsCard(
              classification: classification,
              resultImageUrl: resultImageUrl,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }
}

class _ClassificationImage extends StatelessWidget {
  final String imageUrl;

  const _ClassificationImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                return _buildErrorState();
              },
            )
          : _buildEmptyState(),
    );
  }

  Widget _buildErrorState() {
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
  }

  Widget _buildEmptyState() {
    return Center(
      child: Icon(
        Icons.hide_image_outlined,
        size: 80,
        color: Colors.grey[400],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final ClassificationModel classification;
  final String resultImageUrl;

  const _DetailsCard({
    required this.classification,
    required this.resultImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            _ClassificationHeader(classification: classification),
            const SizedBox(height: 24),
            _ClassificationDescription(
              description: classification.description,
            ),
            const SizedBox(height: 24),
            if (classification.result != null) ...[
              const _SectionTitle(title: 'Resultados da Classificação'),
              const SizedBox(height: 16),
              _ResultCard(result: classification.result!),
              const SizedBox(height: 24),
              if (resultImageUrl.isNotEmpty) ...[
                const _SectionTitle(title: 'Imagem Processada'),
                const SizedBox(height: 12),
                _ResultImage(imageUrl: resultImageUrl),
              ],
            ] else
              const _NoResultsWarning(),
          ],
        ),
      ),
    );
  }
}

class _ClassificationHeader extends StatelessWidget {
  final ClassificationModel classification;

  const _ClassificationHeader({required this.classification});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          classification.title ?? 'Sem título',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (classification.createdAt != null) ...[
          const SizedBox(height: 8),
          Text(
            'Data: ${_formatDate(classification.createdAt!)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _ClassificationDescription extends StatelessWidget {
  final String? description;

  const _ClassificationDescription({this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Descrição'),
        const SizedBox(height: 8),
        Text(
          description ?? 'Nenhuma descrição disponível',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final ClassificationResult result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _ResultRow(
            icon: Icons.grain,
            label: 'Total de Grãos',
            value: '${result.totalGrains}',
            color: Colors.blue[700]!,
          ),
          const Divider(height: 24),
          _ResultRow(
            icon: Icons.check_circle,
            label: 'Grãos Bons',
            value: '${result.goodGrains}',
            color: Colors.green[700]!,
          ),
          const SizedBox(height: 8),
          _ResultRow(
            icon: Icons.cancel,
            label: 'Grãos Ruins',
            value: '${result.badGrains}',
            color: Colors.red[700]!,
          ),
          const Divider(height: 24),
          _PercentageIndicator(
            label: 'Qualidade',
            percentage: result.goodGrainsPercentage,
          ),
          const Divider(height: 24),
          _ResultRow(
            icon: Icons.aspect_ratio,
            label: 'Área Média',
            value: '${result.averageArea.toStringAsFixed(2)} px²',
            color: Colors.purple[700]!,
          ),
          const SizedBox(height: 8),
          _ResultRow(
            icon: Icons.circle_outlined,
            label: 'Circularidade',
            value: result.averageCircularity.toStringAsFixed(2),
            color: Colors.orange[700]!,
          ),
          const SizedBox(height: 8),
          _ColorRow(
            label: 'Cor Média (RGB)',
            colors: result.averageColor,
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _PercentageIndicator extends StatelessWidget {
  final String label;
  final double percentage;

  const _PercentageIndicator({
    required this.label,
    required this.percentage,
  });

  Color _getColor() {
    if (percentage >= 70) return Colors.green;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 12,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _ColorRow extends StatelessWidget {
  final String label;
  final List<double> colors;

  const _ColorRow({
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final r = colors.isNotEmpty ? colors[0].toInt() : 0;
    final g = colors.length > 1 ? colors[1].toInt() : 0;
    final b = colors.length > 2 ? colors[2].toInt() : 0;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromRGBO(r, g, b, 1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!, width: 2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'R: $r, G: $g, B: $b',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultImage extends StatelessWidget {
  final String imageUrl;

  const _ResultImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.grey[400],
                size: 48,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NoResultsWarning extends StatelessWidget {
  const _NoResultsWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Classificação ainda não processada',
              style: TextStyle(
                color: Colors.orange[900],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
