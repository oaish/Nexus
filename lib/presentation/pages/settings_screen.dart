import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/core/constants/app_media.dart';
import 'package:nexus/presentation/cubits/auth_cubit.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedBatch = 'A'; // Default value
  final Map<String, int> batchValues = {'A': 0, 'B': 1, 'C': 2};

  // Add timetable state
  String selectedTimetable = "COMPSB - SE - CR-4 (Shared)";
  final List<String> timetables = [
    "COMPSB - SE - CR-4 (Shared)",
    "COMPSB - SE - CR-3 (Shared)",
    "COMPSB - SE - CR-2 (Shared)",
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple[700],
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage(AppMedia.cartographer),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                          fontFamily: 'Orbitron',
                        ),
                      ),
                      Text(
                        'oaishazher@gmail.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                          fontFamily: 'Orbitron',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Default Timetable Selection Card
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Default Timetable',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Orbitron',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'This timetable will be shown on the home screen',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Orbitron',
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                shadcn.Select<String>(
                  value: selectedTimetable,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTimetable = value;
                      });
                      print('Selected Timetable: $value');
                    }
                  },
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                    minHeight: 50,
                  ),
                  itemBuilder: (context, item) {
                    return Text(
                      item,
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 16,
                      ),
                    );
                  },
                  children: [
                    ...timetables.map(
                      (timetable) => shadcn.SelectItemButton(
                        value: timetable,
                        child: Text(
                          timetable,
                          style: const TextStyle(
                            fontFamily: 'Orbitron',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/time-table-viewer',
                        arguments: selectedTimetable,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "View Timetable",
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                        fontFamily: 'Orbitron',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              spacing: 8,
              children: [
                // Batch Code Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 7, // 70%
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Text(
                            'Batch Code',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          Text(
                            'Select your practical batch code for Timetable',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                              fontFamily: 'Orbitron',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3, // 30%
                      child: shadcn.Select<String>(
                        value: selectedBatch,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedBatch = value;
                            });
                            final batchNumber = batchValues[value];
                            print(
                                'Selected Batch: $value (Value: $batchNumber)');
                          }
                        },
                        constraints: const BoxConstraints(minWidth: 80),
                        popupConstraints: const BoxConstraints(minWidth: 80),
                        itemBuilder: (context, item) {
                          return Text(
                            item,
                            style: const TextStyle(
                              fontFamily: 'Orbitron',
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                        children: [
                          ...batchValues.keys.map(
                            (batch) => shadcn.SelectItemButton(
                              value: batch,
                              child: Text(
                                batch,
                                style: const TextStyle(
                                  fontFamily: 'Orbitron',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 4),

                // Secure Vault Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 7, // 70%
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secure Vault',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          Text(
                            'Set fingerprint authentication for vault',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                              fontFamily: 'Orbitron',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3, // 30%
                      child: Center(
                        child: shadcn.Switch(
                          value: true,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Sign Out",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Orbitron',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
