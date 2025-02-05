part of 'time_table_bloc.dart';

@immutable
sealed class TimeTableViewEvent extends Equatable {
  const TimeTableViewEvent();

  @override
  List<Object?> get props => [];
}

class LoadTimeTableView extends TimeTableViewEvent {
  final String? weekDay;

  const LoadTimeTableView({this.weekDay});
}

class NextSlot extends TimeTableViewEvent {}

class PreviousSlot extends TimeTableViewEvent {}

class CircleBatch extends TimeTableViewEvent {}

class CircleGroup extends TimeTableViewEvent {}
