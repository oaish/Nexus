import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'week_event.dart';
part 'week_state.dart';

class WeekBloc extends Bloc<WeekEvent, WeekState> {
  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  WeekBloc() : super(const WeekDaySelected('Mon')) {
    on<LoadCurrentDayEvent>((event, emit) =>
        emit(WeekDaySelected(DateFormat("E").format(DateTime.now()))));
    on<SelectDayEvent>(
        (event, emit) => emit(WeekDaySelected(event.selectedDay)));

    on<NextDayEvent>((event, emit) {
      final currentIndex = weekDays.indexOf(state.selectedDay);
      final nextIndex = (currentIndex + 1) % weekDays.length;
      print('NextIndex: $nextIndex');
      emit(WeekDayCycled(weekDays[nextIndex]));
    });

    on<PreviousDayEvent>((event, emit) {
      final currentIndex = weekDays.indexOf(state.selectedDay);
      final prevIndex = (currentIndex - 1 + weekDays.length) % weekDays.length;
      print('PrevIndex: $prevIndex');
      emit(WeekDayCycled(weekDays[prevIndex]));
    });
  }
}
