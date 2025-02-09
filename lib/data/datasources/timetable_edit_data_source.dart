import 'dart:convert';

import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/data/models/timetable_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TimeTableEditDataSource {
  Future<TimeTableModel> fetchTimeTable();
}

class TimeTableEditLocalDataSource implements TimeTableEditDataSource {
  TimeTableEditLocalDataSource();

  @override
  Future<TimeTableModel> fetchTimeTable() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('timetable');
    return TimeTableModel.fromJson(jsonString != null ? jsonDecode(jsonString) : defaultTimeTable);
  }
}
