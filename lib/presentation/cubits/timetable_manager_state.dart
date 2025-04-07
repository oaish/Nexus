import 'package:equatable/equatable.dart';
import 'package:nexus/domain/entities/timetable.dart';

abstract class TimeTableManagerState extends Equatable {
  const TimeTableManagerState();

  @override
  List<Object?> get props => [];
}

class TimeTableManagerInitial extends TimeTableManagerState {}

class TimeTableManagerLoading extends TimeTableManagerState {}

class TimeTableManagerLoaded extends TimeTableManagerState {
  final List<TimeTable> timetables;
  final TimeTable? currentTimeTable;

  const TimeTableManagerLoaded({
    required this.timetables,
    this.currentTimeTable,
  });

  @override
  List<Object?> get props => [timetables, currentTimeTable];

  TimeTableManagerLoaded copyWith({
    List<TimeTable>? timetables,
    TimeTable? currentTimeTable,
  }) {
    return TimeTableManagerLoaded(
      timetables: timetables ?? this.timetables,
      currentTimeTable: currentTimeTable ?? this.currentTimeTable,
    );
  }
}

class TimeTableManagerError extends TimeTableManagerState {
  final String message;

  const TimeTableManagerError(this.message);

  @override
  List<Object?> get props => [message];
}
