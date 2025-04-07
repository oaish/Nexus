import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:nexus/domain/entities/timetable_slot.dart';
import 'package:nexus/domain/repositories/timetable_view_repository.dart';

@immutable
sealed class TimeTableViewState extends Equatable {
  const TimeTableViewState();

  @override
  List<Object?> get props => [];
}

class TimeTableViewCubit extends Cubit<TimeTableViewState> {
  final TimeTableViewRepository repository;

  TimeTableViewCubit({required this.repository})
      : super(const TimeTableViewInitial());

  Future<void> loadTimeTable({String? weekDay}) async {
    List<TimeTableSlot> slots;
    if (weekDay == null) {
      slots = await repository.getCurrentDay();
    } else {
      slots = await repository.getFromWeekDay(weekDay);
    }
    final currentIndex = await repository.getCurrentTimeSlotIndex();
    emit(TimeTableViewLoaded(
      slots: slots,
      currentIndex: currentIndex,
      batchIndex: 0,
      groupIndex: 0,
    ));
  }

  void nextSlot() {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      if (currentState.currentIndex < currentState.slots.length - 1) {
        emit(currentState.copyWith(
          currentIndex: currentState.currentIndex + 1,
        ));
      }
    }
  }

  void previousSlot() {
    if (state is TimeTableViewLoaded) {
      final currentState = state as TimeTableViewLoaded;
      if (currentState.currentIndex > 0) {
        emit(currentState.copyWith(
          currentIndex: currentState.currentIndex - 1,
        ));
      }
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
}

final class TimeTableViewInitial extends TimeTableViewState {
  const TimeTableViewInitial();
}

final class TimeTableViewLoaded extends TimeTableViewState {
  final List<TimeTableSlot> slots;
  final int currentIndex;
  final int batchIndex;
  final int groupIndex;

  const TimeTableViewLoaded({
    required this.slots,
    required this.currentIndex,
    required this.batchIndex,
    required this.groupIndex,
  });

  TimeTableViewLoaded copyWith(
      {int? currentIndex, int? batchIndex, int? groupIndex}) {
    return TimeTableViewLoaded(
      slots: slots,
      currentIndex: currentIndex ?? this.currentIndex,
      batchIndex: batchIndex ?? this.batchIndex,
      groupIndex: groupIndex ?? this.groupIndex,
    );
  }

  @override
  List<Object> get props => [slots, currentIndex, batchIndex, groupIndex];
}
