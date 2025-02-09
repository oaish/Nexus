import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nexus/app.dart';
import 'package:nexus/core/utils/window_resize_utils.dart';
import 'package:nexus/data/datasources/timetable_local_data_source.dart';
import 'package:nexus/data/models/sub_slot_model.dart';
import 'package:nexus/data/models/timetable_model.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';
import 'package:nexus/data/repositories/timetable_repository_impl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final timetableRepository = TimeTableRepositoryImpl(localDataSource: localDataSource);

  runApp(MyApp(timetableRepository: timetableRepository));
}
