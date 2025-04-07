import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/presentation/cubits/timetable_manager_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_manager_state.dart';
import 'package:nexus/presentation/cubits/timetable_view_state.dart';

const List<String> weekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday'
];

class TimeTableViewCubit extends Cubit<TimeTableViewState> {
  final TimeTableManagerCubit _timeTableManagerCubit;
  int _currentIndex = 0;

  TimeTableViewCubit(this._timeTableManagerCubit)
      : super(TimeTableViewInitial());

  Future<void> loadTimeTable() async {
    try {
      emit(TimeTableViewLoading());

      // Get the current timetable from the TimeTableManagerCubit
      final managerState = _timeTableManagerCubit.state;
      if (managerState is TimeTableManagerLoaded &&
          managerState.currentTimeTable != null) {
        final timetable = managerState.currentTimeTable!;

        emit(TimeTableViewLoaded(
          timetable: timetable,
          batchIndex: 0,
          groupIndex: 0,
          currentIndex: _currentIndex,
          currentDayIndex: 0,
        ));
      } else {
        emit(TimeTableViewError('No timetable selected'));
      }
    } catch (e) {
      emit(TimeTableViewError('Failed to load timetable: $e'));
    }
  }

  void selectBatch(int batchIndex) {
    try {
      final currentState = state;
      if (currentState is TimeTableViewLoaded) {
        emit(currentState.copyWith(batchIndex: batchIndex));
      }
    } catch (e) {
      emit(TimeTableViewError('Failed to select batch: $e'));
    }
  }

  void selectGroup(int groupIndex) {
    try {
      final currentState = state;
      if (currentState is TimeTableViewLoaded) {
        emit(currentState.copyWith(groupIndex: groupIndex));
      }
    } catch (e) {
      emit(TimeTableViewError('Failed to select group: $e'));
    }
  }

  void circleBatch() {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      const batchCount = 3;
      final newBatchIndex = (currentState.batchIndex + 1) % batchCount;
      emit(currentState.copyWith(batchIndex: newBatchIndex));
    }
  }

  void circleGroup() {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      const groupCount = 2;
      final newGroupIndex = (currentState.groupIndex + 1) % groupCount;
      emit(currentState.copyWith(groupIndex: newGroupIndex));
    }
  }

  void nextSlot() {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      final slots = currentState
              .timetable.schedule[weekDays[currentState.currentDayIndex]] ??
          [];
      if (_currentIndex < slots.length - 1) {
        _currentIndex++;
        emit(currentState.copyWith(currentIndex: _currentIndex));
      }
    }
  }

  void previousSlot() {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      if (_currentIndex > 0) {
        _currentIndex--;
        emit(currentState.copyWith(currentIndex: _currentIndex));
      }
    }
  }

  void refreshTimeTable() {
    loadTimeTable();
  }
}
