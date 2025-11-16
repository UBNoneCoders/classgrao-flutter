import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/classification_model.dart';
import 'package:classgrao/src/data/services/classification/classification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  FutureOr<List<ClassificationModel>> build() async {
    final service = ref.read(classificationServiceProvider);
    final result = await service.getClassifications();

    return switch (result) {
      Success(value: final list) => list,
      Failure(error: final e) => throw e,
    };
  }

  Future<void> loadClassifications() async {
    state = const AsyncLoading();

    final service = ref.read(classificationServiceProvider);
    final result = await service.getClassifications();

    state = switch (result) {
      Success(value: final list) => AsyncData(list),
      Failure(error: final e) => AsyncError(e, StackTrace.current),
    };
  }
}
