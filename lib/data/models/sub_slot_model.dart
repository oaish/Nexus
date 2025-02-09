import 'package:hive/hive.dart';
import 'package:nexus/domain/entities/sub_slot.dart';

part 'sub_slot_model.g.dart';

@HiveType(typeId: 0)
class SubSlotModel extends SubSlot {
  @HiveField(0)
  final String? subject;

  @HiveField(1)
  final String? teacher;

  @HiveField(2)
  final String? location;

  @HiveField(3)
  final String? activity;

  @HiveField(4)
  final String? batch;

  @HiveField(5)
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
