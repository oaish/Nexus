import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/base/app_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.text, this.onTap});

  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: TextStyles.titleMedium.copyWith(fontSize: 20)),
        GestureDetector(
          onTap: onTap,
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedSquareArrowRight01,
            color: Colors.white70,
            size: 24.0,
          ),
        )
      ],
    );
  }
}
