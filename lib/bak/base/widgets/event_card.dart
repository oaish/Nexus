import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/base/app_styles.dart';
import 'package:nexus/base/widgets/curve_painter.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.deepColor,
    required this.color,
    required this.index,
    required this.size,
    required this.hugeIcon,
    required this.iconSize,
    required this.date,
  });
  final int index;
  final Size size;
  final Color color;
  final DateTime date;
  final Color deepColor;
  final double iconSize;
  final IconData hugeIcon;

  _appendZero() {
    if (index < 10) {
      return '0$index';
    } else {
      return '$index';
    }
  }

  _extractDate() {
    var day = date.day.toString().padLeft(2, '0');

    List<String> monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    var month = monthNames[date.month - 1];

    return [day, month];
  }

  @override
  Widget build(BuildContext context) {
    var [day, month] = _extractDate();
    return Hero(
      tag: 'Event Card $index',
      child: Container(
        width: size.width,
        height: size.height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: color.withAlpha(100),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // _contentSection(day, month),
            _clipPathSection(),
          ],
        ),
      ),
    );
  }

  _contentSection(day, month) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: double.infinity,
          child: Row(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                day,
                style: TextStyles.displayLarge.copyWith(
                  fontSize: 53,
                  fontWeight: FontWeight.w900,
                  // height: 0.9,
                ),
              ),
              Text(
                month,
                style: TextStyles.titleMedium
                    .copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      );

  _clipPathSection() => Positioned(
        top: 0,
        left: 0,
        width: size.width,
        height: size.height,
        child: ClipPath(
          clipper: CurveClipper(),
          child: Container(
            color: deepColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 12.0,
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Visibility(
                  visible: iconSize == 32.0,
                  child: HugeIcon(
                    icon: hugeIcon,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
