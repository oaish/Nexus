import 'package:nexus/data/models/sub_slot_model.dart';

class TimeTableSlot {
  final String sTime;
  final String eTime;
  final String? subject;
  final String? teacher;
  final String? location;
  final String? activity;
  final String? type;
  final List<SubSlotModel>? subSlots;

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
