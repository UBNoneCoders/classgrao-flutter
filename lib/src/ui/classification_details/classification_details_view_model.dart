import 'dart:io';
import 'dart:typed_data';

import 'package:classgrao/src/core/result/result.dart';
import 'package:classgrao/src/data/services/classification/classification_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'classification_details_view_model.g.dart';

class ClassificationDetailsState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  ClassificationDetailsState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ClassificationDetailsState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ClassificationDetailsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  ClassificationDetailsState clearMessages() {
    return ClassificationDetailsState(
      isLoading: isLoading,
    );
  }
}

@riverpod
class ClassificationDetailsViewModel extends _$ClassificationDetailsViewModel {
  @override
  ClassificationDetailsState build() {
    return ClassificationDetailsState();
  }

  Future<bool> reprocessClassification(int classificationId) async {
    state = state.copyWith(isLoading: true);

    final service = ref.read(classificationServiceProvider);
    final result = await service.reprocessClassification(classificationId);

    switch (result) {
      case Success():
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Classificação reenviada para análise com sucesso',
        );
        return true;
      case Failure(:final error):
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao reprocessar: ${error.toString()}',
        );
        return false;
    }
  }

  Future<bool> deleteClassification(int classificationId) async {
    state = state.copyWith(isLoading: true);

    final service = ref.read(classificationServiceProvider);
    final result = await service.deleteClassification(classificationId);

    switch (result) {
      case Success():
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Classificação deletada com sucesso',
        );
        return true;
      case Failure(:final error):
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao deletar: ${error.toString()}',
        );
        return false;
    }
  }

  Future<DownloadReportResult> downloadReport(int classificationId) async {
    state = state.copyWith(isLoading: true);

    final service = ref.read(classificationServiceProvider);
    final result = await service.downloadReport(classificationId);

    switch (result) {
      case Success(:final value):
        state = state.copyWith(isLoading: false);
        return DownloadReportResult.success(value);
      case Failure(:final error):
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao baixar relatório: ${error.toString()}',
        );
        return DownloadReportResult.failure(error.toString());
    }
  }

  Future<bool> saveReportToFile(
    Uint8List bytes,
    String classificationTitle,
  ) async {
    try {
      final directoryPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Selecione onde salvar o relatório',
      );

      if (directoryPath != null) {
        final fileName =
            'relatorio_${classificationTitle.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('$directoryPath/$fileName');
        await file.writeAsBytes(bytes);

        state = state.copyWith(
          successMessage: 'Relatório salvo com sucesso em: $directoryPath',
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao salvar arquivo: $e',
      );
      return false;
    }
  }

  void clearMessages() {
    state = state.clearMessages();
  }
}

class DownloadReportResult {
  final Uint8List? bytes;
  final String? error;
  final bool isSuccess;

  DownloadReportResult.success(this.bytes) : error = null, isSuccess = true;

  DownloadReportResult.failure(this.error) : bytes = null, isSuccess = false;
}
