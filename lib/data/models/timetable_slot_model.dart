import 'package:hive/hive.dart';

import '../../domain/entities/timetable_slot.dart';
import 'sub_slot_model.dart';

part 'timetable_slot_model.g.dart';

@HiveType(typeId: 1)
class TimeTableSlotModel extends TimeTableSlot {
  @HiveField(0)
  final String sTime;

  @HiveField(1)
  final String eTime;

  @HiveField(2)
  final String? subject;

  @HiveField(3)
  final String? teacher;

  @HiveField(4)
  final String? location;

  @HiveField(5)
  final String? activity;

  @HiveField(6)
  final String? type;

  @HiveField(7)
  final List<SubSlotModel>? subSlots;

  TimeTableSlotModel({
    required this.sTime,
    required this.eTime,
    this.subject,
    this.teacher,
    this.location,
    this.activity,
    this.type,
    this.subSlots,
  }) : super(
          sTime: sTime,
          eTime: eTime,
          subject: subject,
          teacher: teacher,
          location: location,
          activity: activity,
          type: type,
          subSlots: subSlots,
        );

  factory TimeTableSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeTableSlotModel(
      sTime: json['sTime'],
      eTime: json['eTime'],
      subject: json['subject'],
      teacher: json['teacher'],
      location: json['location'],
      activity: json['activity'],
      type: json['type'],
      subSlots: json['subSlots'] != null
          ? (json['subSlots'] as List).map((slot) => SubSlotModel.fromJson(slot)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sTime': sTime,
      'eTime': eTime,
      'subject': subject,
      'teacher': teacher,
      'location': location,
      'activity': activity,
      'type': type,
      'subSlots': subSlots?.map((slot) => slot.toJson()).toList(),
    };
  }
}
