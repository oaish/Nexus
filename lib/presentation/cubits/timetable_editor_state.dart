import 'package:equatable/equatable.dart';
import 'package:nexus/domain/entities/timetable.dart';

abstract class TimeTableEditorState extends Equatable {
  const TimeTableEditorState();

  @override
  List<Object?> get props => [];
}

class TimeTableEditorInitial extends TimeTableEditorState {}

class TimeTableEditorLoading extends TimeTableEditorState {}

class TimeTableEditorLoaded extends TimeTableEditorState {
  final TimeTable timetable;
  final bool isEditing;

  const TimeTableEditorLoaded({
    required this.timetable,
    required this.isEditing,
  });

  @override
  List<Object?> get props => [timetable, isEditing];

  TimeTableEditorLoaded copyWith({
    TimeTable? timetable,
    bool? isEditing,
  }) {
    return TimeTableEditorLoaded(
      timetable: timetable ?? this.timetable,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class TimeTableEditorError extends TimeTableEditorState {
  final String message;

  const TimeTableEditorError(this.message);

  @override
  List<Object?> get props => [message];
}
