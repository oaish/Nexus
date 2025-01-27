import 'package:flutter/services.dart';

const platform = MethodChannel('com.mercenary.nexus/scheduler');

Future<void> scheduleAlarm(int hour, int minute, int requestCode) async {
  try {
    await platform.invokeMethod('scheduleAlarm', {
      'hour': hour,
      'minute': minute,
      'requestCode': requestCode,
    });
  } on PlatformException catch (e) {
    print("Failed to schedule alarm: ${e.message}");
  }
}
