import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/core/widgets/nexus_back_button.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_manager_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_manager_state.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class TimeTableManagerScreen extends StatefulWidget {
  const TimeTableManagerScreen({super.key});

  @override
  State<TimeTableManagerScreen> createState() => _TimeTableManagerScreenState();
}

class _TimeTableManagerScreenState extends State<TimeTableManagerScreen> {
  bool isPublic = true;
  bool isExpanded = true;
  bool isSelectExpanded = true;

  final List<String> departments = [
    'COMPS',
    'IT',
    'EXTC',
    'MECH',
    'CIVIL',
    'ETRX'
  ];
  final List<String> years = ['FE', 'SE', 'TE', 'BE'];
  final List<String> divisions = ['A', 'B', 'C'];

  String selectedDepartment = 'COMPS';
  String selectedYear = 'SE';
  String selectedDivision = 'A';
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            NexusBackButton(
              isExtended: true,
              extendedChild: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Timetable Manager',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Orbitron',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Create Timetable Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with collapse button
                  GestureDetector(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Collapsible content
                  AnimatedCrossFade(
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timetable Name Input
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _nameController,
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
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Make Timetable Public',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontFamily: 'Orbitron',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 3,
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
                    secondChild: const SizedBox(),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),

            // Spacing between cards
            const SizedBox(height: 24),

            // Select Timetable Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with collapse button
                  GestureDetector(
                    onTap: () =>
                        setState(() => isSelectExpanded = !isSelectExpanded),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Timetable',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                        Icon(
                          isSelectExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Collapsible content
                  AnimatedCrossFade(
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Local Timetables List
                        BlocBuilder<TimeTableManagerCubit,
                            TimeTableManagerState>(
                          builder: (context, state) {
                            if (state is TimeTableManagerLoaded) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Local Timetables',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontFamily: 'Orbitron',
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Refresh local timetables
                                          context
                                              .read<TimeTableManagerCubit>()
                                              .loadTimeTables();
                                        },
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  ...state.timetables.map(
                                    (timetable) => Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A1A1A),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  timetable.name,
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontFamily: 'Orbitron',
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${timetable.department} - ${timetable.year} - ${timetable.division}',
                                                  style: const TextStyle(
                                                    color: Colors.white38,
                                                    fontSize: 12,
                                                    fontFamily: 'Orbitron',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  // Edit timetable
                                                  context
                                                      .read<
                                                          TimeTableEditorCubit>()
                                                      .createTimeTable(
                                                        id: timetable.id,
                                                        name: timetable.name,
                                                        userId:
                                                            timetable.userId,
                                                        department: timetable
                                                            .department,
                                                        year: timetable.year,
                                                        division:
                                                            timetable.division,
                                                      );
                                                  Navigator.pushNamed(context,
                                                      '/time-table-editor');
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white70,
                                                  size: 20,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  // Delete timetable
                                                  context
                                                      .read<
                                                          TimeTableManagerCubit>()
                                                      .deleteTimeTable(
                                                          timetable.id);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),

                        const SizedBox(height: 24),

                        // Cloud Timetables Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cloud Timetables',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Fetch cloud timetables
                              },
                              icon: Icon(
                                Icons.cloud_download,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'Coming Soon',
                              style: TextStyle(
                                color: Colors.white38,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    secondChild: const SizedBox(),
                    crossFadeState: isSelectExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCreateButton(BuildContext context) {
    final String name = _nameController.text.trim();
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
