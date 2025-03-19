import 'package:flutter_bloc/flutter_bloc.dart';

class ShadAutoCompleteCubit extends Cubit<List<String>> {
  final List<String> allSuggestions;

  ShadAutoCompleteCubit(this.allSuggestions) : super([]);

  void updateSuggestions(String value) {
    if (value.isEmpty) {
      emit([]);
      return;
    }
    emit(allSuggestions.where((element) => element.toLowerCase().contains(value.toLowerCase())).toList());
  }

  void clearSuggestions() {
    emit([]);
  }
}
