import '../../domain/entities/timetable_slot.dart';
import '../../domain/repositories/timetable_view_repository.dart';
import '../datasources/timetable_view_data_source.dart';

class TimeTableViewRepositoryImpl implements TimeTableViewRepository {
  final TimeTableViewDataSource dataSource;

  TimeTableViewRepositoryImpl(this.dataSource);

  @override
  Future<Map<String, List<TimeTableSlot>>> getTimeTable() async {
    return await dataSource.fetchTimeTable();
  }

  @override
  List<TimeTableSlot> getCurrentDay() {
    return dataSource.getCurrentDay();
  }

  @override
  int getCurrentTimeSlotIndex() {
    return dataSource.getCurrentTimeSlotIndex();
  }

  @override
  List<TimeTableSlot> getFromWeekDay(String weekDay) {
    return dataSource.getFromWeekDay(weekDay);
  }
}
