import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nexus/app.dart';
import 'package:nexus/core/config/supabase_config.dart';
import 'package:nexus/core/utils/window_resize_utils.dart';
import 'package:nexus/data/datasources/timetable_local_data_source.dart';
import 'package:nexus/data/models/sub_slot_model.dart';
import 'package:nexus/data/models/timetable_model.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';
import 'package:nexus/data/repositories/timetable_repository_impl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:window_manager/window_manager.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  await dotenv.load(fileName: ".env");

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(350, 600),
      center: true,
      title: 'Nexus',
      skipTaskbar: false,
      backgroundColor: Colors.transparent,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      snapWindow('Nexus');
    });
  }

  final appDocDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  Hive.registerAdapter(SubSlotModelAdapter());
  Hive.registerAdapter(TimeTableSlotModelAdapter());
  Hive.registerAdapter(TimeTableModelAdapter());

  final localDataSource = TimeTableLocalDataSource();
  final timetableRepository =
      TimeTableRepositoryImpl(localDataSource: localDataSource);

  // Initialize Hive
  await Hive.initFlutter();

  // Open the timetable box
  final timetableBox = await Hive.openBox<TimeTableModel>('timetables');

  // Add debug timetable if none exists
  if (timetableBox.isEmpty) {
    final debugTimetable = TimeTableModel(
      id: const Uuid().v4(),
      name: 'Debug Timetable',
      userId: 'debug_user',
      department: 'COMPS',
      year: 'SE',
      division: 'A',
      lastModified: DateTime.now(),
      schedule: {
        'Monday': [
          TimeTableSlotModel(
            sTime: '09:00',
            eTime: '10:00',
            subject: 'Mathematics',
            teacher: 'Dr. Smith',
            location: '101',
            type: 'Lecture',
          ),
        ],
        'Tuesday': [
          TimeTableSlotModel(
            sTime: '10:00',
            eTime: '11:00',
            subject: 'Physics',
            teacher: 'Dr. Johnson',
            location: '102',
            type: 'Lecture',
          ),
        ],
      },
    );
    await timetableBox.put(debugTimetable.id, debugTimetable);
  }

  runApp(MyApp(timetableRepository: timetableRepository));
}
