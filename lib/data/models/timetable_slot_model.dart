import 'package:nexus/domain/entities/timetable_slot.dart';

import 'sub_slot_model.dart';

class TimeTableSlotModel extends TimeTableSlot {
  TimeTableSlotModel({
    required super.sTime,
    required super.eTime,
    super.subject,
    super.teacher,
    super.location,
    super.activity,
    super.type,
    super.subSlots,
  });

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
