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
    required String imagePath,
  }) async {
    return await _repo.classifyGrain(data, imagePath);
  }

  Future<Result<Nil>> deleteClassification(int id) async {
    return await _repo.delete(id);
  }
}
