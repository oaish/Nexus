import '../../domain/entities/sub_slot.dart';

class SubSlotModel extends SubSlot {
  SubSlotModel({
    super.subject,
    super.teacher,
    super.location,
    super.activity,
    super.batch,
    super.group,
  });

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
