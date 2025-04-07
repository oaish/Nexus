import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/presentation/cubits/week_cubit.dart';
import 'package:nexus/presentation/widgets/editor/add_time_slot.dart';
import 'package:nexus/presentation/widgets/editor/editor_nexus_back_btn.dart';
import 'package:nexus/presentation/widgets/editor/editor_slot_table.dart';
import 'package:nexus/presentation/widgets/week_buttons_grid.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TimeTableEditorScreen extends StatelessWidget {
  const TimeTableEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: mat.Scaffold(
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
        floatingActionButton: mat.FloatingActionButton(
          backgroundColor: const Color(0xff7ed1d7),
          foregroundColor: const Color(0xff1a1a1a),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                final String weekDay =
                    context.read<WeekCubit>().state.selectedDay;
                return AlertDialog(
                  title: Text.rich(
                    TextSpan(
                      text: 'Add Timeslot for ',
                      style: TextStyles.titleLarge
                          .copyWith(fontFamily: 'NovaFlat'),
                      children: [
                        TextSpan(
                          text: weekDay,
                          style: TextStyles.titleLarge.copyWith(
                            fontFamily: 'NovaFlat',
                            color: const Color(
                                0xff80d4da), // Custom color for the day
                          ),
                        ),
                      ],
                    ),
                  ),
                  content: AddTimeSlot(weekDay),
                );
              },
            );
          },
          child: const Icon(
            Icons.add,
            size: 32,
          ),
        ),
      ),
    );
  }
}
