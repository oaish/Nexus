import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:win32/win32.dart';

void snapWindow(String windowTitle) {
  // Get the handle to the current window
  final hwnd = FindWindow(nullptr, windowTitle.toNativeUtf16());
  if (hwnd == 0) {
    if (kDebugMode) {
      print("Window with title '$windowTitle' not found.");
    }
    return;
  }

  // Get the monitor that the window is currently on
  final monitorHandle =
      MonitorFromWindow(hwnd, MONITOR_FROM_FLAGS.MONITOR_DEFAULTTONEAREST);
  final monitorInfo = calloc<MONITORINFO>();

  monitorInfo.ref.cbSize = sizeOf<MONITORINFO>();

  if (GetMonitorInfo(monitorHandle, monitorInfo) == 0) {
    if (kDebugMode) {
      print("Failed to get monitor info.");
    }
    return;
  }

  // Get screen dimensions excluding taskbar (work area)
  final workArea = monitorInfo.ref.rcWork;
  final screenWidth = workArea.right - workArea.left;
  final screenHeight = workArea.bottom - workArea.top;

  // Define position and size based on the snap position
  int width = 500;
  int height = screenHeight + 8;
  int x = screenWidth - width + 8;
  int y = 0;

  // Move and resize the window
  SetWindowPos(hwnd, 0, x, y, width, height,
      SET_WINDOW_POS_FLAGS.SWP_NOZORDER | SET_WINDOW_POS_FLAGS.SWP_SHOWWINDOW);

  calloc.free(monitorInfo); // Clean up memory allocation
}
