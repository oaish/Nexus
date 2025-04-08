import 'package:flutter/material.dart';

class NexusBackButton extends StatelessWidget {
  final bool isExtended;
  final Widget? extendedChild;
  final VoidCallback? onPressed;

  const NexusBackButton({
    super.key,
    this.isExtended = false,
    this.extendedChild,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF4E7CFF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: primaryColor,
              onPressed: onPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
          if (isExtended && extendedChild != null) ...[
            const SizedBox(width: 12),
            Expanded(child: extendedChild!),
          ],
        ],
      ),
    );
  }
}
