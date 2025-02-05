import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.text,
    this.onTap,
    this.viewAllButtonEnabled = true,
  });

  final String text;
  final Function()? onTap;

  final bool viewAllButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: TextStyles.titleMedium.copyWith(fontSize: 20)),
        Visibility(
          visible: viewAllButtonEnabled,
          child: GestureDetector(
            onTap: onTap,
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedSquareArrowRight01,
              color: Colors.white70,
              size: 24.0,
            ),
          ),
        )
      ],
    );
  }
}
