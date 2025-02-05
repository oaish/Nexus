import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/core/utils/timetable_extensions.dart';
import 'package:nexus/core/widgets/nexus_back_button.dart';
import 'package:nexus/presentation/bloc/timetable_view_bloc/time_table_bloc.dart';
import 'package:nexus/presentation/bloc/week_bloc/week_bloc.dart';
import 'package:nexus/presentation/widgets/time_slot_tile.dart';
import 'package:nexus/presentation/widgets/week_buttons_grid.dart';

import '../../data/models/timetable_slot_model.dart';

class TimeTableManagerScreen extends StatelessWidget {
  TimeTableManagerScreen({super.key});

  static const weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  late final PageController _pageController = PageController(initialPage: 0);
  bool isProgrammaticChange = false;

  @override
  Widget build(BuildContext context) {
    final accentColor = AppStyles.getRandomAccentColor();

    return BlocListener<WeekBloc, WeekState>(
      listener: (context, state) {
        if (state is WeekDaySelected) {
          isProgrammaticChange = true;
          _pageController
              .animateToPage(
            weekDays.indexOf(state.selectedDay),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          )
              .then((_) {
            isProgrammaticChange = false;
          });
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: NexusBackButton(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: WeekButtonsGrid(accentColor: accentColor),
              ),
              _slotTable(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slotTable(context) {
    final schedule =
        <String, List<TimeTableSlotModel>>{}.fromJson(jsonEncode(timeTable));

    final weekDays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    int previousPageIndex = 0;

    return Expanded(
      child: BlocBuilder<TimeTableViewBloc, TimeTableViewState>(
        builder: (context, state) {
          final currentState = state as TimeTableViewLoaded;
          return PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            onPageChanged: (int pageIndex) {
              if (!isProgrammaticChange) {
                if (pageIndex > previousPageIndex) {
                  context.read<WeekBloc>().add(NextDayEvent());
                } else if (pageIndex < previousPageIndex) {
                  context.read<WeekBloc>().add(PreviousDayEvent());
                }
              }
              previousPageIndex = pageIndex;
            },
            children: List.generate(schedule.length, (weekIndex) {
              return Padding(
                padding: const EdgeInsets.all(0),
                // padding: const EdgeInsets.only(bottom: 16.0),
                child: ListView.builder(
                  itemCount: schedule[weekDays[weekIndex]]?.length,
                  itemBuilder: (BuildContext context, int dayIndex) {
                    return TimeSlotTile(
                      slot: schedule[weekDays[weekIndex]]![dayIndex],
                      index: dayIndex,
                      batchIndex: state.batchIndex,
                      groupIndex: state.groupIndex,
                    );
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
