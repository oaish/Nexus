import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/constants/app_media.dart';
import 'package:nexus/core/widgets/event_card.dart';
import 'package:nexus/core/widgets/link_tile.dart';
import 'package:nexus/core/widgets/section_header.dart';
import 'package:nexus/presentation/bloc/week_bloc/week_bloc.dart';
import 'package:nexus/presentation/widgets/time_table_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        spacing: 32,
        children: [
          _homeScreenHeader(colorScheme),
          // SizedBox(height: 32),
          _timeTableSection(context),
          // SizedBox(height: 32),
          _upcomingEventsSection(context),
          // SizedBox(height: 32),
          _linksSection(colorScheme),
        ],
      ),
    );
  }

  _homeScreenHeader(colorScheme) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(AppMedia.appIcon, width: 48, height: 48),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedNotification02,
              color: colorScheme.onPrimary,
              size: 24.0,
            ),
          ),
        ],
      );

  _timeTableSection(context) => BlocBuilder<WeekBloc, WeekState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/time-table-manager');
            },
            child: const TimeTableView(),
          );
        },
      );

  _upcomingEventsSection(context) => Column(
        children: [
          const SectionHeader(text: 'Upcoming events'),
          const SizedBox(height: 16),
          Visibility(
            visible: colorAccentArray.isNotEmpty,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 16,
                children: List.generate(
                  colorAccentArray.length,
                  (index) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/event-detail');
                    },
                    child: EventCard(
                      index: index,
                      iconSize: 32.0,
                      size: const Size(150, 100),
                      date: DateTime.now(),
                      deepColor: colorArray[index],
                      color: colorAccentArray[index],
                      hugeIcon: HugeIcons.strokeRoundedScissor01,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: colorAccentArray.isEmpty,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      );

  _linksSection(colorScheme) => Expanded(
        child: Column(
          spacing: 16,
          children: [
            SectionHeader(
              text: 'Saved links',
              onTap: () {
                if (colorAccentArray.isNotEmpty) {
                  colorAccentArray = [];
                } else {
                  colorAccentArray = [
                    Colors.tealAccent,
                    Colors.deepPurpleAccent,
                    Colors.pinkAccent,
                    Colors.redAccent,
                    Colors.orangeAccent,
                  ];
                }
              },
            ),
            Expanded(
              child: ListView(
                children: List.generate(
                  colorAccentArray.length,
                  (index) => Column(
                    children: [
                      LinkTile(accent: colorAccentArray[index]),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
