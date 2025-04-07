import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/presentation/cubits/batch_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_editor_state.dart';
import 'package:nexus/presentation/cubits/week_cubit.dart';
import 'package:nexus/presentation/widgets/editor/reorderable_time_slot.dart';

class EditorSlotTable extends StatelessWidget {
  EditorSlotTable({super.key});

  late final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    final currentDay = context.read<WeekCubit>().state.selectedDay;
    _pageController = PageController(initialPage: weekDays.indexOf(currentDay));
    int previousPageIndex = 0;

    return Expanded(
      child: BlocBuilder<TimeTableEditorCubit, TimeTableEditorState>(
        builder: (context, state) {
          final current = context.read<TimeTableEditorCubit>().state
              as TimeTableEditorLoaded;
          final schedule = current.timetable.schedule;
          return PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            onPageChanged: (int pageIndex) {
              // if (!isProgrammaticChange) {
              if (pageIndex > previousPageIndex) {
                context.read<WeekCubit>().nextDay();
              } else if (pageIndex < previousPageIndex) {
                context.read<WeekCubit>().previousDay();
              }
              // }
              previousPageIndex = pageIndex;
            },
            children: List.generate(schedule.length, (weekIndex) {
              final int length = schedule[weekDays[weekIndex]]?.length ?? 0;
              return ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  context
                      .read<TimeTableEditorCubit>()
                      .reorderSlot(weekDays[weekIndex], oldIndex, newIndex);
                },
                children: List.generate(length == 0 ? 1 : length, (dayIndex) {
                  return BlocBuilder<BatchCubit, BatchState>(
                    key: ValueKey('$dayIndex'),
                    builder: (context, batchState) {
                      final current = batchState as BatchLoaded;
                      if (length == 0) {
                        return EditorNoSlotTile(weekDays[weekIndex]);
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0.0),
                        child: ReorderableTimeSlotTile(
                          slot: schedule[weekDays[weekIndex]]![dayIndex],
                          index: dayIndex,
                          batchIndex: current.batchIndex,
                          groupIndex: current.groupIndex,
                        ),
                      );
                    },
                  );
                }),
              );
            }),
          );
        },
      ),
    );
  }
}
