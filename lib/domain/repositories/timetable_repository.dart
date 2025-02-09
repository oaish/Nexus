import 'package:nexus/domain/entities/timetable.dart';

abstract class TimeTableRepository {
  Future<List<TimeTable>> getAllTimeTables();
  Future<void> saveTimeTable(TimeTable timetable);
  Future<void> updateTimeTable(TimeTable timetable);
  Future<void> deleteTimeTable(int id);
}
