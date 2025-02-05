import 'package:nexus/domain/entities/timetable_slot.dart';

abstract class TimeTableRepository {
  Future<Map<String, List<TimeTableSlot>>> getTimeTable();
  List<TimeTableSlot> getCurrentDay();
  List<TimeTableSlot> getFromWeekDay(String weekDay);
  int getCurrentTimeSlotIndex();
}
