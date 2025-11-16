import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:classgrao/src/core/rest_client/rest_client_provider.dart';
import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/classification_model.dart';

part 'classification_repository.g.dart';

@riverpod
ClassificationRepository classificationRepository(Ref ref) {
  final dio = ref.watch(restClientProvider)!;
  return ClassificationRepository(dio);
}

class ClassificationRepository {
  final Dio _dio;

  ClassificationRepository(this._dio);

  Future<Result<List<ClassificationModel>>> getClassifications() async {
    try {
      final response = await _dio.get('/classifications');

      final list = (response.data['data']['classifications'] as List)
          .map((c) => ClassificationModel.fromJson(c))
          .toList();

      return Success(list);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<ClassificationModel>> getById(int id) async {
    try {
      final response = await _dio.get('/classifications/$id');

      final classification = ClassificationModel.fromJson(
        response.data['data']['classification'],
      );

      return Success(classification);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<Nil>> delete(int id) async {
    try {
      await _dio.delete('/classifications/$id');
      return Success(Nil());
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<ClassificationModel>> classifyGrain(
    Map<String, dynamic> body,
    String imagePath,
  ) async {
    try {
      final form = FormData.fromMap({
        ...body,
        "file": await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post('/classifications', data: form);

      final classification = ClassificationModel.fromJson(
        response.data['data']['classification'],
      );

      return Success(classification);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
