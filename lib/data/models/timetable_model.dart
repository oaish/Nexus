import 'package:hive/hive.dart';

import '../../domain/entities/timetable.dart';
import 'timetable_slot_model.dart';

part 'timetable_model.g.dart';

@HiveType(typeId: 2)
class TimeTableModel extends TimeTable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final DateTime lastModified;

  @HiveField(4)
  final Map<String, List<TimeTableSlotModel>> schedule;

  TimeTableModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.lastModified,
    required this.schedule,
  }) : super(
          id: id,
          name: name,
          userId: userId,
          lastModified: lastModified,
          schedule: schedule,
        );

  factory TimeTableModel.fromJson(Map<String, dynamic> json) {
    return TimeTableModel(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      lastModified: DateTime.parse(json['lastModified']),
      schedule: (json['schedule'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((slot) => TimeTableSlotModel.fromJson(slot)).toList(),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'lastModified': lastModified.toIso8601String(),
      'schedule': schedule.map(
        (key, value) => MapEntry(
          key,
          value.map((slot) => slot.toJson()).toList(),
        ),
      ),
    };
  }
}
