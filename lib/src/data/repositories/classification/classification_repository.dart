import 'dart:typed_data';

import 'package:classgrao/src/core/rest_client/rest_client_provider.dart';
import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/classification_model.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'classification_repository.g.dart';

@riverpod
ClassificationRepository classificationRepository(Ref ref) {
  final dio = ref.read(restClientProvider);
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
    Uint8List imageBytes,
    String imageName,
  ) async {
    try {
      final form = FormData.fromMap({
        'title': body['title'],
        'description': body['description'],
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: imageName,
        ),
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

  Future<Result<ClassificationModel>> reprocess(int id) async {
    try {
      final response = await _dio.post('/classifications/$id/reprocess');

      final classification = ClassificationModel.fromJson(
        response.data['data']['classification'],
      );

      return Success(classification);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<Uint8List>> downloadReport(int id) async {
    try {
      final response = await _dio.get(
        '/classifications/$id/report',
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = response.data is Uint8List
          ? response.data as Uint8List
          : Uint8List.fromList(List<int>.from(response.data));

      return Success(bytes);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
