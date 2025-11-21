class ClassificationModel {
  final int id;
  final String title;
  final String? description;
  final String? imagePath;
  final DateTime? createdAt;
  final int? userId;
  final bool? hasClassificated;
  final ClassificationResult? result;
  final String? resultImagePath;

  ClassificationModel({
    required this.id,
    required this.title,
    this.description,
    this.imagePath,
    this.createdAt,
    this.userId,
    this.hasClassificated,
    this.result,
    this.resultImagePath,
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
      resultImagePath: json['result_image_path'],
    );
  }
}

class ClassificationResult {
  final int totalGrains;
  final int goodGrains;
  final int badGrains;
  final double goodGrainsPercentage;
  final double averageArea;
  final double averageCircularity;
  final List<double> averageColor;

  ClassificationResult({
    required this.totalGrains,
    required this.goodGrains,
    required this.badGrains,
    required this.goodGrainsPercentage,
    required this.averageArea,
    required this.averageCircularity,
    required this.averageColor,
  });

  factory ClassificationResult.fromJson(Map<String, dynamic> json) {
    return ClassificationResult(
      totalGrains: json['total_grains'],
      goodGrains: json['good_grains'],
      badGrains: json['bad_grains'],
      goodGrainsPercentage: (json['good_grains_percentage'] as num).toDouble(),
      averageArea: (json['average_area'] as num).toDouble(),
      averageCircularity: (json['average_circularity'] as num).toDouble(),
      averageColor: (json['average_color'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}
