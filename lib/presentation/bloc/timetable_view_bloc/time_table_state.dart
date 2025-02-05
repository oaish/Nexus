part of 'time_table_bloc.dart';

@immutable
sealed class TimeTableViewState extends Equatable {
  const TimeTableViewState(); // Ensures subclasses are also immutable

  @override
  List<Object?> get props => [];
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

final class TimeTableViewError extends TimeTableViewState {
  final String message;

  const TimeTableViewError({required this.message});

  @override
  List<Object> get props => [message];
}
