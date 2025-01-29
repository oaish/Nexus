import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/base/utils/app_data.dart';
import 'package:nexus/base/widgets/event_card.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var index = 0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EventCard(
            index: index,
            iconSize: 84.0,
            date: DateTime.now(),
            size: Size(width, 200),
            deepColor: colorArray[index],
            color: colorAccentArray[index],
            hugeIcon: HugeIcons.strokeRoundedScissor01,
          ),
        ),
      ),
    );
  }
}
