import 'package:hive/hive.dart';

import '../../domain/entities/timetable.dart';
import 'timetable_slot_model.dart';

part 'timetable_model.g.dart';

@HiveType(typeId: 2)
class TimeTableModel extends TimeTable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final DateTime lastModified;

  @HiveField(4)
  final Map<String, List<TimeTableSlotModel>> schedule;

  @HiveField(5)
  final String department;

  @HiveField(6)
  final String year;

  @HiveField(7)
  final String division;

  TimeTableModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.lastModified,
    required this.schedule,
    required this.department,
    required this.year,
    required this.division,
  }) : super(
          id: id,
          name: name,
          userId: userId,
          lastModified: lastModified,
          schedule: schedule,
          department: department,
          year: year,
          division: division,
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
          (value as List)
              .map((slot) => TimeTableSlotModel.fromJson(slot))
              .toList(),
        ),
      ),
      department: json['department'] ?? 'COMPS',
      year: json['year'] ?? 'SE',
      division: json['division'] ?? 'A',
    );
  }

  factory TimeTableModel.fromSupabase(Map<String, dynamic> json) {
    return TimeTableModel(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      lastModified: DateTime.parse(json['last_modified']),
      department: json['department'],
      year: json['year'],
      division: json['division'],
      schedule: {}, // Load schedule separately
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
      'department': department,
      'year': year,
      'division': division,
    };
  }

  Map<String, dynamic> toSupabase() {
    return {
      'name': name,
      'department': department,
      'year': year,
      'division': division,
      'is_public': false, // Add this if you want to control public access
    };
  }
}
