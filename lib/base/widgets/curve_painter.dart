import 'package:flutter/cupertino.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 150;
    final double yScaling = size.height / 100;
    path.lineTo(150 * xScaling, 75 * yScaling);
    path.cubicTo(
      143 * xScaling,
      75.8 * yScaling,
      136 * xScaling,
      76.6 * yScaling,
      130.2 * xScaling,
      74 * yScaling,
    );
    path.cubicTo(
      124.3 * xScaling,
      71.4 * yScaling,
      119.7 * xScaling,
      65.5 * yScaling,
      114.5 * xScaling,
      61.5 * yScaling,
    );
    path.cubicTo(
      109.3 * xScaling,
      57.4 * yScaling,
      103.6 * xScaling,
      55.2 * yScaling,
      98.4 * xScaling,
      51.6 * yScaling,
    );
    path.cubicTo(
      93.1 * xScaling,
      48 * yScaling,
      88.3 * xScaling,
      43 * yScaling,
      85.9 * xScaling,
      37 * yScaling,
    );
    path.cubicTo(
      83.6 * xScaling,
      31 * yScaling,
      83.8 * xScaling,
      24.2 * yScaling,
      83.4 * xScaling,
      17.9 * yScaling,
    );
    path.cubicTo(
      83 * xScaling,
      11.5 * yScaling,
      82 * xScaling,
      5.8 * yScaling,
      81 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      81 * xScaling,
      0 * yScaling,
      150 * xScaling,
      0 * yScaling,
      150 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      150 * xScaling,
      0 * yScaling,
      150 * xScaling,
      75 * yScaling,
      150 * xScaling,
      75 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
