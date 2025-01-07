import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/base/app_media.dart';
import 'package:nexus/base/utils/app_data.dart';
import 'package:nexus/base/widgets/link_tile.dart';
import 'package:nexus/base/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // colorArray = [];

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        spacing: 32,
        children: [
          _homeScreenHeader(colorScheme),
          // SizedBox(height: 32),
          _dashAnalytics(),
          // SizedBox(height: 32),
          _upcomingEventsSection(),
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
            padding: EdgeInsets.all(8.0),
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

  _dashAnalytics() => Row(
        spacing: 10,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 10,
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          )
        ],
      );

  _upcomingEventsSection() => Column(
        children: [
          SectionHeader(
              text: 'Upcoming events',
              onTap: () {
                if (colorArray.isNotEmpty) {
                  colorArray = [];
                } else {
                  colorArray = [
                    Colors.tealAccent,
                    Colors.deepPurpleAccent,
                    Colors.pinkAccent,
                    Colors.redAccent,
                    Colors.orangeAccent,
                  ];
                }
              }),
          SizedBox(height: 16),
          Visibility(
            visible: colorArray.isNotEmpty,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 16,
                children: List.generate(
                  colorArray.length,
                  (index) => Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      color: colorArray[index],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: colorArray.isEmpty,
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
                if (colorArray.isNotEmpty) {
                  colorArray = [];
                } else {
                  colorArray = [
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
                reverse: true,
                children: List.generate(
                  colorArray.length,
                  (index) => Column(
                    children: [
                      LinkTile(accent: colorArray[index]),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
