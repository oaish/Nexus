import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:nexus/core/constants/app_data.dart';

class WeekState extends Equatable {
  final String selectedDay;

  const WeekState(this.selectedDay);

  @override
  List<Object> get props => [selectedDay];
}

class WeekCubit extends Cubit<WeekState> {
  WeekCubit() : super(const WeekState('Monday'));

  void loadCurrentDay() {
    emit(WeekState(DateFormat("EEEE").format(DateTime.now())));
  }

  void selectDay(String selectedDay) {
    emit(WeekState(selectedDay));
  }

  void nextDay() {
    final currentIndex = weekDays.indexOf(state.selectedDay);
    final nextIndex = (currentIndex + 1) % weekDays.length;
    emit(WeekState(weekDays[nextIndex]));
  }

  void previousDay() {
    final currentIndex = weekDays.indexOf(state.selectedDay);
    final prevIndex = (currentIndex - 1 + weekDays.length) % weekDays.length;
    emit(WeekState(weekDays[prevIndex]));
  }
}
