import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:nexus/base/utils/app_data.dart';

class TimeTableSlot {
  final String sTime;
  final String eTime;
  final String? subject;
  final String? teacher;
  final String? location;
  final String? activity;
  final String? type;
  final List<SubSlot>? slots;

  TimeTableSlot({
    required this.sTime,
    required this.eTime,
    this.subject,
    this.teacher,
    this.location,
    this.activity,
    this.type,
    this.slots,
  });

  factory TimeTableSlot.fromJson(Map<String, dynamic> json) {
    return TimeTableSlot(
      sTime: json['sTime'],
      eTime: json['eTime'],
      subject: json['subject'],
      teacher: json['teacher'],
      location: json['location'],
      activity: json['activity'],
      slots: json['slots'],
      type: json['type'],
    );
  }

  String toJson() {
    return jsonEncode({
      'sTime': sTime,
      'eTime': eTime,
      'subject': subject,
      'teacher': teacher,
      'location': location,
      'activity': activity,
      'slots': slots,
      'type': type,
    });
  }
}

class TimeTableManager {
  final Map<String, List<TimeTableSlot>> schedule;

  TimeTableManager({required this.schedule});

  // Factory method to create a Timetable from a JSON map
  factory TimeTableManager.fromJson(Map<String, dynamic> json) {
    return TimeTableManager(
      schedule: json.map(
        (day, entries) => MapEntry(
          day,
          (entries as List)
              .map((entry) => TimeTableSlot.fromJson(entry))
              .toList(),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return schedule.map(
      (day, entries) => MapEntry(
        day,
        entries.map((entry) => entry.toJson()).toList(),
      ),
    );
  }

  List<TimeTableSlot> getCurrentDay() {
    // final dayOfTheWeek = DateFormat("EEEE").format(DateTime.now());
    // return schedule[dayOfTheWeek]!;
    return schedule["Wednesday"]!;
  }

  int getCurrentTimeSlotIndex() {
    var timeSlots = getCurrentDay();

    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat("HH:mm");

    for (int i = 0; i < timeSlots.length; i++) {
      DateTime startTime = timeFormat.parse(timeSlots[i].sTime);
      DateTime endTime = timeFormat.parse(timeSlots[i].eTime);

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
}

class SubSlot {
  final String? subject;
  final String? teacher;
  final String? location;
  final String? activity;
  final String? group;

  SubSlot({
    this.subject,
    this.teacher,
    this.location,
    this.activity,
    this.group,
  });
}

TimeTableManager manager = TimeTableManager.fromJson(timeTable);
