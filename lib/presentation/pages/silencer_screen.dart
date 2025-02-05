import 'package:another_dashed_container/another_dashed_container.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/widgets/section_header.dart';

class SilencerScreen extends StatefulWidget {
  const SilencerScreen({super.key});

  @override
  State<SilencerScreen> createState() => _SilencerScreenState();
}

class _SilencerScreenState extends State<SilencerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      child: Column(
        spacing: 20,
        children: [
          const SectionHeader(
            text: 'Rules',
            viewAllButtonEnabled: false,
          ),
          Expanded(child: _emptySection()),
          // Create a new Rule Button
          ElevatedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedPropertyAdd,
                    color: colorScheme.primary,
                    size: 24.0,
                  ),
                  const Text("Create a new rule")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _emptySection() => DashedContainer(
        dashColor: Colors.grey[700]!,
        borderRadius: 16.0,
        dashedLength: 15.0,
        blankLength: 6.0,
        strokeWidth: 3.0,
        child: Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedPlayListRemove,
              color: Colors.grey[400]!,
              size: 32.0,
            ),
            Text(
              "You haven't set any rules yet",
              style: TextStyle(color: Colors.grey[400]!),
            ),
          ],
        ),
      );
}
