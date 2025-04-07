import 'package:nexus/domain/entities/timetable.dart';

abstract class TimeTableRepository {
  Future<List<TimeTable>> getAllTimeTables();
  Future<TimeTable?> getTimeTable(String id);
  Future<void> saveTimeTable(TimeTable timetable);
  Future<void> updateTimeTable(TimeTable timetable);
  Future<void> deleteTimeTable(String id);
  Future<TimeTable?> getCurrentTimeTable();
  Future<void> setCurrentTimeTable(String id);
}
