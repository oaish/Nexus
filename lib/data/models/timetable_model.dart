import '../../domain/entities/timetable.dart';
import 'timetable_slot_model.dart';

class TimeTableModel extends TimeTable {
  final String id;
  final String name;
  final String userId;
  final String year;
  final String division;
  final String department;
  final DateTime lastModified;
  final Map<String, List<TimeTableSlotModel>> schedule;

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
      department: json['department'],
      year: json['year'],
      division: json['division'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'department': department,
      'year': year,
      'division': division,
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
