import 'package:nexus/domain/entities/sub_slot.dart';

class SubSlotModel extends SubSlot {
  final String? subject;

  final String? teacher;

  final String? location;

  final String? activity;

  final String? batch;

  final String? group;

  SubSlotModel({
    this.subject,
    this.teacher,
    this.location,
    this.activity,
    this.batch,
    this.group,
  }) : super(
          subject: subject,
          teacher: teacher,
          location: location,
          activity: activity,
          batch: batch,
          group: group,
        );

  factory SubSlotModel.fromJson(Map<String, dynamic> json) {
    return SubSlotModel(
      subject: json['subject'],
      teacher: json['teacher'],
      location: json['location'],
      activity: json['activity'],
      batch: json['batch'],
      group: json['group'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'teacher': teacher,
      'location': location,
      'activity': activity,
      'batch': batch,
      'group': group,
    };
  }
}
