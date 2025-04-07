import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/domain/entities/timetable.dart';
import 'package:nexus/presentation/cubits/timetable_manager_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TimeTableManagerCubit extends Cubit<TimeTableManagerState> {
  final SharedPreferences _prefs;
  static const String _timetablesKey = 'timetables';
  static const String _currentTimetableKey = 'current_timetable';

  TimeTableManagerCubit(this._prefs) : super(TimeTableManagerInitial()) {
    loadTimetables();
  }

  void loadTimetables() {
    emit(TimeTableManagerLoading());
    try {
      final timetablesJson = _prefs.getStringList(_timetablesKey) ?? [];
      final timetables = timetablesJson
          .map((json) => TimeTable.fromJson(jsonDecode(json)))
          .toList();

      final currentTimetableJson = _prefs.getString(_currentTimetableKey);
      TimeTable? currentTimetable;
      if (currentTimetableJson != null) {
        currentTimetable = TimeTable.fromJson(jsonDecode(currentTimetableJson));
      }

      emit(TimeTableManagerLoaded(
        timetables: timetables,
        currentTimeTable: currentTimetable,
      ));
    } catch (e) {
      emit(TimeTableManagerError('Failed to load timetables: $e'));
    }
  }

  void saveTimeTable(TimeTable timetable) {
    try {
      final currentState = state;
      if (currentState is TimeTableManagerLoaded) {
        final updatedTimetables = [...currentState.timetables];
        final existingIndex =
            updatedTimetables.indexWhere((t) => t.id == timetable.id);

        if (existingIndex != -1) {
          updatedTimetables[existingIndex] = timetable;
        } else {
          updatedTimetables.add(timetable);
        }

        _saveTimetablesToPrefs(updatedTimetables);
        emit(currentState.copyWith(timetables: updatedTimetables));
      }
    } catch (e) {
      emit(TimeTableManagerError('Failed to save timetable: $e'));
    }
  }

  void deleteTimeTable(String id) {
    try {
      final currentState = state;
      if (currentState is TimeTableManagerLoaded) {
        final updatedTimetables =
            currentState.timetables.where((t) => t.id != id).toList();

        if (currentState.currentTimeTable?.id == id) {
          _prefs.remove(_currentTimetableKey);
          emit(currentState.copyWith(
            timetables: updatedTimetables,
            currentTimeTable: null,
          ));
        } else {
          emit(currentState.copyWith(timetables: updatedTimetables));
        }

        _saveTimetablesToPrefs(updatedTimetables);
      }
    } catch (e) {
      emit(TimeTableManagerError('Failed to delete timetable: $e'));
    }
  }

  void setCurrentTimeTable(TimeTable timetable) {
    try {
      final currentState = state;
      if (currentState is TimeTableManagerLoaded) {
        _prefs.setString(_currentTimetableKey, jsonEncode(timetable.toJson()));
        emit(currentState.copyWith(currentTimeTable: timetable));
      }
    } catch (e) {
      emit(TimeTableManagerError('Failed to set current timetable: $e'));
    }
  }

  void _saveTimetablesToPrefs(List<TimeTable> timetables) {
    final timetablesJson =
        timetables.map((timetable) => jsonEncode(timetable.toJson())).toList();
    _prefs.setStringList(_timetablesKey, timetablesJson);
  }
}
