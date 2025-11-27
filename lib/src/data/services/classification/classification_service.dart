import 'dart:typed_data';

import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/classification_model.dart';
import 'package:classgrao/src/data/repositories/classification/classification_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'classification_service.g.dart';

@Riverpod(keepAlive: true)
ClassificationService classificationService(Ref ref) {
  return ClassificationService(ref.watch(classificationRepositoryProvider));
}

class ClassificationService {
  final ClassificationRepository _repo;

  ClassificationService(this._repo);

  Future<Result<List<ClassificationModel>>> getClassifications() async {
    return await _repo.getClassifications();
  }

  Future<Result<ClassificationModel>> getClassificationById(int id) async {
    return await _repo.getById(id);
  }

  Future<Result<ClassificationModel>> classifyGrain({
    required Map<String, dynamic> data,
    required Uint8List imageBytes,
    required String imageName,
  }) async {
    return await _repo.classifyGrain(data, imageBytes, imageName);
  }

  Future<Result<Nil>> deleteClassification(int id) async {
    return await _repo.delete(id);
  }

  Future<Result<ClassificationModel>> reprocessClassification(int id) async {
    return await _repo.reprocess(id);
  }

  Future<Result<Uint8List>> downloadReport(int id) async {
    return await _repo.downloadReport(id);
  }
}
