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
    _pageController = PageController(initialPage: 0);
    int previousPageIndex = 0;

    return Expanded(
      child: BlocBuilder<TimeTableEditorCubit, TimeTableEditorState>(
        builder: (context, state) {
          final current = context.read<TimeTableEditorCubit>().state as TimeTableEditorLoaded;
          final schedule = current.timetable.schedule;
          print(schedule['Monday']![0].subject);
          return PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
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
              final int? length = schedule[weekDays[weekIndex]]?.length;
              return Padding(
                padding: const EdgeInsets.all(0),
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    context.read<TimeTableEditorCubit>().reorderSlot(weekDays[weekIndex], oldIndex, newIndex);
                  },
                  children: List.generate(schedule[weekDays[weekIndex]]!.isNotEmpty ? length! : 1, (dayIndex) {
                    if (schedule[weekDays[weekIndex]]!.isEmpty) {
                      return const NoSlotTile(
                        key: ValueKey('NoSlot'),
                      );
                    } else {
                      return BlocBuilder<BatchCubit, BatchState>(
                        key: ValueKey('$dayIndex'),
                        builder: (context, batchState) {
                          final current = batchState as BatchLoaded;
                          return ReorderableTimeSlotTile(
                            slot: schedule[weekDays[weekIndex]]![dayIndex],
                            index: dayIndex,
                            batchIndex: current.batchIndex,
                            groupIndex: current.groupIndex,
                          );
                        },
                      );
                    }
                  }),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
