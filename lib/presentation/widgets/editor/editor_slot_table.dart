import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/utils/timetable_extensions.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_editor_state.dart';
import 'package:nexus/presentation/cubits/week_cubit.dart';
import 'package:nexus/presentation/widgets/time_slot_tile.dart';

class EditorSlotTable extends StatelessWidget {
  EditorSlotTable({super.key});

  late final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: 0);
    final schedule = <String, List<TimeTableSlotModel>>{}.fromJson(jsonEncode(timeTable));
    int previousPageIndex = 0;

    return Expanded(
      child: BlocBuilder<TimeTableEditorCubit, TimeTableEditorState>(
        builder: (context, state) {
          if (state != null) {
            // return const SizedBox();
          }

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
                child: ListView.builder(
                  itemCount: schedule[weekDays[weekIndex]]!.isNotEmpty ? length : 1,
                  itemBuilder: (BuildContext context, int dayIndex) {
                    // if (schedule[weekDays[weekIndex]]!.isEmpty) {
                    // }
                    return const NoSlotTile();
                  },
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
