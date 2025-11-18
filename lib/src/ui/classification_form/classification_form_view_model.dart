import 'dart:typed_data';
import 'package:classgrao/src/data/services/classification/classification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/models/classification_model.dart';

part 'classification_form_view_model.g.dart';

enum ClassificationFormStatus {
  initial,
  loading,
  success,
  error,
}

class ClassificationFormState {
  final ClassificationFormStatus status;
  final String? errorMessage;
  final ClassificationModel? classification;

  ClassificationFormState({
    required this.status,
    this.errorMessage,
    this.classification,
  });

  factory ClassificationFormState.initial() {
    return ClassificationFormState(status: ClassificationFormStatus.initial);
  }

  ClassificationFormState copyWith({
    ClassificationFormStatus? status,
    String? errorMessage,
    ClassificationModel? classification,
  }) {
    return ClassificationFormState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      classification: classification ?? this.classification,
    );
  }
}

@riverpod
class ClassificationFormViewModel extends _$ClassificationFormViewModel {
  @override
  ClassificationFormState build() {
    return ClassificationFormState.initial();
  }

  Future<void> submitClassification({
    required String title,
    required String description,
    required Uint8List imageBytes,
    required String imageName,
  }) async {
    state = state.copyWith(status: ClassificationFormStatus.loading);

    final service = ref.read(classificationServiceProvider);

    final data = {
      'title': title,
      'description': description,
    };

    final result = await service.classifyGrain(
      data: data,
      imageBytes: imageBytes,
      imageName: imageName,
    );

    print(result);

    switch (result) {
      case Success(:final value):
        state = state.copyWith(
          status: ClassificationFormStatus.success,
          classification: value,
        );
        break;
      case Failure(:final error):
        state = state.copyWith(
          status: ClassificationFormStatus.error,
          errorMessage: error.toString(),
        );
        break;
    }
  }
}
