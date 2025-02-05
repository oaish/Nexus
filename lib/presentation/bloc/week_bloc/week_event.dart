part of 'week_bloc.dart';

abstract class WeekEvent extends Equatable {
  const WeekEvent();

  @override
  List<Object> get props => [];
}

class SelectDayEvent extends WeekEvent {
  final String selectedDay;

  const SelectDayEvent(this.selectedDay);

  @override
  List<Object> get props => [selectedDay];
}

class LoadCurrentDayEvent extends WeekEvent {
  const LoadCurrentDayEvent();
  @override
  List<Object> get props => [];
}

class NextDayEvent extends WeekEvent {}

class PreviousDayEvent extends WeekEvent {}
