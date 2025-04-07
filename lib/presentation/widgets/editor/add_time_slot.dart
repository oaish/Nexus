import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/core/widgets/shad_auto_complete.dart';
import 'package:nexus/data/models/sub_slot_model.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';
import 'package:nexus/presentation/cubits/time_slot_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AddTimeSlot extends StatelessWidget {
  const AddTimeSlot(this.weekDay, {super.key, this.existingSlot});

  final String weekDay;
  final Map<String, dynamic>? existingSlot;

  @override
  Widget build(BuildContext context) {
    final types = {
      'TH': 'Theory',
      'PR': 'Practical',
      'TT': 'Tutorial',
      'AC': 'Activity',
      'MP': 'Project',
    };

    return BlocProvider(
      create: (context) => TimeSlotCubit()..loadDefaultTimeSlot(existingSlot),
      child: BlocBuilder<TimeSlotCubit, TimeSlotState>(
        builder: (context, state) {
          final type =
              (context.read<TimeSlotCubit>().state as TimeSlotLoaded).type;

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
                  Container(
                    constraints: const BoxConstraints(minWidth: 120),
                    child: mat.DropdownButton<String>(
                      value: type,
                      style: TextStyles.labelLarge.copyWith(
                        fontFamily: 'NovaFlat',
                        color: Colors.white,
                      ),
                      dropdownColor: const Color(0xff1a1a1a),
                      underline: Container(
                        height: 1,
                        color: Colors.white.withAlpha(140),
                      ),
                      items: types.entries.map((e) {
                        return mat.DropdownMenuItem<String>(
                          value: e.key,
                          child: Text(e.value),
                        );
                      }).toList(),
                      onChanged: (newType) {
                        if (newType != null) {
                          context.read<TimeSlotCubit>().changeType(newType);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.white.withAlpha(70),
              ),
              SlotForm(
                  weekDay: weekDay, type: type!, existingSlot: existingSlot),
            ],
          );
        },
      ),
    );
  }
}

class SlotForm extends StatefulWidget {
  const SlotForm(
      {super.key,
      required this.type,
      required this.weekDay,
      this.existingSlot});
  final String weekDay;
  final String type;
  final Map<String, dynamic>? existingSlot;

  @override
  State<SlotForm> createState() => _SlotFormState();
}

class _SlotFormState extends State<SlotForm> {
  int index = 0;
  TimeOfDay duration = const TimeOfDay(hour: 00, minute: 00);
  String durationText = '';
  final _timeFormatter = MaskTextInputFormatter(
    mask: '##:##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<Map<String, TextEditingController>> _labSubSlotControllers =
      List.generate(
    3,
    (index) => {
      'subject': TextEditingController(),
      'faculty': TextEditingController(),
      'location': TextEditingController(),
    },
  );

  final List<Map<String, TextEditingController>> _tutorialSubSlotControllers =
      List.generate(
    2,
    (index) => {
      'activity': TextEditingController(),
      'faculty': TextEditingController(),
      'location': TextEditingController(),
    },
  );

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.existingSlot != null) {
      // Initialize duration
      final sTime = widget.existingSlot!['sTime'] as String;
      final eTime = widget.existingSlot!['eTime'] as String;

      final sParts = sTime.split(':');
      final eParts = eTime.split(':');

      final sMinutes = int.parse(sParts[0]) * 60 + int.parse(sParts[1]);
      final eMinutes = int.parse(eParts[0]) * 60 + int.parse(eParts[1]);

      final durationMinutes = eMinutes - sMinutes;
      duration =
          TimeOfDay(hour: durationMinutes ~/ 60, minute: durationMinutes % 60);
      durationText =
          '${duration.hour.toString().padLeft(2, '0')}:${duration.minute.toString().padLeft(2, '0')}';

      // Initialize controllers based on slot type
      switch (widget.type) {
        case "TH":
        case "MP":
          _subjectController.text = widget.existingSlot!['subject'] ?? '';
          _facultyController.text = widget.existingSlot!['teacher'] ?? '';
          _locationController.text = widget.existingSlot!['location'] ?? '';
          break;
        case "PR":
          final subSlots = widget.existingSlot!['subSlots'] as List<dynamic>?;
          if (subSlots != null) {
            for (int i = 0; i < subSlots.length && i < 3; i++) {
              final subSlot = subSlots[i];
              _labSubSlotControllers[i]['subject']?.text =
                  subSlot['subject'] ?? '';
              _labSubSlotControllers[i]['faculty']?.text =
                  subSlot['teacher'] ?? '';
              _labSubSlotControllers[i]['location']?.text =
                  subSlot['location'] ?? '';
            }
          }
          break;
        case "TT":
          final subSlots = widget.existingSlot!['subSlots'] as List<dynamic>?;
          if (subSlots != null) {
            for (int i = 0; i < subSlots.length && i < 2; i++) {
              final subSlot = subSlots[i];
              _tutorialSubSlotControllers[i]['activity']?.text =
                  subSlot['activity'] ?? '';
              _tutorialSubSlotControllers[i]['faculty']?.text =
                  subSlot['teacher'] ?? '';
              _tutorialSubSlotControllers[i]['location']?.text =
                  subSlot['location'] ?? '';
            }
          }
          break;
        case "AC":
          _subjectController.text = widget.existingSlot!['activity'] ?? '';
          break;
      }
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _facultyController.dispose();
    _locationController.dispose();

    for (var controller in _labSubSlotControllers) {
      controller.values.forEach((c) => c.dispose());
    }

    for (var controller in _tutorialSubSlotControllers) {
      controller.values.forEach((c) => c.dispose());
    }

    super.dispose();
  }

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

    final [sTime, eTime] = context
        .read<TimeTableEditorCubit>()
        .getNextTimeSlot(widget.weekDay, duration);
    TimeTableSlotModel slotModel;

    // Create model first, then convert to entity at the end
    slotModel = TimeTableSlotModel(
      sTime: sTime,
      eTime: eTime,
      type: widget.type,
    );

    switch (widget.type) {
      case "TH":
        slotModel = TimeTableSlotModel(
          sTime: sTime,
          eTime: eTime,
          type: widget.type,
          subject: subject,
          teacher: faculty,
          location: location,
        );
        break;
      case "PR":
        slotModel = TimeTableSlotModel(
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
        slotModel = TimeTableSlotModel(
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
        slotModel = TimeTableSlotModel(
          sTime: sTime,
          eTime: eTime,
          type: widget.type,
          activity: subject,
        );
        break;
      case "MP":
        slotModel = TimeTableSlotModel(
          sTime: sTime,
          eTime: eTime,
          type: widget.type,
          subject: subject,
          teacher: faculty,
          location: location,
        );
        break;
    }

    final slot = slotModel;
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
        _slotFormField(
            'Location', 'Enter the room location', _locationController),
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
                _slotFormField('Subject', 'Enter the subject name',
                    _labSubSlotControllers[index]['subject']),
                _slotFormField('Faculty', 'Enter the faculty name',
                    _labSubSlotControllers[index]['faculty']),
                _slotFormField('Location', 'Enter the room location',
                    _labSubSlotControllers[index]['location']),
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
                _slotFormField('Activity', 'Enter the activity name',
                    _tutorialSubSlotControllers[index]['activity']),
                _slotFormField('Faculty', 'Enter the faculty name',
                    _tutorialSubSlotControllers[index]['faculty']),
                _slotFormField('Location', 'Enter the room location',
                    _tutorialSubSlotControllers[index]['location']),
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
        _slotFormField(
            'Activity', 'Enter the activity name', _subjectController),
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
        _slotFormField(
            'Location', 'Enter the room location', _locationController),
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
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: mat.Colors.grey.shade900),
            ),
            child: mat.TextField(
              controller: TextEditingController(text: durationText),
              inputFormatters: [_timeFormatter],
              style: TextStyles.labelLarge.copyWith(
                fontFamily: 'NovaFlat',
                color: Colors.white,
              ),
              decoration: mat.InputDecoration(
                border: mat.InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                hintText: 'HH:mm',
                hintStyle: TextStyle(
                  color: mat.Colors.grey.shade500,
                  fontFamily: 'NovaFlat',
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (_timeFormatter.isFill()) {
                  final parts = value.split(':');
                  if (parts.length == 2) {
                    final hours = int.tryParse(parts[0]);
                    final minutes = int.tryParse(parts[1]);
                    if (hours != null &&
                        minutes != null &&
                        hours >= 0 &&
                        hours < 24 &&
                        minutes >= 0 &&
                        minutes < 60) {
                      setState(() {
                        durationText =
                            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
                        duration = TimeOfDay(hour: hours, minute: minutes);
                      });
                    }
                  }
                }
              },
            ),
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
