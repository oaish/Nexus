import 'package:flutter/material.dart';
import 'package:nexus/presentation/widgets/editor/editor_nexus_back_btn.dart';
import 'package:nexus/presentation/widgets/editor/editor_slot_table.dart';
import 'package:nexus/presentation/widgets/week_buttons_grid.dart';

class TimeTableEditorScreen extends StatelessWidget {
  const TimeTableEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // TODO: NexusBackButton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: EditorNexusBackBtn(),
            ),

            // TODO: WeekButton
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: WeekButtonsGrid(weekLength: 7),
            ),

            EditorSlotTable(),
          ],
        ),
      ),
    );
  }
}
