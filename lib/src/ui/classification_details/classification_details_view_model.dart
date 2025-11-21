import 'package:flutter_riverpod/legacy.dart';

class ClassificationState {
  final String text;

  ClassificationState({this.text = ''});

  ClassificationState copyWith({String? text}) {
    return ClassificationState(
      text: text ?? this.text,
    );
  }
}

class ClassificationViewModel extends StateNotifier<ClassificationState> {
  ClassificationViewModel() : super(ClassificationState());

  void setText(String value) {
    state = state.copyWith(text: value);
  }
}

final classificationProvider =
    StateNotifierProvider<ClassificationViewModel, ClassificationState>(
      (ref) => ClassificationViewModel(),
    );
