import 'package:nexus/domain/entities/timetable_slot.dart';

abstract class TimeTableViewRepository {
  Future<Map<String, List<TimeTableSlot>>> getTimeTable();
  Future<List<TimeTableSlot>> getCurrentDay();
  Future<List<TimeTableSlot>> getFromWeekDay(String weekDay);
  Future<int> getCurrentTimeSlotIndex();
}
