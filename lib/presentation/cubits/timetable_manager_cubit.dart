// lib/presentation/cubits/timetable_manager_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:nexus/domain/entities/timetable.dart';
import 'package:nexus/domain/repositories/timetable_repository.dart';

import 'timetable_manager_state.dart';

class TimeTableManagerCubit extends Cubit<TimeTableManagerState> {
  final TimeTableRepository timetableRepository;

  TimeTableManagerCubit({required this.timetableRepository})
      : super(TimeTableManagerInitial());

  Future<void> loadTimeTables() async {
    try {
      final timetables = await timetableRepository.getAllTimeTables();
      emit(TimeTableManagerLoaded(timetables: timetables));
    } catch (e) {
      emit(TimeTableManagerError('Failed to load timetables: $e'));
    }
  }

  Future<void> saveTimeTable(TimeTable timetable) async {
    try {
      await timetableRepository.saveTimeTable(timetable);
      await loadTimeTables();
    } catch (e) {
      emit(TimeTableManagerError('Failed to save timetable: $e'));
    }
  }

  Future<void> deleteTimeTable(String id) async {
    try {
      await timetableRepository.deleteTimeTable(id);
      await loadTimeTables();
    } catch (e) {
      emit(TimeTableManagerError('Failed to delete timetable: $e'));
    }
  }

  void setCurrentTimeTable(TimeTable timetable) {
    if (state is TimeTableManagerLoaded) {
      final current = state as TimeTableManagerLoaded;
      emit(TimeTableManagerLoaded(
        timetables: current.timetables,
        currentTimeTable: timetable,
      ));
    }
  }
}
