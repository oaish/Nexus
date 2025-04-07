import 'package:equatable/equatable.dart';
import 'package:nexus/domain/entities/timetable.dart';

abstract class TimeTableViewState extends Equatable {
  const TimeTableViewState();

  @override
  List<Object?> get props => [];
}

class TimeTableViewInitial extends TimeTableViewState {}

class TimeTableViewLoading extends TimeTableViewState {}

class TimeTableViewLoaded extends TimeTableViewState {
  final TimeTable timetable;
  final int batchIndex;
  final int groupIndex;
  final int currentIndex;
  final int currentDayIndex;

  const TimeTableViewLoaded({
    required this.timetable,
    this.batchIndex = 0,
    this.groupIndex = 0,
    this.currentIndex = 0,
    this.currentDayIndex = 0,
  });

  @override
  List<Object?> get props =>
      [timetable, batchIndex, groupIndex, currentIndex, currentDayIndex];

  TimeTableViewLoaded copyWith({
    TimeTable? timetable,
    int? batchIndex,
    int? groupIndex,
    int? currentIndex,
    int? currentDayIndex,
  }) {
    return TimeTableViewLoaded(
      timetable: timetable ?? this.timetable,
      batchIndex: batchIndex ?? this.batchIndex,
      groupIndex: groupIndex ?? this.groupIndex,
      currentIndex: currentIndex ?? this.currentIndex,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
    );
  }
}

class TimeTableViewError extends TimeTableViewState {
  final String message;

  const TimeTableViewError(this.message);

  @override
  List<Object?> get props => [message];
}
