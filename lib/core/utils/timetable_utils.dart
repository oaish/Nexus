import 'package:intl/intl.dart';
import 'package:nexus/core/constants/app_data.dart';

class TimeTableUtils {
  static int getCurrentDayIndex() {
    return weekDays.indexOf(DateFormat('EEEE').format(DateTime.now()));
  }
}
