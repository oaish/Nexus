// lib/presentation/cubits/timetable_editor_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:nexus/domain/entities/timetable.dart';
import 'package:nexus/domain/entities/timetable_slot.dart';

import 'timetable_editor_state.dart';

class TimeTableEditorCubit extends Cubit<TimeTableEditorState> {
  TimeTableEditorCubit() : super(TimeTableEditorInitial());

  /// Creates a new timetable with default schedule.
  void createTimeTable({
    required int id,
    required String name,
    required String userId,
  }) {
    final defaultSchedule = {
      'Monday': <TimeTableSlot>[],
      'Tuesday': <TimeTableSlot>[],
      'Wednesday': <TimeTableSlot>[],
      'Thursday': <TimeTableSlot>[],
      'Friday': <TimeTableSlot>[],
      'Saturday': <TimeTableSlot>[],
      'Sunday': <TimeTableSlot>[],
    };

    final timetable = TimeTable(
      id: id,
      name: name,
      userId: userId,
      schedule: defaultSchedule,
      lastModified: DateTime.now(),
    );

    emit(TimeTableEditorLoaded(timetable));
  }

  /// Adds a new time slot for the specified day.
  void addTimeSlot(String day, TimeTableSlot slot) {
    if (state is TimeTableEditorLoaded) {
      final current = state as TimeTableEditorLoaded;
      final timetable = current.timetable;
      final updatedSchedule = Map<String, List<TimeTableSlot>>.from(timetable.schedule);
      final daySlots = List<TimeTableSlot>.from(updatedSchedule[day] ?? []);
      daySlots.add(slot);
      updatedSchedule[day] = daySlots;
      final updatedTimeTable = TimeTable(
        id: timetable.id,
        name: timetable.name,
        userId: timetable.userId,
        schedule: updatedSchedule,
        lastModified: DateTime.now(),
      );
      emit(TimeTableEditorLoaded(updatedTimeTable));
    }
  }

  /// Updates the current timetable with modifications.
  void updateTimeTable(TimeTable updatedTimeTable) {
    emit(TimeTableEditorLoaded(updatedTimeTable));
  }

  /// Reorders the slot for the specified day.
  ///
  /// This function removes the provided [slot] (if it exists) from the day's slot list,
  /// inserts it at the specified [index], and then recalculates the consecutive sTime and eTime
  /// fields for that slot and all subsequent slots.
  ///
  /// Example:
  /// Given JSON sample slots:
  ///   {"sTime": "15:00", "eTime": "16:00", ...}
  ///   {"sTime": "16:00", "eTime": "17:00", ...}
  /// If you insert a slot at index 0, the first slot’s sTime remains (or is set to a default)
  /// and each subsequent slot gets its sTime equal to the previous slot’s eTime.
  void reorderSlot(String day, int index, TimeTableSlot slot) {
    if (state is TimeTableEditorLoaded) {
      final current = state as TimeTableEditorLoaded;
      final timetable = current.timetable;
      final updatedSchedule = Map<String, List<TimeTableSlot>>.from(timetable.schedule);
      final slots = List<TimeTableSlot>.from(updatedSchedule[day] ?? []);

      // Remove any existing instance of the slot.
      slots.removeWhere((s) => s == slot);

      // Insert the slot at the desired index.
      slots.insert(index, slot);

      // Determine the starting time for recalculation.
      // If index > 0, use the previous slot's eTime; otherwise, use the inserted slot's original sTime.
      String previousEndTime;
      if (index > 0) {
        previousEndTime = slots[index - 1].eTime;
      } else {
        previousEndTime = slot.sTime;
      }

      // Recalculate the sTime and eTime for the slot at the given index and all subsequent slots.
      for (int i = index; i < slots.length; i++) {
        final currentSlot = slots[i];
        final duration = _getDuration(currentSlot.sTime, currentSlot.eTime);
        final newSTime = previousEndTime;
        final newETime = _addDuration(newSTime, duration);

        // Replace the slot with an updated instance having the new times.
        slots[i] = TimeTableSlot(
          sTime: newSTime,
          eTime: newETime,
          subject: currentSlot.subject,
          teacher: currentSlot.teacher,
          location: currentSlot.location,
          activity: currentSlot.activity,
          type: currentSlot.type,
          subSlots: currentSlot.subSlots,
        );
        previousEndTime = newETime;
      }

      updatedSchedule[day] = slots;
      final updatedTimeTable = TimeTable(
        id: timetable.id,
        name: timetable.name,
        userId: timetable.userId,
        schedule: updatedSchedule,
        lastModified: DateTime.now(),
      );
      emit(TimeTableEditorLoaded(updatedTimeTable));
    }
  }

  // ------------------------
  // Helper Functions
  // ------------------------

  /// Parses a time string in "HH:mm" format to a DateTime (using a dummy date).
  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(2000, 1, 1, hour, minute);
  }

  /// Formats a DateTime as a time string in "HH:mm" format.
  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Returns the duration between [sTime] and [eTime].
  Duration _getDuration(String sTime, String eTime) {
    final start = _parseTime(sTime);
    final end = _parseTime(eTime);
    return end.difference(start);
  }

  /// Adds [duration] to the time represented by [sTime] and returns the new time string.
  String _addDuration(String sTime, Duration duration) {
    final start = _parseTime(sTime);
    final newTime = start.add(duration);
    return _formatTime(newTime);
  }
}
