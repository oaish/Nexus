// lib/presentation/cubits/timetable_editor_state.dart

import 'package:nexus/domain/entities/timetable.dart';

abstract class TimeTableEditorState {}

class TimeTableEditorInitial extends TimeTableEditorState {}

class TimeTableEditorLoaded extends TimeTableEditorState {
  final TimeTable timetable;
  TimeTableEditorLoaded(this.timetable);
}

class TimeTableEditorError extends TimeTableEditorState {
  final String message;
  TimeTableEditorError(this.message);
}
