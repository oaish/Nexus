import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/core/widgets/nexus_back_button.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:nexus/presentation/widgets/manager/manager_card.dart';

class TimeTableManagerScreen extends StatelessWidget {
  TimeTableManagerScreen({super.key});

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const NexusBackButton(),
              Center(
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ManagerCard(
                          icon: HugeIcons.strokeRoundedPropertyAdd,
                          cardText: 'Create',
                          accentColor: Colors.pink,
                          onTap: () => _showBottomModal(
                            context,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                spacing: 10,
                                children: [
                                  TextField(
                                    controller: _textController,
                                    decoration: InputDecoration(
                                      label: const Text('Timetable Name'),
                                      hintText: 'e.g. SE Comps B',
                                      hintStyle: const TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(color: Colors.white54, width: 2),
                                      ),
                                    ),
                                    onSubmitted: (_) => _handleCreateButton(context),
                                  ),
                                  _wideButton('Create', () => _handleCreateButton(context)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const ManagerCard(
                          icon: HugeIcons.strokeRoundedPropertySearch,
                          cardText: 'Select',
                          accentColor: Colors.amber,
                        ),
                      ],
                    ),
                    const Row(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ManagerCard(
                          icon: HugeIcons.strokeRoundedCloudUpload,
                          cardText: 'Import',
                          accentColor: Colors.deepPurple,
                        ),
                        ManagerCard(
                          icon: HugeIcons.strokeRoundedCloudDownload,
                          cardText: 'Export',
                          accentColor: Colors.blue,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wideButton(String text, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff308999),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyles.labelLarge.copyWith(
            fontFamily: 'NovaFlat',
          ),
        ),
      ),
    );
  }

  SnackBar getSnackBar(title, message, contentType, {duration = 3}) {
    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: duration),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );
  }

  _showBottomModal(context, {required Widget child}) {
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
                color: Color(0xff1f1f1f),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              width: MediaQuery.of(context).size.width * 1,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10, width: 1),
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: child,
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

  _handleCreateButton(BuildContext context) {
    final String name = _textController.text.toString();
    if (name.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(getSnackBar('Nah Bruh', 'Please enter a name for your timetable', ContentType.failure));
    }

    final TimeTableEditorCubit editorCubit = context.read<TimeTableEditorCubit>();
    editorCubit.createTimeTable(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      userId: '${DateTime.now().millisecondsSinceEpoch}',
    );

    Navigator.pushNamed(context, '/time-table-editor');
  }
}
