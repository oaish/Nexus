import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/widgets/event_card.dart';
import 'package:nexus/core/widgets/nexus_back_button.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var index = 0;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const NexusBackButton(),
              EventCard(
                index: index,
                iconSize: 84.0,
                date: DateTime.now(),
                size: Size(width, 200),
                deepColor: colorArray[index],
                color: colorAccentArray[index],
                hugeIcon: HugeIcons.strokeRoundedScissor01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
