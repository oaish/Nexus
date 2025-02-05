import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class NexusBackButton extends StatelessWidget {
  const NexusBackButton({super.key, this.isOnlyBackButtonContainer = true});
  final bool isOnlyBackButtonContainer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: colorScheme.onPrimary,
                size: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
