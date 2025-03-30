import 'package:hive/hive.dart';
import 'package:nexus/data/models/timetable_model.dart';

class TimeTableLocalDataSource {
  static const String boxName = 'timetables';

  Future<Box<TimeTableModel>> _openBox() async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        return await Hive.openBox<TimeTableModel>(boxName);
      }
      return Hive.box<TimeTableModel>(boxName);
    } catch (e) {
      throw Exception('Failed to open timetables box: $e');
    }
  }

  Future<List<TimeTableModel>> getAllTimeTables() async {
    try {
      final box = await _openBox();
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to get timetables: $e');
    }
  }

  Future<TimeTableModel?> getTimeTable(int id) async {
    try {
      final box = await _openBox();
      return box.get(id);
    } catch (e) {
      throw Exception('Failed to get timetable: $e');
    }
  }

  Future<void> saveTimeTable(TimeTableModel timetable) async {
    try {
      final box = await _openBox();
      await box.put(timetable.id, timetable);
    } catch (e) {
      throw Exception('Failed to save timetable: $e');
    }
  }

  Future<void> deleteTimeTable(int id) async {
    try {
      final box = await _openBox();
      await box.delete(id);
    } catch (e) {
      throw Exception('Failed to delete timetable: $e');
    }
  }

  Future<void> closeBox() async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        final box = await _openBox();
        await box.close();
      }
    } catch (e) {
      throw Exception('Failed to close timetables box: $e');
    }
  }
}
