import 'dart:convert';

import 'package:nexus/data/models/timetable_slot_model.dart';

extension TimeTableExtensions on Map<String, List<TimeTableSlotModel>> {
  Map<String, List<TimeTableSlotModel>> fromJson(String json) {
    final Map<String, dynamic> decodedJson = jsonDecode(json);
    return decodedJson.map(
      (day, entries) => MapEntry(
        day,
        (entries as List).map((entry) => TimeTableSlotModel.fromJson(entry)).toList(),
      ),
    );
  }

  String toJson(Map<String, List<TimeTableSlotModel>> schedule) {
    return jsonEncode(schedule.map(
      (day, entries) => MapEntry(
        day,
        entries.map((entry) => entry.toJson()).toList(),
      ),
    ));
  }
}
