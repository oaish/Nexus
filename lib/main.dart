import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nexus/app.dart';
import 'package:nexus/core/config/supabase_config.dart';
import 'package:nexus/core/utils/window_resize_utils.dart';
import 'package:window_manager/window_manager.dart';

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

  runApp(const MyApp());
}
