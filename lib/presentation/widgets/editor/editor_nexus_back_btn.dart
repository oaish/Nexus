import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/widgets/nexus_back_button.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_editor_state.dart';

class EditorNexusBackBtn extends StatelessWidget {
  EditorNexusBackBtn({super.key});

  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NexusBackButton(
      isExtended: true,
      onTap: () {
        Navigator.pop(context);
      },
      extendedChild: Row(
        spacing: 10,
        children: [
          Expanded(
            child: BlocBuilder<TimeTableEditorCubit, TimeTableEditorState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    (state as TimeTableEditorLoaded).timetable.name,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Orbitron',
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () => _showBottomModal(context),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedMoreHorizontalSquare01,
                color: colorScheme.onPrimary,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsTile(text, {required IconData icon}) {
    return Container(
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
                          'Add TimeSlot',
                          icon: HugeIcons.strokeRoundedAddSquare,
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
                      child: HugeIcon(
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
