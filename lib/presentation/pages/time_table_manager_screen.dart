import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_styles.dart';
import 'package:nexus/core/utils/timetable_utils.dart';
import 'package:nexus/core/widgets/nexus_back_button.dart';
import 'package:nexus/domain/entities/timetable.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_manager_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_manager_state.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class TimeTableManagerScreen extends StatefulWidget {
  const TimeTableManagerScreen({super.key});

  @override
  State<TimeTableManagerScreen> createState() => _TimeTableManagerScreenState();
}

class _TimeTableManagerScreenState extends State<TimeTableManagerScreen> {
  bool isPublic = true;
  String expandedCard =
      'select'; // Track which card is expanded: 'create', 'select', or 'none'
  bool isLocalTimetables = true;

  final List<String> departments = [
    'COMPS',
    'IT',
    'EXTC',
    'MECH',
    'CIVIL',
  ];
  final List<String> years = ['FE', 'SE', 'TE', 'BE'];
  final List<String> divisions = ['A', 'B', 'C'];

  String selectedDepartment = 'COMPS';
  String selectedYear = 'SE';
  String selectedDivision = 'A';
  final TextEditingController _nameController = TextEditingController();

  // Filtered timetables based on selected filters
  List<TimeTable> getFilteredTimetables(List<TimeTable> timetables) {
    return timetables
        .where((tt) =>
            tt.department == selectedDepartment &&
            tt.year == selectedYear &&
            tt.division == selectedDivision)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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

              // Currently Selected Timetable Card
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
                      'Currently Selected',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<TimeTableManagerCubit, TimeTableManagerState>(
                      builder: (context, state) {
                        if (state is TimeTableManagerLoaded &&
                            state.currentTimeTable != null) {
                          final timetable = state.currentTimeTable!;
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/time-table-viewer');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          timetable.name,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontFamily: 'Orbitron',
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
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
                                ],
                              ),
                            ),
                          );
                        }
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'No timetable selected',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Spacing between cards
              const SizedBox(height: 24),

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
                      onTap: () => setState(() => expandedCard =
                          expandedCard == 'create' ? 'none' : 'create'),
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
                            expandedCard == 'create'
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),

                    // Collapsible content
                    AnimatedCrossFade(
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

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
                      crossFadeState: expandedCard == 'create'
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
                      onTap: () => setState(() => expandedCard =
                          expandedCard == 'select' ? 'none' : 'select'),
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
                            expandedCard == 'select'
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),

                    // Collapsible content
                    AnimatedCrossFade(
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // Toggle between Local and Cloud Timetables
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isLocalTimetables
                                    ? 'Local Timetables'
                                    : 'Cloud Timetables',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontFamily: 'Orbitron',
                                ),
                              ),
                              shadcn.Switch(
                                value: isLocalTimetables,
                                onChanged: (value) =>
                                    setState(() => isLocalTimetables = value),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Filters
                          Row(
                            children: [
                              // Department Filter
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                      fontSize: 12,
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
                                        setState(() =>
                                            selectedDepartment = newValue);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Year Filter
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                      fontSize: 12,
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
                              ),
                              const SizedBox(width: 8),
                              // Division Filter
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                      fontSize: 12,
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
                                        setState(
                                            () => selectedDivision = newValue);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Timetables List
                          BlocBuilder<TimeTableManagerCubit,
                              TimeTableManagerState>(
                            builder: (context, state) {
                              if (state is TimeTableManagerLoaded) {
                                final filteredTimetables =
                                    getFilteredTimetables(state.timetables);
                                return Column(
                                  children: filteredTimetables.map((timetable) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A1A1A),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  '${timetable.department} - ${timetable.year} - ${timetable.division}',
                                                  style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontFamily: 'Orbitron',
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!isLocalTimetables)
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<
                                                        TimeTableManagerCubit>()
                                                    .saveTimeTable(timetable);
                                              },
                                              icon: const Icon(
                                                Icons.download,
                                                color: Colors.white70,
                                                size: 20,
                                              ),
                                            ),
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<TimeTableEditorCubit>()
                                                  .editTimeTable(
                                                    id: timetable.id,
                                                    name: timetable.name,
                                                    userId: timetable.userId,
                                                    department:
                                                        timetable.department,
                                                    year: timetable.year,
                                                    division:
                                                        timetable.division,
                                                    schedule:
                                                        timetable.schedule,
                                                  );
                                              Navigator.pushNamed(context,
                                                  '/time-table-editor');
                                            },
                                            icon: HugeIcon(
                                              icon:
                                                  HugeIcons.strokeRoundedPen01,
                                              size: 24.0,
                                              color: const Color(0xffffffff),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<TimeTableManagerCubit>()
                                                  .deleteTimeTable(
                                                      timetable.id);
                                            },
                                            icon: HugeIcon(
                                              icon: HugeIcons
                                                  .strokeRoundedDelete02,
                                              size: 24.0,
                                              color: const Color(0xFFd0021b),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ],
                      ),
                      secondChild: const SizedBox(),
                      crossFadeState: expandedCard == 'select'
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),

              // Spacing between cards
              const SizedBox(height: 24),

              // Import Timetable Card
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
                      onTap: () => setState(() => expandedCard =
                          expandedCard == 'import' ? 'none' : 'import'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Import Timetable',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          Icon(
                            expandedCard == 'import'
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),

                    // Collapsible content
                    AnimatedCrossFade(
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // Import Options
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _importFromFile(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white10,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.file_upload,
                                          color: Colors.white70,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Import from File',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontFamily: 'Orbitron',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showJsonInputDialog(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white10,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.text_snippet,
                                          color: Colors.white70,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Paste JSON',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontFamily: 'Orbitron',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      secondChild: const SizedBox(),
                      crossFadeState: expandedCard == 'import'
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),

              // Spacing between cards
              const SizedBox(height: 24),

              // Export Timetable Card
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
                      onTap: () => setState(() => expandedCard =
                          expandedCard == 'export' ? 'none' : 'export'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Export Timetable',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          Icon(
                            expandedCard == 'export'
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),

                    // Collapsible content
                    AnimatedCrossFade(
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // Export Options
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _exportToExcel(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white10,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.table_chart,
                                          color: Colors.white70,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Export to Excel',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontFamily: 'Orbitron',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _exportToFile(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white10,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.file_download,
                                          color: Colors.white70,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Export to JSON',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontFamily: 'Orbitron',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      secondChild: const SizedBox(),
                      crossFadeState: expandedCard == 'export'
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
      name: name,
      userId: const Uuid().v4(),
      department: selectedDepartment,
      year: selectedYear,
      division: selectedDivision,
    );

    Navigator.pushNamed(context, '/time-table-editor');
  }

  void _importFromFile(BuildContext context) async {
    try {
      // Let user choose a JSON file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        lockParentWindow: true,
      );

      if (result == null) {
        // User cancelled the file picker
        return;
      }

      // Read the file content
      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();

      // Parse and validate the JSON
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Validate required fields
      final requiredFields = [
        'id',
        'userId',
        'name',
        'department',
        'year',
        'division',
        'isPublic',
        'schedule',
        'lastModified',
      ];

      for (final field in requiredFields) {
        if (!jsonData.containsKey(field)) {
          throw Exception('Missing required field: $field');
        }
      }

      // Validate schedule format
      final schedule = jsonData['schedule'] as Map<String, dynamic>;
      for (final day in schedule.keys) {
        if (schedule[day] is! List) {
          throw Exception('Invalid schedule format for day: $day');
        }

        final slots = schedule[day] as List;
        for (final slot in slots) {
          if (slot is! Map<String, dynamic>) {
            throw Exception('Invalid slot format in day: $day');
          }

          // Validate required slot fields
          if (!slot.containsKey('sTime') ||
              !slot.containsKey('eTime') ||
              !slot.containsKey('type')) {
            throw Exception('Missing required fields in slot for day: $day');
          }

          // Validate subSlots if present
          if (slot.containsKey('subSlots')) {
            final subSlots = slot['subSlots'];
            if (subSlots is! List) {
              throw Exception('Invalid subSlots format in day: $day');
            }

            for (final subSlot in subSlots) {
              if (subSlot is! Map<String, dynamic>) {
                throw Exception('Invalid subSlot format in day: $day');
              }
            }
          }
        }
      }

      // Create TimeTable from JSON
      final timetable = TimeTable.fromJson(jsonData);

      // Save the timetable
      context.read<TimeTableManagerCubit>().saveTimeTable(timetable);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          getSnackBar(
            'Success',
            'Timetable imported successfully',
            ContentType.success,
          ),
        );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          getSnackBar(
            'Error',
            'Failed to import timetable: ${e.toString()}',
            ContentType.failure,
          ),
        );
    }
  }

  void _exportToFile(BuildContext context) async {
    final state = context.read<TimeTableManagerCubit>().state;
    final currentTimeTable =
        state is TimeTableManagerLoaded ? state.currentTimeTable : null;

    if (currentTimeTable == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          getSnackBar(
            'Error',
            'No timetable selected to export',
            ContentType.failure,
          ),
        );
      return;
    }

    try {
      // Convert timetable to JSON
      final jsonString = jsonEncode(currentTimeTable.toJson());

      // Get the downloads directory
      final directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Could not access downloads directory');
      }

      // Create a default filename using the timetable name
      final defaultFileName =
          '${currentTimeTable.name.replaceAll(' ', '_')}.json';

      // Let user choose where to save the file
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Timetable JSON',
        fileName: defaultFileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        lockParentWindow: true,
      );

      if (outputFile == null) {
        // User cancelled the save dialog
        return;
      }

      // Ensure the file has .json extension
      if (!outputFile.toLowerCase().endsWith('.json')) {
        outputFile += '.json';
      }

      // Write the JSON to the file
      final file = File(outputFile);
      await file.writeAsString(jsonString);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          getSnackBar(
            'Success',
            'Timetable exported successfully',
            ContentType.success,
          ),
        );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          getSnackBar(
            'Error',
            'Failed to export timetable: ${e.toString()}',
            ContentType.failure,
          ),
        );
    }
  }

  void _showJsonInputDialog(BuildContext context) {
    final TextEditingController jsonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => shadcn.AlertDialog(
        title: Text(
          'Import Timetable from JSON',
          style: TextStyles.titleLarge.copyWith(fontFamily: 'NovaFlat'),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: jsonController,
                  maxLines: 25,
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '''Paste your timetable JSON here...
          Example format:
          {
            "id": "unique-id",
            "name": "Timetable Name",
            "userId": "user-id",
            "department": "COMPS",
            "year": "SE",
            "division": "A",
            "lastModified": "DateTime",
            "schedule": {
              "Monday": [
                { 
                  "sTime": "9:00",
                  "eTime": "10:00",
                  "subject": "Subject Name",
                  "teacher": "Teacher Name",
                  "location": "Room Number",
                  "type": "TH"
                }
              ]
            }
          }''',
                    hintStyle: TextStyle(
                      color: Colors.white38,
                      fontFamily: 'Orbitron',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white70,
                fontFamily: 'Orbitron',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              try {
                final jsonString = jsonController.text.trim();
                if (jsonString.isEmpty) {
                  throw Exception('Please enter a timetable JSON');
                }

                final Map<String, dynamic> jsonData = jsonDecode(jsonString);

                // Validate required fields
                final requiredFields = [
                  'id',
                  'userId',
                  'name',
                  'department',
                  'year',
                  'division',
                  'isPublic',
                  'schedule',
                  'lastModified',
                ];

                for (final field in requiredFields) {
                  if (!jsonData.containsKey(field)) {
                    throw Exception('Missing required field: $field');
                  }
                }

                // Validate schedule format
                final schedule = jsonData['schedule'] as Map<String, dynamic>;
                for (final day in schedule.keys) {
                  if (schedule[day] is! List) {
                    throw Exception('Invalid schedule format for day: $day');
                  }

                  final slots = schedule[day] as List;
                  for (final slot in slots) {
                    if (slot is! Map<String, dynamic>) {
                      throw Exception('Invalid slot format in day: $day');
                    }

                    // Validate required slot fields
                    if (!slot.containsKey('sTime') ||
                        !slot.containsKey('eTime') ||
                        !slot.containsKey('type')) {
                      throw Exception(
                          'Missing required fields in slot for day: $day');
                    }

                    // Validate subSlots if present
                    if (slot.containsKey('subSlots')) {
                      final subSlots = slot['subSlots'];
                      if (subSlots is! List) {
                        throw Exception('Invalid subSlots format in day: $day');
                      }

                      for (final subSlot in subSlots) {
                        if (subSlot is! Map<String, dynamic>) {
                          throw Exception(
                              'Invalid subSlot format in day: $day');
                        }
                      }
                    }
                  }
                }

                // Create TimeTable from JSON
                final timetable = TimeTable.fromJson(jsonData);

                // Save the timetable
                context.read<TimeTableManagerCubit>().saveTimeTable(timetable);

                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    getSnackBar(
                      'Success',
                      'Timetable imported successfully',
                      ContentType.success,
                    ),
                  );
              } catch (e) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    getSnackBar(
                      'Error',
                      e.toString(),
                      ContentType.failure,
                    ),
                  );
              }
            },
            child: const Text(
              'Import',
              style: TextStyle(
                color: Color(0xFF7ED1D7),
                fontFamily: 'Orbitron',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportToExcel(BuildContext context) async {
    final state = context.read<TimeTableManagerCubit>().state;
    final currentTimeTable =
        state is TimeTableManagerLoaded ? state.currentTimeTable : null;

    if (currentTimeTable == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          getSnackBar(
            'Error',
            'No timetable selected to export',
            ContentType.failure,
          ),
        );
      return;
    }

    try {
      // Export the schedule to Excel
      await exportScheduleToExcel(currentTimeTable.schedule);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          getSnackBar(
            'Success',
            'Timetable exported to Excel successfully',
            ContentType.success,
          ),
        );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          getSnackBar(
            'Error',
            'Failed to export timetable to Excel: ${e.toString()}',
            ContentType.failure,
          ),
        );
    }
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
