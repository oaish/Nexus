import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:nexus/domain/entities/timetable_slot.dart';
import 'package:nexus/domain/repositories/timetable_repository.dart';

part 'time_table_event.dart';
part 'time_table_state.dart';

class TimeTableViewBloc extends Bloc<TimeTableViewEvent, TimeTableViewState> {
  final TimeTableRepository repository;

  TimeTableViewBloc({required this.repository})
      : super(const TimeTableViewInitial()) {
    on<LoadTimeTableView>(_onLoadTimeTable);
    on<NextSlot>(_onNextSlot);
    on<PreviousSlot>(_onPreviousSlot);
    on<CircleBatch>(_onCircleBatch);
    on<CircleGroup>(_onCircleGroup);
  }

  void _onLoadTimeTable(
      LoadTimeTableView event, Emitter<TimeTableViewState> emit) {
    try {
      List<TimeTableSlot> slots;
      if (event.weekDay == null) {
        slots = repository.getCurrentDay();
      } else {
        slots = repository.getFromWeekDay(event.weekDay!);
      }
      final currentIndex = repository.getCurrentTimeSlotIndex();
      emit(TimeTableViewLoaded(
        slots: slots,
        currentIndex: currentIndex,
        batchIndex: 0,
        groupIndex: 0,
      ));
    } catch (e) {
      emit(TimeTableViewError(message: e.toString()));
    }
  }

  void _onNextSlot(NextSlot event, Emitter<TimeTableViewState> emit) {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      if (currentState.currentIndex < currentState.slots.length - 1) {
        emit(TimeTableViewLoaded(
          slots: currentState.slots,
          currentIndex: currentState.currentIndex + 1,
          batchIndex: currentState.batchIndex,
          groupIndex: currentState.groupIndex,
        ));
      }
    }
  }

  void _onPreviousSlot(PreviousSlot event, Emitter<TimeTableViewState> emit) {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      if (currentState.currentIndex > 0) {
        emit(TimeTableViewLoaded(
          slots: currentState.slots,
          currentIndex: currentState.currentIndex - 1,
          batchIndex: currentState.batchIndex,
          groupIndex: currentState.groupIndex,
        ));
      }
    }
  }

  void _onCircleBatch(CircleBatch event, Emitter<TimeTableViewState> emit) {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      const batchCount = 3;
      emit(
        TimeTableViewLoaded(
          slots: currentState.slots,
          currentIndex: currentState.currentIndex,
          batchIndex: ((currentState.batchIndex + 1) % batchCount).clamp(0, 2),
          groupIndex: currentState.groupIndex,
        ),
      );
    }
  }

  void _onCircleGroup(CircleGroup event, Emitter<TimeTableViewState> emit) {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      const groupCount = 2;

      emit(
        TimeTableViewLoaded(
          slots: currentState.slots,
          currentIndex: currentState.currentIndex,
          batchIndex: currentState.batchIndex,
          groupIndex: ((currentState.groupIndex + 1) % groupCount).clamp(0, 1),
        ),
      );
    }
  }
}
