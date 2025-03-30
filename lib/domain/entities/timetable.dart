import 'package:nexus/domain/entities/timetable_slot.dart';

class TimeTable {
  final int id;
  final String name;
  final String userId; // Supabase User Id
  final DateTime lastModified;
  final Map<String, List<TimeTableSlot>> schedule;
  final String department;
  final String year;
  final String division;

  TimeTable({
    required this.id,
    required this.name,
    required this.userId,
    required this.schedule,
    required this.lastModified,
    required this.department,
    required this.year,
    required this.division,
  });
}
