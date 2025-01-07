import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppMedia {
  static const baseImage = 'assets/images';
  static const appIcon = 'assets/images/icons/app_icon.png';

  static authIcon({required Color color, required double size}) => HugeIcon(
        icon: HugeIcons.strokeRoundedFingerprintScan,
        color: color,
        size: size,
      );
}
