import 'dart:math';

import 'package:flutter/material.dart';

import 'app_data.dart';

class AppStyles {
  static Color getRandomAccentColor() {
    final Random random = Random();
    return accentColors[random.nextInt(accentColors.length)];
  }
}

class TextStyles {
  static var displayLarge =
      const TextStyle(fontSize: 57, fontWeight: FontWeight.w400);
  static var displayMedium =
      const TextStyle(fontSize: 45, fontWeight: FontWeight.w400);
  static var displaySmall =
      const TextStyle(fontSize: 36, fontWeight: FontWeight.w400);
  static var headlineLarge =
      const TextStyle(fontSize: 32, fontWeight: FontWeight.w400);
  static var headlineMedium =
      const TextStyle(fontSize: 28, fontWeight: FontWeight.w400);
  static var headlineSmall =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
  static var titleLarge =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static var titleMedium =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static var titleSmall =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static var bodyLarge =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static var bodyMedium =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static var bodySmall =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  static var labelLarge =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static var labelMedium =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
  static var labelSmall =
      const TextStyle(fontSize: 11, fontWeight: FontWeight.w500);
}
