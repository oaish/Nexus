// lib/data/repositories/timetable_repository_impl.dart
import 'package:nexus/data/datasources/timetable_local_data_source.dart';
import 'package:nexus/data/models/timetable_model.dart';
import 'package:nexus/domain/entities/timetable.dart';
import 'package:nexus/domain/repositories/timetable_repository.dart';

class TimeTableRepositoryImpl implements TimeTableRepository {
  final TimeTableLocalDataSource localDataSource;

  TimeTableRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TimeTable>> getAllTimeTables() async {
    final models = await localDataSource.getAllTimeTables();
    return models;
  }

  @override
  Future<void> saveTimeTable(TimeTable timetable) async {
    if (timetable is TimeTableModel) {
      await localDataSource.saveTimeTable(timetable);
    } else {
      // Convert to model if necessary.
      final model = TimeTableModel(
        id: timetable.id,
        name: timetable.name,
        userId: timetable.userId,
        lastModified: timetable.lastModified,
        schedule: timetable.schedule.map((key, value) {
          // Assume timetable.schedule already contains model objects.
          return MapEntry(key, value.cast());
        }),
        department: timetable.department,
        year: timetable.year,
        division: timetable.division,
      );
      await localDataSource.saveTimeTable(model);
    }
  }

  @override
  Future<void> updateTimeTable(TimeTable timetable) async {
    await saveTimeTable(timetable);
  }

  @override
  Future<void> deleteTimeTable(String id) async {
    try {
      await localDataSource.deleteTimeTable(id);
    } catch (e) {
      throw Exception('Failed to delete timetable: $e');
    }
  }
}
