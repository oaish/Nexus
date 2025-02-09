import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class NexusBackButton extends StatelessWidget {
  const NexusBackButton({super.key, this.onTap, this.extendedChild, this.isExtended = false});

  final bool isExtended;
  final Function()? onTap;
  final Widget? extendedChild;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Row(
        spacing: 10,
        children: [
          GestureDetector(
            onTap: onTap ?? () => Navigator.pop(context),
            child: Container(
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
          ),
          Expanded(
            child: Visibility(
              visible: isExtended,
              child: extendedChild ?? const SizedBox(),
            ),
          )
        ],
      ),
    );
  }
}
