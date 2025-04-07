import 'package:nexus/domain/entities/sub_slot.dart';

class TimeTableSlot {
  final String sTime;
  final String eTime;
  final String? subject;
  final String? teacher;
  final String? location;
  final String? activity;
  final String? type;
  final List<SubSlot>? subSlots;

  TimeTableSlot({
    required this.sTime,
    required this.eTime,
    this.subject,
    this.teacher,
    this.location,
    this.activity,
    this.type,
    this.subSlots,
  });

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
