// lib/presentation/cubits/timetable_editor_cubit.dart
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/utils/timetable_extensions.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';
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

    final schedule = <String, List<TimeTableSlotModel>>{}.fromJson(jsonEncode(timeTable));

    final timetable = TimeTable(
      id: id,
      name: name,
      userId: userId,
      schedule: schedule,
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

  void reorderSlot(String day, int oldIndex, int newIndex) {
    if (state is TimeTableEditorLoaded) {
      final current = state as TimeTableEditorLoaded;
      final timetable = current.timetable;
      final updatedSchedule = Map<String, List<TimeTableSlot>>.from(timetable.schedule);

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
          final String firstSlotStartTime = "9:00"; // Fixed start time
          String currentStartTime = firstSlotStartTime;

          // Recalculate times for all slots
          for (int i = 0; i < daySlots.length; i++) {
            int durationMinutes = _calculateDuration(daySlots[i].sTime, daySlots[i].eTime);
            String newEndTime = _addMinutesToTime(currentStartTime, durationMinutes);

            daySlots[i] = daySlots[i].copyWith(sTime: currentStartTime, eTime: newEndTime);
            currentStartTime = newEndTime; // Next slot starts from the last slot's end time
          }

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

  void reorderSlot2(String day, int oldIndex, int newIndex) {
    if (state is TimeTableEditorLoaded) {
      final current = state as TimeTableEditorLoaded;
      final timetable = current.timetable;
      final updatedSchedule = Map<String, List<TimeTableSlot>>.from(timetable.schedule);

      if (updatedSchedule.containsKey(day)) {
        final daySlots = List<TimeTableSlot>.from(updatedSchedule[day]!);

        if (oldIndex < daySlots.length && newIndex <= daySlots.length) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }

          final movedSlot = daySlots.removeAt(oldIndex);
          daySlots.insert(newIndex, movedSlot);

          // Update times in sequential order
          for (int i = 0; i < daySlots.length; i++) {
            if (i == 0) {
              // First slot retains its original start time
              continue;
            }
            daySlots[i] = daySlots[i].copyWith(
              sTime: daySlots[i - 1].eTime, // New start time is previous slot's end time
            );
          }

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
    }
  }
}
