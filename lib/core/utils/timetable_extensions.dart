import 'dart:convert';

import 'package:nexus/data/models/timetable_slot_model.dart';
import 'package:nexus/domain/entities/sub_slot.dart';
import 'package:nexus/domain/entities/timetable_slot.dart';

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

extension TimeTableSlotCopy on TimeTableSlot {
  TimeTableSlot copyWith({
    String? sTime,
    String? eTime,
    String? subject,
    String? teacher,
    String? location,
    String? activity,
    String? type,
    List<SubSlot>? subSlots,
  }) {
    return TimeTableSlot(
      sTime: sTime ?? this.sTime,
      eTime: eTime ?? this.eTime,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      location: location ?? this.location,
      activity: activity ?? this.activity,
      type: type ?? this.type,
      subSlots: subSlots ?? this.subSlots,
    );
  }
}
