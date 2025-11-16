class ClassificationModel {
  final int id;
  final String title;
  final String? description;
  final String? imagePath;
  final DateTime? createdAt;
  final int? userId;
  final bool? hasClassificated;
  final ClassificationResult? result;

  ClassificationModel({
    required this.id,
    required this.title,
    this.description,
    this.imagePath,
    this.createdAt,
    this.userId,
    this.hasClassificated,
    this.result,
  });

  factory ClassificationModel.fromJson(Map<String, dynamic> json) {
    return ClassificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imagePath: json['image_path'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      userId: json['user_id'],
      hasClassificated: json['has_classificated'],
      result: json['result'] != null
          ? ClassificationResult.fromJson(json['result'])
          : null,
    );
  }
}

class ClassificationResult {
  final int totalGrains;
  final int totalImpurities;
  final double impuritiesPercentage;
  final double averageArea;
  final double averageCircularity;
  final List<double> averageColorBgr;

  ClassificationResult({
    required this.totalGrains,
    required this.totalImpurities,
    required this.impuritiesPercentage,
    required this.averageArea,
    required this.averageCircularity,
    required this.averageColorBgr,
  });

  factory ClassificationResult.fromJson(Map<String, dynamic> json) {
    return ClassificationResult(
      totalGrains: json['total_grains'],
      totalImpurities: json['total_impurities'],
      impuritiesPercentage: (json['impurities_percentage'] as num).toDouble(),
      averageArea: (json['average_area'] as num).toDouble(),
      averageCircularity: (json['average_circularity'] as num).toDouble(),
      averageColorBgr: (json['average_color_bgr'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
