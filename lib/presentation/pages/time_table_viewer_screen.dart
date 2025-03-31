import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/utils/timetable_extensions.dart';
import 'package:nexus/core/widgets/nexus_back_button.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';
import 'package:nexus/presentation/cubits/timetable_manager_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_manager_state.dart';
import 'package:nexus/presentation/cubits/timetable_view_cubit.dart';
import 'package:nexus/presentation/cubits/week_cubit.dart';
import 'package:nexus/presentation/widgets/time_slot_tile.dart';
import 'package:nexus/presentation/widgets/week_buttons_grid.dart';

class TimeTableViewerScreen extends StatelessWidget {
  TimeTableViewerScreen({super.key});

  late final PageController _pageController;
  bool isProgrammaticChange = false;

  @override
  Widget build(BuildContext context) {
    final schedule =
        (context.read<TimeTableManagerCubit>().state as TimeTableManagerLoaded)
            .currentTimeTable
            ?.schedule;
    final colorScheme = Theme.of(context).colorScheme;
    final currentDay = DateFormat('EEEE').format(DateTime.now());
    _pageController = PageController(initialPage: weekDays.indexOf(currentDay));

    return BlocListener<WeekCubit, WeekState>(
      listener: (context, state) {
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
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              // Nexus Back Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: NexusBackButton(
                  isExtended: true,
                  onTap: () {
                    context.read<WeekCubit>().selectDay(currentDay);
                    Navigator.pop(context);
                  },
                  extendedChild: Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'SE Comps B',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Orbitron',
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Week Buttons Grid
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: WeekButtonsGrid(weekLength: 7),
              ),

              // Slot Table
              _slotTable(context, schedule),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slotTable(context, schedule) {
    int previousPageIndex = 0;

    return Expanded(
      child: BlocBuilder<TimeTableViewCubit, TimeTableViewState>(
        builder: (context, state) {
          if (state is! TimeTableViewLoaded) {
            return const SizedBox();
          }

          return PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            onPageChanged: (int pageIndex) {
              if (!isProgrammaticChange) {
                if (pageIndex > previousPageIndex) {
                  context.read<WeekCubit>().nextDay();
                } else if (pageIndex < previousPageIndex) {
                  context.read<WeekCubit>().previousDay();
                }
              }
              previousPageIndex = pageIndex;
            },
            children: List.generate(schedule.length, (weekIndex) {
              final int? length = schedule[weekDays[weekIndex]]?.length;
              return Padding(
                padding: const EdgeInsets.all(0),
                child: ListView.builder(
                  itemCount:
                      schedule[weekDays[weekIndex]]!.isNotEmpty ? length : 1,
                  itemBuilder: (BuildContext context, int dayIndex) {
                    if (schedule[weekDays[weekIndex]]!.isEmpty) {
                      return const NoSlotTile();
                    }
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

  Widget settingsTile(text, {required IconData icon, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white10, width: 1),
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: icon,
              color: const Color(0xff308999),
              size: 24.0,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xff222222),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10, width: 1),
                      color: const Color(0xff1f1f1f),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      spacing: 5,
                      children: [
                        settingsTile(
                          'Create Timetable',
                          icon: HugeIcons.strokeRoundedPropertyAdd,
                          onTap: () => Navigator.pushNamed(
                              context, '/time-table-editor'),
                        ),
                        settingsTile(
                          'Edit Timetable',
                          icon: HugeIcons.strokeRoundedPropertyEdit,
                        ),
                        settingsTile(
                          'Import Timetable',
                          icon: HugeIcons.strokeRoundedCloudDownload,
                        ),
                        settingsTile(
                          'Export Timetable',
                          icon: HugeIcons.strokeRoundedCloudUpload,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const HugeIcon(
                        icon: HugeIcons.strokeRoundedCancel01,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
