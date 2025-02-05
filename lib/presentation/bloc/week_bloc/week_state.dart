part of 'week_bloc.dart';

class WeekState extends Equatable {
  final String selectedDay;

  const WeekState(this.selectedDay);

  @override
  List<Object> get props => [];
}

class WeekStateInitial extends WeekState {
  const WeekStateInitial() : super('');
  @override
  List<Object> get props => [];
}

class WeekDaySelected extends WeekState {
  const WeekDaySelected(super.selectedDay);

  @override
  List<Object> get props => [selectedDay];
}

class WeekDayCycled extends WeekState {
  const WeekDayCycled(super.selectedDay);

  @override
  List<Object> get props => [selectedDay];
}
