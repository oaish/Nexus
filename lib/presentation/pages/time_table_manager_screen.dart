import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/core/widgets/nexus_back_button.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class TimeTableManagerScreen extends StatefulWidget {
  const TimeTableManagerScreen({super.key});

  @override
  State<TimeTableManagerScreen> createState() => _TimeTableManagerScreenState();
}

class _TimeTableManagerScreenState extends State<TimeTableManagerScreen> {
  final _classroomController = TextEditingController();
  String selectedDepartment = 'COMPS';
  String selectedYear = 'SE';
  String selectedDivision = 'A';
  bool isPublic = true;

  final List<String> departments = [
    'COMPS',
    'IT',
    'EXTC',
    'MECH',
    'CIVIL',
  ];
  final List<String> years = ['FE', 'SE', 'TE', 'BE'];
  final List<String> divisions = ['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NexusBackButton(),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create New Timetable',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Timetable Name Input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _classroomController,
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Timetable Name',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Department Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedDepartment,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: const Color(0xFF1A1A1A),
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        items: departments.map((String department) {
                          return DropdownMenuItem<String>(
                            value: department,
                            child: Text(department),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => selectedDepartment = newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Year Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedYear,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: const Color(0xFF1A1A1A),
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        items: years.map((String year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => selectedYear = newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Division Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedDivision,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: const Color(0xFF1A1A1A),
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        items: divisions.map((String division) {
                          return DropdownMenuItem<String>(
                            value: division,
                            child: Text(division),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => selectedDivision = newValue);
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Public Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 7, // 70%
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Make Timetable Public',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontFamily: 'Orbitron',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 3, // 30%
                          child: shadcn.Switch(
                            value: isPublic,
                            onChanged: (value) =>
                                setState(() => isPublic = value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Create Button
                    GestureDetector(
                      onTap: () => _handleCreateButton(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7ED1D7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Create Timetable',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreateButton(BuildContext context) {
    final String name = _classroomController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          getSnackBar(
            'Required Field Missing',
            'Please enter a timetable name',
            ContentType.failure,
          ),
        );
      return;
    }

    final TimeTableEditorCubit editorCubit =
        context.read<TimeTableEditorCubit>();
    editorCubit.createTimeTable(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      userId: '${DateTime.now().millisecondsSinceEpoch}',
      department: selectedDepartment,
      year: selectedYear,
      division: selectedDivision,
    );

    if (isPublic) {
      // TODO: Upload to Supabase
      print('Uploading to Supabase...');
    }

    Navigator.pushNamed(context, '/time-table-editor');
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
}
