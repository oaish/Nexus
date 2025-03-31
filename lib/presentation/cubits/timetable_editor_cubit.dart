// lib/presentation/cubits/timetable_editor_cubit.dart
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/utils/timetable_extensions.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';
import 'package:nexus/domain/entities/timetable.dart';
import 'package:nexus/domain/entities/timetable_slot.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:uuid/uuid.dart';

import 'timetable_editor_state.dart';

class TimeTableEditorCubit extends Cubit<TimeTableEditorState> {
  TimeTableEditorCubit() : super(TimeTableEditorInitial());

  /// Creates a new timetable with default schedule.
  void createTimeTable({
    required String name,
    required String userId,
    required String department,
    required String year,
    required String division,
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

    final schedule =
        <String, List<TimeTableSlotModel>>{}.fromJson(jsonEncode(timeTable));

    final timetable = TimeTable(
      id: const Uuid().v4(),
      name: name,
      userId: userId,
      schedule: schedule,
      lastModified: DateTime.now(),
      department: department,
      year: year,
      division: division,
    );

    emit(TimeTableEditorLoaded(timetable));
  }

  /// Edits an existing timetable.
  void editTimeTable({
    required String id,
    required String name,
    required String userId,
    required String department,
    required String year,
    required String division,
    required Map<String, List<TimeTableSlot>> schedule,
  }) {
    final timetable = TimeTable(
      id: id,
      name: name,
      userId: userId,
      schedule: schedule,
      lastModified: DateTime.now(),
      department: department,
      year: year,
      division: division,
    );

    emit(TimeTableEditorLoaded(timetable));
  }

  /// Adds a new time slot for the specified day.
  void addTimeSlot(String day, TimeTableSlot slot) {
    if (state is TimeTableEditorLoaded) {
      final current = state as TimeTableEditorLoaded;
      final timetable = current.timetable;
      final updatedSchedule =
          Map<String, List<TimeTableSlot>>.from(timetable.schedule);
      final daySlots = List<TimeTableSlot>.from(updatedSchedule[day] ?? []);
      daySlots.add(slot);
      updatedSchedule[day] = daySlots;
      final updatedTimeTable = TimeTable(
        id: timetable.id,
        name: timetable.name,
        userId: timetable.userId,
        schedule: updatedSchedule,
        lastModified: DateTime.now(),
        department: timetable.department,
        year: timetable.year,
        division: timetable.division,
      );
      emit(TimeTableEditorLoaded(updatedTimeTable));
    }
  }

  /// Updates the current timetable with modifications.
  void updateTimeTable(TimeTable updatedTimeTable) {
    emit(TimeTableEditorLoaded(updatedTimeTable));
  }

  List<String> getNextTimeSlot(String day, TimeOfDay duration) {
    if (state is! TimeTableEditorLoaded) {
      return ['00:00', '00:00'];
    }

    final current = state as TimeTableEditorLoaded;
    final timetable = current.timetable;
    final daySlots = timetable.schedule[day] ?? [];

    // Get the last inserted slot's eTime or default to "09:00"
    final lastETime = daySlots.isNotEmpty ? daySlots.last.eTime : "09:00";

    // Convert lastETime to TimeOfDay
    final lastETimeParts = lastETime.split(':');
    final lastTime = TimeOfDay(
      hour: int.parse(lastETimeParts[0]),
      minute: int.parse(lastETimeParts[1]),
    );

    // Calculate the new end time
    final newTime = lastTime.replacing(
      hour: (lastTime.hour + duration.hour) % 24,
      minute: (lastTime.minute + duration.minute) % 60,
    );

    // Format new time
    final newETime =
        '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';

    return [lastETime, newETime];
  }

  void reorderSlot(String day, int oldIndex, int newIndex) {
    if (state is TimeTableEditorLoaded) {
      final current = state as TimeTableEditorLoaded;
      final timetable = current.timetable;
      final updatedSchedule =
          Map<String, List<TimeTableSlot>>.from(timetable.schedule);

      if (updatedSchedule.containsKey(day)) {
        final daySlots = List<TimeTableSlot>.from(updatedSchedule[day]!);

        if (oldIndex < daySlots.length && newIndex <= daySlots.length) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }

          // Move the slot
          final movedSlot = daySlots.removeAt(oldIndex);
          daySlots.insert(newIndex, movedSlot);

          // Keep the first slot's start time unchanged
          const String firstSlotStartTime = "9:00"; // Fixed start time
          String currentStartTime = firstSlotStartTime;

          // Recalculate times for all slots
          for (int i = 0; i < daySlots.length; i++) {
            int durationMinutes =
                _calculateDuration(daySlots[i].sTime, daySlots[i].eTime);
            String newEndTime =
                _addMinutesToTime(currentStartTime, durationMinutes);

            daySlots[i] = daySlots[i]
                .copyWith(sTime: currentStartTime, eTime: newEndTime);
            currentStartTime =
                newEndTime; // Next slot starts from the last slot's end time
          }

          updatedSchedule[day] = daySlots;

          final updatedTimeTable = TimeTable(
            id: timetable.id,
            name: timetable.name,
            userId: timetable.userId,
            schedule: updatedSchedule,
            lastModified: DateTime.now(),
            department: timetable.department,
            year: timetable.year,
            division: timetable.division,
          );

          emit(TimeTableEditorLoaded(updatedTimeTable));
        }
      }
    }
  }

  int _calculateDuration(String startTime, String endTime) {
    DateTime sTime = _parseTime(startTime);
    DateTime eTime = _parseTime(endTime);
    return eTime.difference(sTime).inMinutes;
  }

  String _addMinutesToTime(String time, int minutes) {
    DateTime parsedTime = _parseTime(time).add(Duration(minutes: minutes));
    return "${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}";
  }

  DateTime _parseTime(String time) {
    List<String> parts = time.split(":");
    return DateTime(0, 0, 0, int.parse(parts[0]), int.parse(parts[1]));
  }
}
