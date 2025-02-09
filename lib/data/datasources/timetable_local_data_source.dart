import 'package:hive/hive.dart';
import 'package:nexus/data/models/timetable_model.dart';

class TimeTableLocalDataSource {
  static const String boxName = 'timetables';

  Future<Box> _openBox() async {
    return await Hive.openBox(boxName);
  }

  Future<List<TimeTableModel>> getAllTimeTables() async {
    final box = await _openBox();
    final timetables = <TimeTableModel>[];

    for (var key in box.keys) {
      final json = box.get(key);
      if (json != null) {
        timetables.add(
          TimeTableModel.fromJson(Map<String, dynamic>.from(json)),
        );
      }
    }

    return timetables;
  }

  Future<void> saveTimeTable(TimeTableModel timetable) async {
    final box = await _openBox();
    await box.put(timetable.id, timetable.toJson());
  }

  Future<void> deleteTimeTable(int id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
