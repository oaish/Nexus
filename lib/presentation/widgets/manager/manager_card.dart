import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_styles.dart';

class ManagerCard extends StatelessWidget {
  const ManagerCard({super.key, required this.icon, required this.cardText, required this.accentColor, this.onTap});
  final IconData icon;
  final String cardText;
  final Color? accentColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.35; // 20% of screen width
    iconSize = iconSize.clamp(25, 110);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: accentColor?.withAlpha(200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          spacing: 5,
          children: [
            HugeIcon(
              icon: icon,
              color: Colors.white,
              size: iconSize,
            ),
            Text(
              cardText,
              style: TextStyles.titleLarge.copyWith(
                fontFamily: 'NovaFlat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
