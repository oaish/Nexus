import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/domain/entities/timetable_slot.dart';
import 'package:nexus/presentation/cubits/timetable_view_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_view_state.dart';

class TimeSlotTile extends StatelessWidget {
  const TimeSlotTile({
    super.key,
    required this.slot,
    required this.batchIndex,
    required this.groupIndex,
    required this.index,
  });

  final TimeTableSlot slot;
  final int index;
  final int batchIndex;
  final int groupIndex;

  Color? _getAccentColor(String? type) {
    switch (type) {
      case "MP":
        return Colors.blue;
      case "TH":
        return Colors.deepPurpleAccent;
      case "PR":
        return Colors.pinkAccent;
      case "TT":
        return Colors.deepOrangeAccent;
      case "AC":
        return Colors.green;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget? dynamicSlot;
    Color accentColor;

    switch (slot.type) {
      case "MP":
        accentColor = Colors.blue;
        dynamicSlot = _theoryColumn();
        break;
      case "TH":
        accentColor = Colors.deepPurpleAccent;
        dynamicSlot = _theoryColumn();
        break;
      case "PR":
        accentColor = Colors.pinkAccent;
        dynamicSlot = _subSlotColumn(context);
        break;
      case "TT":
        accentColor = Colors.deepOrangeAccent;
        dynamicSlot = _subSlotColumn(context, isPractical: false);
        break;
      case "AC":
        accentColor = Colors.green;
        dynamicSlot = _activityColumn();
        break;

      default:
        accentColor = Colors.greenAccent;
        dynamicSlot = _activityColumn();
        break;
    }

    return Container(
      margin: EdgeInsets.only(
        top: index == 0 ? 16.0 : 8.0,
        bottom: 8.0,
        left: 16.0,
        right: 16.0,
      ),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(color: accentColor, width: 5),
            right: BorderSide(color: accentColor, width: 5)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 3, spreadRadius: 3)
        ],
        // color: Colors.grey[700]!,
        color: const Color(0xff222222),
        // color: const Color(0xff181818),

        borderRadius: BorderRadius.circular(8),
      ),
      child: dynamicSlot,
    );
  }

  _theoryColumn() {
    return Column(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: _slotLabel(
                HugeIcons.strokeRoundedLibrary,
                slot.subject ?? '',
                // isTitle: true,
              ),
            ),
            _slotLabel(
              HugeIcons.strokeRoundedTime03,
              '${slot.sTime} - ${slot.eTime}',
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: _slotLabel(
                HugeIcons.strokeRoundedMortarboard02,
                slot.teacher ?? '',
              ),
            ),
            _slotLabel(HugeIcons.strokeRoundedLocation01, slot.location),
          ],
        )
      ],
    );
  }

  _subSlotColumn(context, {isPractical = true}) {
    return BlocBuilder<TimeTableViewCubit, TimeTableViewState>(
      builder: (context, state) {
        final subSlot = slot.subSlots![isPractical ? batchIndex : groupIndex];
        return Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: _slotLabel(
                    isPractical
                        ? HugeIcons.strokeRoundedTestTube01
                        : HugeIcons.strokeRoundedActivity01,
                    (isPractical ? subSlot.subject : subSlot.activity) ?? '',
                    // isTitle: true,
                  ),
                ),
                _slotLabel(
                  HugeIcons.strokeRoundedTime03,
                  '${slot.sTime} - ${slot.eTime}',
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: _slotLabel(
                    HugeIcons.strokeRoundedMortarboard02,
                    subSlot.teacher ?? '',
                  ),
                ),
                _slotLabel(HugeIcons.strokeRoundedLocation01, subSlot.location),
                GestureDetector(
                  onTap: () {
                    if (isPractical) {
                      context.read<TimeTableViewCubit>().circleBatch();
                    } else {
                      context.read<TimeTableViewCubit>().circleGroup();
                    }
                  },
                  child: _slotLabel(HugeIcons.strokeRoundedUserMultiple,
                      isPractical ? subSlot.batch : subSlot.group),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget? _activityColumn() {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: _slotLabel(
            HugeIcons.strokeRoundedActivity01,
            slot.activity ?? '',
            // isTitle: true,
          ),
        ),
        _slotLabel(
          HugeIcons.strokeRoundedTime03,
          '${slot.sTime} - ${slot.eTime}',
        ),
      ],
    );
  }

  _slotLabel(icon, text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xff111418),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slot Icon
          SizedBox(
            width: 24.0,
            height: 24.0,
            child: HugeIcon(
              icon: icon,
              color: _getAccentColor(slot.type)!,
              size: 16.0,
            ),
          ),

          // Slot Text
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            height: 24.0,
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Orbitron',
                color: Colors.white60,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoSlotTile extends StatelessWidget {
  const NoSlotTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        border: const Border(
            left: BorderSide(color: Colors.red, width: 5),
            right: BorderSide(color: Colors.red, width: 5)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 3, spreadRadius: 3)
        ],
        color: const Color(0xff222222),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xff111418),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [BoxShadow(color: Color(0xff111418), blurRadius: 2)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Slot Icon
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedAlert02,
                color: Colors.red,
                size: 16.0,
              ),
            ),

            // Slot Text
            Container(
              padding: const EdgeInsets.all(4.0),
              child: const Text(
                'No slot available for this day',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  color: Colors.white60,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
