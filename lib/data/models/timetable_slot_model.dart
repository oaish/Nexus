import '../../domain/entities/timetable_slot.dart';
import 'sub_slot_model.dart';

class TimeTableSlotModel extends TimeTableSlot {
  final String sTime;

  final String eTime;

  final String? subject;

  final String? teacher;

  final String? location;

  final String? activity;

  final String? type;

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
          ? (json['subSlots'] as List)
              .map((slot) => SubSlotModel.fromJson(slot))
              .toList()
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
