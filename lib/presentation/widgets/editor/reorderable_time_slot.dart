import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/presentation/cubits/batch_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:nexus/presentation/cubits/week_cubit.dart';
import 'package:nexus/presentation/widgets/editor/add_time_slot.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class ReorderableTimeSlotTile extends StatelessWidget {
  const ReorderableTimeSlotTile({
    super.key,
    required this.slot,
    required this.batchIndex,
    required this.groupIndex,
    required this.index,
  });

  final Map<String, dynamic> slot;
  final int index;
  final int batchIndex;
  final int groupIndex;

  Color? _getAccentColor(String? type) {
    switch (type) {
      case "MP":
      case "TH":
        return Colors.deepPurpleAccent;
      case "PR":
        return Colors.pinkAccent;
      case "TT":
        return Colors.deepOrangeAccent;
      case "AC":
        return Colors.greenAccent;
    }

    return null;
  }

  void _showContextMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              HugeIcon(
                  icon: HugeIcons.strokeRoundedEdit01,
                  color: Colors.white70,
                  size: 18),
              const SizedBox(width: 8),
              const Text('Edit',
                  style:
                      TextStyle(color: Colors.white70, fontFamily: 'Orbitron')),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.redAccent, size: 18),
              SizedBox(width: 8),
              Text('Delete',
                  style: TextStyle(
                      color: Colors.redAccent, fontFamily: 'Orbitron')),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        _editTimeSlot(context);
      } else if (value == 'delete') {
        _deleteTimeSlot(context);
      }
    });
  }

  void _editTimeSlot(BuildContext context) {
    // Get the current day from the WeekCubit
    final String weekDay = context.read<WeekCubit>().state.selectedDay;

    // Show the edit dialog
    showDialog(
      context: context,
      builder: (context) {
        return shadcn.AlertDialog(
          title: Text.rich(
            TextSpan(
              text: 'Add Timeslot for ',
              style: TextStyles.titleLarge.copyWith(fontFamily: 'NovaFlat'),
              children: [
                TextSpan(
                  text: weekDay,
                  style: TextStyles.titleLarge.copyWith(
                    fontFamily: 'NovaFlat',
                    color: const Color(0xff80d4da), // Custom color for the day
                  ),
                ),
              ],
            ),
          ),
          content: AddTimeSlot(weekDay),
        );
      },
    );
  }

  void _deleteTimeSlot(BuildContext context) {
    // Get the current day from the WeekCubit
    final String weekDay = context.read<WeekCubit>().state.selectedDay;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Timeslot',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'NovaFlat',
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this timeslot?',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'NovaFlat',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'NovaFlat',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Delete the timeslot
                context
                    .read<TimeTableEditorCubit>()
                    .deleteTimeSlot(weekDay, index);
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'NovaFlat',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget dynamicSlot;
    Color accentColor;

    switch (slot['type']) {
      case "MP":
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
        accentColor = Colors.greenAccent;
        dynamicSlot = _activitySlotColumn();
        break;

      default:
        accentColor = Colors.greenAccent;
        dynamicSlot = _activitySlotColumn();
        break;
    }

    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xff1a1a1a),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10, width: 1),
        ),
        child: Row(
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedDragDropVertical,
                color: Colors.white30,
                size: 24.0,
              ),
            ),
            // Slot Content
            Expanded(child: dynamicSlot),
          ],
        ),
      ),
    );
  }

  _subSlotColumn(BuildContext context, {bool isPractical = true}) {
    final subSlots = slot['subSlots'] as List<dynamic>?;
    if (subSlots == null || subSlots.isEmpty) {
      return const SizedBox();
    }

    final Map<String, dynamic> subSlot =
        subSlots[isPractical ? batchIndex : groupIndex];

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
                isPractical
                    ? subSlot['subject'] ?? ''
                    : subSlot['activity'] ?? '',
              ),
            ),
            _slotLabel(
              HugeIcons.strokeRoundedTime03,
              '${slot['sTime']} - ${slot['eTime']}',
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: _slotLabel(
                HugeIcons.strokeRoundedMortarboard02,
                subSlot['teacher'] ?? '',
              ),
            ),
            _slotLabel(
              HugeIcons.strokeRoundedLocation01,
              subSlot['location'] ?? '',
            ),
            GestureDetector(
              onTap: () {
                if (isPractical) {
                  context.read<BatchCubit>().circleBatch();
                } else {
                  context.read<BatchCubit>().circleGroup();
                }
              },
              child: _slotLabel(HugeIcons.strokeRoundedUserMultiple,
                  isPractical ? subSlot['batch'] : subSlot['group']),
            ),
          ],
        )
      ],
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
                slot['subject'] ?? '',
              ),
            ),
            _slotLabel(
              HugeIcons.strokeRoundedTime03,
              '${slot['sTime']} - ${slot['eTime']}',
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: _slotLabel(
                HugeIcons.strokeRoundedMortarboard02,
                slot['teacher'] ?? '',
              ),
            ),
            _slotLabel(
              HugeIcons.strokeRoundedLocation01,
              slot['location'] ?? '',
            ),
          ],
        )
      ],
    );
  }

  Widget _activitySlotColumn() {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: _slotLabel(
            HugeIcons.strokeRoundedActivity01,
            slot['activity'] ?? '',
          ),
        ),
        _slotLabel(
          HugeIcons.strokeRoundedTime03,
          '${slot['sTime']} - ${slot['eTime']}',
        ),
      ],
    );
  }

  _slotLabel(icon, text) {
    final accentColor = _getAccentColor(slot['type']) ?? Colors.white30;
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
              color: accentColor,
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

class EditorNoSlotTile extends StatelessWidget {
  const EditorNoSlotTile(this.weekDay, {super.key});

  final String weekDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xff1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: const Center(
        child: Text(
          'No slots for this day',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
