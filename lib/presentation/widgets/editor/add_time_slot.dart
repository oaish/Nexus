import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/core/widgets/shad_auto_complete.dart';
import 'package:nexus/data/models/sub_slot_model.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';
import 'package:nexus/domain/entities/timetable_slot.dart';
import 'package:nexus/presentation/cubits/time_slot_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AddTimeSlot extends StatelessWidget {
  const AddTimeSlot(this.weekDay, {super.key});

  final String weekDay;

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xff80d4da);
    final types = {
      'TH': 'Theory',
      'PR': 'Practical',
      'TT': 'Tutorial',
      'AC': 'Activity',
      'MP': 'Project',
    };

    return BlocProvider(
      create: (context) => TimeSlotCubit()..loadDefaultTimeSlot(),
      child: BlocBuilder<TimeSlotCubit, TimeSlotState>(
        builder: (context, state) {
          final type = (context.read<TimeSlotCubit>().state as TimeSlotLoaded).type;

          return Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: Colors.white.withAlpha(140),
              ),
              Row(
                spacing: 10,
                children: [
                  Text(
                    'Type: ',
                    style: TextStyles.labelLarge.copyWith(
                      fontFamily: 'NovaFlat',
                    ),
                  ),
                  Select<String>(
                    constraints: const BoxConstraints(minWidth: 120),
                    popupConstraints: const BoxConstraints(minWidth: 120),
                    onChanged: (type) {
                      context.read<TimeSlotCubit>().changeType(type!);
                    },
                    itemBuilder: (context, item) {
                      return Text(
                        item,
                        style: TextStyles.labelLarge.copyWith(
                          fontFamily: 'NovaFlat',
                        ),
                      );
                    },
                    value: types[type],
                    children: [
                      ...types.entries.map((e) => SelectItemButton(value: e.key, child: Text(e.value))),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.white.withAlpha(70),
              ),
              SlotForm(weekDay: weekDay, type: type!),
            ],
          );
        },
      ),
    );
  }
}

class SlotForm extends StatefulWidget {
  const SlotForm({super.key, required this.type, required this.weekDay});
  final String weekDay;
  final String type;

  @override
  State<SlotForm> createState() => _SlotFormState();
}

class _SlotFormState extends State<SlotForm> {
  int index = 0;
  TimeOfDay duration = const TimeOfDay(hour: 00, minute: 00);

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<Map<String, TextEditingController>> _labSubSlotControllers = List.generate(
    3,
    (index) => {
      'subject': TextEditingController(),
      'faculty': TextEditingController(),
      'location': TextEditingController(),
    },
  );

  final List<Map<String, TextEditingController>> _tutorialSubSlotControllers = List.generate(
    2,
    (index) => {
      'activity': TextEditingController(),
      'faculty': TextEditingController(),
      'location': TextEditingController(),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getDynamicSlots(),
        Divider(
          color: Colors.white.withAlpha(70),
        ),
        Row(
          spacing: 10,
          children: [
            PrimaryButton(
              onPressed: _onSubmitHandler,
              child: const Text('Submit'),
            ),
            SecondaryButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }

  void _onSubmitHandler() {
    final String subject = _subjectController.text;
    final String faculty = _facultyController.text;
    final String location = _locationController.text;
    final List<Map<String, String>> labDetails = List.generate(
      3,
      (index) => {
        'subject': _labSubSlotControllers[index]['subject']?.text ?? '',
        'faculty': _labSubSlotControllers[index]['faculty']?.text ?? '',
        'location': _labSubSlotControllers[index]['location']?.text ?? '',
      },
    );
    final List<Map<String, String>> tutorialDetails = List.generate(
      2,
      (index) => {
        'activity': _tutorialSubSlotControllers[index]['activity']?.text ?? '',
        'faculty': _tutorialSubSlotControllers[index]['faculty']?.text ?? '',
        'location': _tutorialSubSlotControllers[index]['location']?.text ?? '',
      },
    );

    final [sTime, eTime] = context.read<TimeTableEditorCubit>().getNextTimeSlot(widget.weekDay, duration);
    TimeTableSlot slot;

    slot = TimeTableSlotModel(
      sTime: sTime,
      eTime: eTime,
      type: widget.type,
    );

    switch (widget.type) {
      case "TH":
        slot = TimeTableSlotModel(
          sTime: sTime,
          eTime: eTime,
          type: widget.type,
          subject: subject,
          teacher: faculty,
          location: location,
        );
        break;
      case "PR":
        slot = TimeTableSlotModel(
          sTime: sTime,
          eTime: eTime,
          type: widget.type,
          subSlots: List.generate(3, (index) {
            final labSlot = labDetails[index];
            return SubSlotModel(
              subject: labSlot['subject'],
              batch: String.fromCharCode('A'.codeUnitAt(0) + index),
              teacher: labSlot['faculty'],
              location: labSlot['location'],
            );
          }),
        );
        break;
      case "TT":
        slot = TimeTableSlotModel(
          sTime: sTime,
          eTime: eTime,
          type: widget.type,
          subSlots: List.generate(2, (index) {
            final tutorialSlot = tutorialDetails[index];
            return SubSlotModel(
              activity: tutorialSlot['activity'],
              group: '${index + 1}',
              teacher: tutorialSlot['faculty'],
              location: tutorialSlot['location'],
            );
          }),
        );
        break;
      case "AC":
        slot = TimeTableSlotModel(
          sTime: sTime,
          eTime: eTime,
          type: widget.type,
          activity: subject,
        );
        break;
      case "MP":
        slot = TimeTableSlotModel(
          sTime: sTime,
          eTime: eTime,
          type: widget.type,
          subject: subject,
          teacher: faculty,
          location: location,
        );
        break;
    }

    context.read<TimeTableEditorCubit>().addTimeSlot(widget.weekDay, slot);
    Navigator.pop(context);
  }

  Widget getDynamicSlots() {
    switch (widget.type) {
      case "TH":
        return theorySlots();
      case "PR":
        return labSlots();
      case "TT":
        return tutorialSlots();
      case "AC":
        return activitySlots();
      case "MP":
        return projectSlots();
      default:
        return const SizedBox();
    }
  }

  Widget theorySlots() {
    return Column(
      spacing: 10,
      children: [
        _slotFormField('Subject', 'Enter the subject name', _subjectController),
        _slotFormField('Faculty', 'Enter the faculty name', _facultyController),
        _slotFormField('Location', 'Enter the room location', _locationController),
        _slotDuration(),
      ],
    );
  }

  Widget labSlots() {
    return Column(
      spacing: 10,
      children: [
        Tabs(
          index: index,
          tabs: const [
            Text('Batch A'),
            Text('Batch B'),
            Text('Batch C'),
          ],
          onChanged: (int value) {
            setState(() {
              index = value;
            });
          },
        ),
        IndexedStack(
          index: index,
          children: List.generate(3, (index) {
            return Column(
              spacing: 5,
              children: [
                _slotFormField('Subject', 'Enter the subject name', _labSubSlotControllers[index]['subject']),
                _slotFormField('Faculty', 'Enter the faculty name', _labSubSlotControllers[index]['faculty']),
                _slotFormField('Location', 'Enter the room location', _labSubSlotControllers[index]['location']),
              ],
            );
          }),
        ),
        _slotDuration(),
      ],
    );
  }

  Widget tutorialSlots() {
    return Column(
      spacing: 10,
      children: [
        Tabs(
          index: index,
          tabs: const [
            Text('Group 1'),
            Text('Group 2'),
          ],
          onChanged: (int value) {
            setState(() {
              index = value;
            });
          },
        ),
        IndexedStack(
          index: index,
          children: List.generate(2, (index) {
            return Column(
              spacing: 5,
              children: [
                _slotFormField('Activity', 'Enter the activity name', _tutorialSubSlotControllers[index]['activity']),
                _slotFormField('Faculty', 'Enter the faculty name', _tutorialSubSlotControllers[index]['faculty']),
                _slotFormField('Location', 'Enter the room location', _tutorialSubSlotControllers[index]['location']),
              ],
            );
          }),
        ),
        _slotDuration(),
      ],
    );
  }

  Widget activitySlots() {
    return Column(
      spacing: 10,
      children: [
        _slotFormField('Activity', 'Enter the activity name', _subjectController),
        _slotDuration(),
      ],
    );
  }

  Widget projectSlots() {
    return Column(
      spacing: 10,
      children: [
        _slotFormField('Subject', 'Enter the subject name', _subjectController),
        _slotFormField('Faculty', 'Enter the faculty name', _facultyController),
        _slotFormField('Location', 'Enter the room location', _locationController),
        _slotDuration(),
      ],
    );
  }

  Widget _slotDuration() {
    return Row(
      spacing: 5,
      children: [
        Expanded(
          child: Text(
            'Duration',
            style: TextStyles.labelLarge.copyWith(
              fontFamily: 'NovaFlat',
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: TimePicker(
            value: duration,
            mode: PromptMode.dialog,
            use24HourFormat: true,
            dialogTitle: const Text('Select Duration'),
            onChanged: (value) {
              duration = value ?? duration;
            },
          ),
        ),
      ],
    );
  }

  Widget _slotFormField(label, placeholder, controller) {
    return Row(
      spacing: 5,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyles.labelLarge.copyWith(
              fontFamily: 'NovaFlat',
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: ShadAutoComplete(
            suggestions: timetableSuggestions[label]!,
            controller: controller,
            placeholder: placeholder,
          ),
        ),
      ],
    );
  }
}
