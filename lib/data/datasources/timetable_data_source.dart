import 'package:intl/intl.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';

abstract class TimeTableDataSource {
  Future<Map<String, List<TimeTableSlotModel>>> fetchTimeTable();
  List<TimeTableSlotModel> getCurrentDay();
  List<TimeTableSlotModel> getFromWeekDay(String weekDay);
  int getCurrentTimeSlotIndex();
}

class TimeTableLocalDataSource implements TimeTableDataSource {
  final Map<String, List<TimeTableSlotModel>> schedule;

  TimeTableLocalDataSource({required this.schedule});

  @override
  Future<Map<String, List<TimeTableSlotModel>>> fetchTimeTable() async {
    return schedule;
  }

  @override
  List<TimeTableSlotModel> getCurrentDay() {
    final dayOfTheWeek = DateFormat("EEEE").format(DateTime.now());
    return schedule[dayOfTheWeek] ?? [];
  }

  @override
  int getCurrentTimeSlotIndex() {
    var timeSlots = getCurrentDay();

    DateTime now = DateTime.now();
    for (int i = 0; i < timeSlots.length; i++) {
      DateTime startTime = DateFormat("HH:mm").parse(timeSlots[i].sTime);
      DateTime endTime = DateFormat("HH:mm").parse(timeSlots[i].eTime);

      startTime = DateTime(
          now.year, now.month, now.day, startTime.hour, startTime.minute);
      endTime =
          DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        return i;
      }
    }
    return 0;
  }

  @override
  List<TimeTableSlotModel> getFromWeekDay(String weekDay) {
    const Map<String, String> weekdays = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };
    return schedule[weekdays[weekDay]] ?? [];
  }
}
