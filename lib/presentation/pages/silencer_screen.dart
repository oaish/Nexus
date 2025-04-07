import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SilencerScreen extends StatefulWidget {
  const SilencerScreen({super.key});

  @override
  State<SilencerScreen> createState() => _SilencerScreenState();
}

class _SilencerScreenState extends State<SilencerScreen> {
  List<Map<String, dynamic>> _rules = [];
  bool _isLoading = true;
  static const platform = MethodChannel('com.nexus.app/phone_mode');

  @override
  void initState() {
    super.initState();
    _loadRules();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      final hasPermission = await platform.invokeMethod('checkPermissions');
      if (!hasPermission) {
        if (!mounted) return;

        final shouldRequest = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return shadcn.AlertDialog(
              title: const Text('Permissions Required'),
              content: const Text(
                'This app needs permission to manage Do Not Disturb mode and ignore battery optimizations. '
                'These are required to ensure phone mode rules work reliably, especially in the background.',
              ),
              actions: [
                shadcn.OutlineButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                shadcn.PrimaryButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Allow'),
                ),
              ],
            );
          },
        );

        if (shouldRequest == true) {
          await _requestPermissions(); // This triggers the native side call
        }
      }
    } catch (e) {
      print('Error checking permissions: $e');
    }
  }

  Future<void> _requestPermissions() async {
    try {
      await platform.invokeMethod('requestPermissions');
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  Future<void> _loadRules() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final rulesJson = prefs.getString('phone_mode_rules') ?? '[]';
      final List<dynamic> decoded = jsonDecode(rulesJson);

      setState(() {
        _rules = decoded.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading rules: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone_mode_rules', jsonEncode(_rules));

      // Update rules in Android service
      await platform.invokeMethod('updateRules', {'rules': jsonEncode(_rules)});
    } catch (e) {
      print('Error saving rules: $e');
    }
  }

  Future<void> _deleteRule(int index) async {
    setState(() {
      _rules.removeAt(index);
    });
    await _saveRules();
  }

  Future<void> _createRule(BuildContext context,
      {Map<String, dynamic>? existingRule, int? index}) async {
    final colorScheme = Theme.of(context).colorScheme;
    TimeOfDay? startTime = existingRule != null
        ? TimeOfDay(
            hour: existingRule['startTimeHour'],
            minute: existingRule['startTimeMinute'])
        : null;
    TimeOfDay? endTime = existingRule != null
        ? TimeOfDay(
            hour: existingRule['endTimeHour'],
            minute: existingRule['endTimeMinute'])
        : null;
    int selectedMode = existingRule?['mode'] ?? 0; // Default: Vibrate
    List<bool> selectedDays = existingRule != null
        ? List<bool>.from(existingRule['days'])
        : List.generate(7, (_) => true); // All days selected by default
    final nameController =
        TextEditingController(text: existingRule?['name'] ?? '');

    if (!mounted) return;

    final color = const Color(0xFFFF5722);

    // Show dialog to select mode and days
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: Text(
            existingRule != null ? 'Edit Rule' : 'Create Rule',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rule Name Field
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4e4f4f),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade900),
                  ),
                  child: TextField(
                    controller: nameController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Orbitron',
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Rule Name',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Start Time Field
                GestureDetector(
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime:
                          startTime ?? const TimeOfDay(hour: 22, minute: 0),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            timePickerTheme: TimePickerThemeData(
                              backgroundColor: const Color(0xFF2A2A2A),
                              hourMinuteShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              dayPeriodShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              dayPeriodColor: Colors.cyan.shade200,
                              dayPeriodTextColor: Colors.black,
                              hourMinuteColor: Colors.cyan.shade200,
                              hourMinuteTextColor: Colors.black,
                              dialHandColor: Colors.cyan.shade300,
                              dialBackgroundColor: const Color(0xFF3A3A3A),
                              dialTextColor: Colors.white,
                              entryModeIconColor: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.cyan.shade300,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      setDialogState(() {
                        startTime = pickedTime;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4e4f4f),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade900),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start Time',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                        Text(
                          startTime != null
                              ? startTime!.format(context)
                              : 'Select time',
                          style: TextStyle(
                            color: startTime != null
                                ? Colors.white
                                : Colors.grey.shade500,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // End Time Field
                GestureDetector(
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime:
                          endTime ?? const TimeOfDay(hour: 7, minute: 0),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            timePickerTheme: TimePickerThemeData(
                              backgroundColor: const Color(0xFF2A2A2A),
                              hourMinuteShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              dayPeriodShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              dayPeriodColor: Colors.cyan.shade200,
                              dayPeriodTextColor: Colors.black,
                              hourMinuteColor: Colors.cyan.shade200,
                              hourMinuteTextColor: Colors.black,
                              dialHandColor: Colors.cyan.shade300,
                              dialBackgroundColor: const Color(0xFF3A3A3A),
                              dialTextColor: Colors.white,
                              entryModeIconColor: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.cyan.shade300,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      setDialogState(() {
                        endTime = pickedTime;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4e4f4f),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade900),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'End Time',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                        Text(
                          endTime != null
                              ? endTime!.format(context)
                              : 'Select time',
                          style: TextStyle(
                            color: endTime != null
                                ? Colors.white
                                : Colors.grey.shade500,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Phone Mode:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                      ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: [
                    ButtonSegment<int>(
                      value: 0,
                      icon: Icon(
                        Icons.vibration,
                        color: selectedMode == 0
                            ? Colors.grey.shade800
                            : colorScheme.primary,
                      ),
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      icon: Icon(
                        Icons.notifications_off,
                        color: selectedMode == 1
                            ? Colors.grey.shade800
                            : colorScheme.primary,
                      ),
                    ),
                    ButtonSegment<int>(
                      value: 2,
                      icon: Icon(
                        Icons.notifications_active,
                        color: selectedMode == 2
                            ? Colors.grey.shade800
                            : colorScheme.primary,
                      ),
                    ),
                  ],
                  selected: {selectedMode},
                  onSelectionChanged: (Set<int> selection) {
                    setDialogState(() {
                      selectedMode = selection.first;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.cyan.shade400;
                        }
                        return Colors.grey.shade800;
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.grey.shade800;
                        }
                        return Colors.white;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Apply on days:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                      ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  children: [
                    for (int i = 0; i < 7; i++)
                      FilterChip(
                        label: Text(_getDayName(i)),
                        selected: selectedDays[i],
                        onSelected: (selected) {
                          setDialogState(() {
                            selectedDays[i] = selected;
                          });
                        },
                        selectedColor: Colors.cyan.shade300,
                        checkmarkColor: Colors.black,
                        backgroundColor: Colors.grey.shade800,
                        labelStyle: TextStyle(
                          color: selectedDays[i] ? Colors.black : Colors.white,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            shadcn.OutlineButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontFamily: 'Orbitron',
                ),
              ),
            ),
            shadcn.PrimaryButton(
              onPressed: () {
                if (startTime == null || endTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select both start and end times'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final newRule = {
                  'id': existingRule?['id'] ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  'name': nameController.text.isNotEmpty
                      ? nameController.text
                      : 'Untitled Rule',
                  'startTimeHour': startTime!.hour,
                  'startTimeMinute': startTime!.minute,
                  'endTimeHour': endTime!.hour,
                  'endTimeMinute': endTime!.minute,
                  'mode': selectedMode,
                  'days': selectedDays,
                  'enabled': existingRule?['enabled'] ?? true,
                };

                setState(() {
                  if (index != null) {
                    _rules[index] = newRule;
                  } else {
                    _rules.add(newRule);
                  }
                });
                _saveRules();
                Navigator.pop(context);
              },
              child: Text(existingRule != null ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  String _getModeString(int mode) {
    switch (mode) {
      case 0:
        return 'Vibrate';
      case 1:
        return 'Silent';
      case 2:
        return 'Normal';
      default:
        return 'Unknown';
    }
  }

  IconData _getModeIcon(int mode) {
    switch (mode) {
      case 0:
        return Icons.vibration;
      case 1:
        return Icons.notifications_off;
      case 2:
        return Icons.notifications_active;
      default:
        return Icons.help_outline;
    }
  }

  String _getDayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day];
  }

  List<String> _getActiveDays(List<bool> days) {
    List<String> result = [];
    for (int i = 0; i < days.length; i++) {
      if (days[i]) {
        result.add(_getDayName(i));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rules',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Orbitron',
                    )),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _rules.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.calendar_today_outlined,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'You haven\'t set any rules yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontFamily: 'Orbitron',
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _rules.length,
                          itemBuilder: (context, index) {
                            final rule = _rules[index];
                            final startTime = TimeOfDay(
                              hour: rule['startTimeHour'],
                              minute: rule['startTimeMinute'],
                            );
                            final endTime = TimeOfDay(
                              hour: rule['endTimeHour'],
                              minute: rule['endTimeMinute'],
                            );
                            final mode = rule['mode'] as int;
                            final days = List<bool>.from(rule['days']);
                            final isEnabled = rule['enabled'] as bool;
                            final name =
                                rule['name'] as String? ?? 'Untitled Rule';

                            return GestureDetector(
                              onTap: () => _createRule(context,
                                  existingRule: rule, index: index),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Orbitron',
                                                          ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          _getModeIcon(mode),
                                                          color: Colors
                                                              .cyan.shade300,
                                                          size: 16,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          _getModeString(mode),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.copyWith(
                                                                    color: Colors
                                                                        .cyan
                                                                        .shade300,
                                                                    fontFamily:
                                                                        'Orbitron',
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Switch(
                                                value: isEnabled,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _rules[index]['enabled'] =
                                                        value;
                                                  });
                                                  _saveRules();
                                                },
                                                activeColor:
                                                    Colors.cyan.shade300,
                                                inactiveTrackColor:
                                                    Colors.grey.shade700,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time,
                                                color: Colors.white70,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${startTime.format(context)} - ${endTime.format(context)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Colors.white,
                                                      fontFamily: 'Orbitron',
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                color: Colors.white70,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  _getActiveDays(days)
                                                      .join(', '),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.white70,
                                                        fontFamily: 'Orbitron',
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xFF3A3A3A),
                                    ),
                                    IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: TextButton.icon(
                                              onPressed: () async {
                                                await _deleteRule(index);
                                              },
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontFamily: 'Orbitron',
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white70,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createRule(context),
        backgroundColor: Colors.cyan.shade300,
        foregroundColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.cyan.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
