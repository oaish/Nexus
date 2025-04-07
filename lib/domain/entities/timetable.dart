import 'package:equatable/equatable.dart';
import 'package:nexus/domain/entities/timetable_slot.dart';

class TimeTable extends Equatable {
  final String id;
  final String name;
  final String userId;
  final String department;
  final String year;
  final String division;
  final Map<String, dynamic> schedule;
  final DateTime lastModified;
  final bool isPublic;

  const TimeTable({
    required this.id,
    required this.name,
    required this.userId,
    required this.department,
    required this.year,
    required this.division,
    required this.schedule,
    required this.lastModified,
    this.isPublic = false,
  });

  factory TimeTable.fromJson(Map<String, dynamic> json) {
    return TimeTable(
      id: json['id'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      department: json['department'] as String,
      year: json['year'] as String,
      division: json['division'] as String,
      schedule: json['schedule'] as Map<String, dynamic>,
      lastModified: DateTime.parse(json['lastModified'] as String),
      isPublic: json['isPublic'] as bool? ?? false,
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
      'schedule': schedule,
      'lastModified': lastModified.toIso8601String(),
      'isPublic': isPublic,
    };
  }

  TimeTable copyWith({
    String? id,
    String? name,
    String? userId,
    String? department,
    String? year,
    String? division,
    Map<String, dynamic>? schedule,
    DateTime? lastModified,
    bool? isPublic,
  }) {
    return TimeTable(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      department: department ?? this.department,
      year: year ?? this.year,
      division: division ?? this.division,
      schedule: schedule ?? this.schedule,
      lastModified: lastModified ?? this.lastModified,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        userId,
        department,
        year,
        division,
        schedule,
        lastModified,
        isPublic,
      ];
}
