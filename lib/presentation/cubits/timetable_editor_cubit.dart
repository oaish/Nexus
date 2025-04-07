import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/domain/entities/timetable.dart';
import 'package:nexus/presentation/cubits/timetable_editor_state.dart';
import 'package:nexus/presentation/cubits/timetable_manager_cubit.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';

class TimeTableEditorCubit extends Cubit<TimeTableEditorState> {
  final TimeTableManagerCubit _timeTableManagerCubit;

  TimeTableEditorCubit(this._timeTableManagerCubit)
      : super(TimeTableEditorInitial());

  void createTimeTable({
    required String name,
    required String userId,
    required String department,
    required String year,
    required String division,
  }) {
    try {
      emit(TimeTableEditorLoading());

      final newTimeTable = TimeTable(
        id: const Uuid().v4(),
        name: name,
        userId: userId,
        department: department,
        year: year,
        division: division,
        schedule: const {
          'Monday': [],
          'Tuesday': [],
          'Wednesday': [],
          'Thursday': [],
          'Friday': [],
          'Saturday': [],
          'Sunday': [],
        },
        lastModified: DateTime.now(),
        isPublic: false,
      );

      _timeTableManagerCubit.saveTimeTable(newTimeTable);

      emit(TimeTableEditorLoaded(
        timetable: newTimeTable,
        isEditing: false,
      ));
    } catch (e) {
      emit(TimeTableEditorError('Failed to create timetable: $e'));
    }
  }

  void editTimeTable({
    required String id,
    required String name,
    required String userId,
    required String department,
    required String year,
    required String division,
    required Map<String, dynamic> schedule,
  }) {
    try {
      emit(TimeTableEditorLoading());

      final existingTimeTable = TimeTable(
        id: id,
        name: name,
        userId: userId,
        department: department,
        year: year,
        division: division,
        schedule: schedule,
        lastModified: DateTime.now(),
        isPublic: false,
      );

      emit(TimeTableEditorLoaded(
        timetable: existingTimeTable,
        isEditing: true,
      ));
    } catch (e) {
      emit(TimeTableEditorError('Failed to edit timetable: $e'));
    }
  }

  void updateSchedule(Map<String, dynamic> newSchedule) {
    try {
      final currentState = state;
      if (currentState is TimeTableEditorLoaded) {
        final updatedTimeTable = currentState.timetable.copyWith(
          schedule: newSchedule,
          lastModified: DateTime.now(),
        );

        emit(currentState.copyWith(timetable: updatedTimeTable));
      }
    } catch (e) {
      emit(TimeTableEditorError('Failed to update schedule: $e'));
    }
  }

  void saveTimeTable() {
    try {
      final currentState = state;
      if (currentState is TimeTableEditorLoaded) {
        _timeTableManagerCubit.saveTimeTable(currentState.timetable);
        emit(TimeTableEditorInitial());
      }
    } catch (e) {
      emit(TimeTableEditorError('Failed to save timetable: $e'));
    }
  }

  void setPublic(bool isPublic) {
    try {
      final currentState = state;
      if (currentState is TimeTableEditorLoaded) {
        final updatedTimeTable = currentState.timetable.copyWith(
          isPublic: isPublic,
          lastModified: DateTime.now(),
        );

        emit(currentState.copyWith(timetable: updatedTimeTable));
      }
    } catch (e) {
      emit(TimeTableEditorError('Failed to update public status: $e'));
    }
  }

  List<String> getNextTimeSlot(String day, TimeOfDay duration) {
    if (state is! TimeTableEditorLoaded) {
      return ['00:00', '00:00'];
    }

    final current = state as TimeTableEditorLoaded;
    final timetable = current.timetable;
    final daySlots = timetable.schedule[day] ?? [];

    // Get the last inserted slot's eTime or default to "09:00"
    final lastETime =
        daySlots.isNotEmpty ? daySlots.last['eTime'] as String : "09:00";

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

  void addTimeSlot(String day, TimeTableSlotModel slot) {
    try {
      final currentState = state;
      if (currentState is TimeTableEditorLoaded) {
        final timetable = currentState.timetable;
        final updatedSchedule = Map<String, dynamic>.from(timetable.schedule);

        // Initialize the day's slots if it doesn't exist
        if (!updatedSchedule.containsKey(day)) {
          updatedSchedule[day] = [];
        }

        // Add the new slot to the day's slots
        final daySlots =
            List<Map<String, dynamic>>.from(updatedSchedule[day] as List);

        // Convert TimeTableSlotModel to Map<String, dynamic>
        final slotMap = slot.toJson();
        daySlots.add(slotMap);

        // Update the schedule with the new slot
        updatedSchedule[day] = daySlots;

        // Create updated timetable
        final updatedTimeTable = timetable.copyWith(
          schedule: updatedSchedule,
          lastModified: DateTime.now(),
        );

        _timeTableManagerCubit.saveTimeTable(updatedTimeTable);
        // Emit new state
        emit(currentState.copyWith(timetable: updatedTimeTable));
      }
    } catch (e) {
      emit(TimeTableEditorError('Failed to add time slot: $e'));
    }
  }

  void reorderSlot(String day, int oldIndex, int newIndex) {
    try {
      final currentState = state;
      if (currentState is TimeTableEditorLoaded) {
        final timetable = currentState.timetable;
        final updatedSchedule = Map<String, dynamic>.from(timetable.schedule);

        if (updatedSchedule.containsKey(day)) {
          final daySlots =
              List<Map<String, dynamic>>.from(updatedSchedule[day] as List);

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
              int durationMinutes = _calculateDuration(
                daySlots[i]['sTime'] as String,
                daySlots[i]['eTime'] as String,
              );
              String newEndTime =
                  _addMinutesToTime(currentStartTime, durationMinutes);

              daySlots[i] = {
                ...daySlots[i],
                'sTime': currentStartTime,
                'eTime': newEndTime,
              };
              currentStartTime =
                  newEndTime; // Next slot starts from the last slot's end time
            }

            updatedSchedule[day] = daySlots;

            final updatedTimeTable = timetable.copyWith(
              schedule: updatedSchedule,
              lastModified: DateTime.now(),
            );

            emit(currentState.copyWith(timetable: updatedTimeTable));
          }
        }
      }
    } catch (e) {
      emit(TimeTableEditorError('Failed to reorder slot: $e'));
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

  void deleteTimeSlot(String day, int index) {
    try {
      final currentState = state;
      if (currentState is TimeTableEditorLoaded) {
        final timetable = currentState.timetable;
        final updatedSchedule = Map<String, dynamic>.from(timetable.schedule);

        if (updatedSchedule.containsKey(day)) {
          final daySlots =
              List<Map<String, dynamic>>.from(updatedSchedule[day] as List);

          if (index >= 0 && index < daySlots.length) {
            // Remove the slot at the specified index
            daySlots.removeAt(index);

            // Update the schedule
            updatedSchedule[day] = daySlots;

            // Create updated timetable
            final updatedTimeTable = timetable.copyWith(
              schedule: updatedSchedule,
              lastModified: DateTime.now(),
            );

            // Save the updated timetable
            _timeTableManagerCubit.saveTimeTable(updatedTimeTable);

            // Emit new state
            emit(currentState.copyWith(timetable: updatedTimeTable));
          }
        }
      }
    } catch (e) {
      emit(TimeTableEditorError('Failed to delete time slot: $e'));
    }
  }
}
