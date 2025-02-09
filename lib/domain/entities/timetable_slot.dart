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
}
