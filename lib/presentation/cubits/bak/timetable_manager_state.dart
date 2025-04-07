// lib/presentation/cubits/timetable_manager_state.dart

import 'package:nexus/domain/entities/timetable.dart';

abstract class TimeTableManagerState {}

class TimeTableManagerInitial extends TimeTableManagerState {}

class TimeTableManagerLoaded extends TimeTableManagerState {
  final List<TimeTable> timetables;
  final TimeTable? currentTimeTable;

  TimeTableManagerLoaded({required this.timetables, this.currentTimeTable});
}

class TimeTableManagerError extends TimeTableManagerState {
  final String message;
  TimeTableManagerError(this.message);
}
