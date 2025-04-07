import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/widgets/event_card.dart';

class ActionHubScreen extends StatelessWidget {
  const ActionHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar with back button and user profile
              const SizedBox(height: 16),
              // Actions Text with subtitle
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Actions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Access your tools and resources',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Action buttons in a scrollable list
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Time Table Manager Action
                      ActionButton(
                        color: const Color(0xFF6A3EAA),
                        title: 'TimeTable',
                        subtitle: 'Manage your time table',
                        icon: HugeIcons.strokeRoundedClock01,
                        onTap: () {
                          Navigator.pushNamed(context, '/time-table-manager');
                        },
                      ),

                      const SizedBox(height: 16),
                      //color: const Color(0xFF4E7CFF),

                      // Tasks Action
                      ActionButton(
                        color: const Color(0xFF4E7CFF),
                        title: 'PC Share',
                        subtitle: 'Share files with your PC',
                        icon: HugeIcons.strokeRoundedComputerPhoneSync,
                        onTap: () {},
                      ),

                      const SizedBox(height: 16),

                      // Saved Links Action
                      ActionButton(
                        color: const Color(0xFF00C0A0),
                        title: 'Saved Links',
                        subtitle: 'Access your resources',
                        icon: HugeIcons.strokeRoundedLink02,
                        onTap: () {},
                      ),

                      const SizedBox(height: 16),

                      // Documents Organizer Action
                      ActionButton(
                        color: const Color(0xFFFF8E42),
                        title: 'Documents',
                        subtitle: 'Organize and access your files',
                        icon: HugeIcons.strokeRoundedFolder01,
                        onTap: () {},
                      ),

                      const SizedBox(height: 16),

                      // Events Action
                      ActionButton(
                        color: const Color(0xFFE74D52),
                        title: 'Events',
                        subtitle: 'Manage your upcoming events',
                        icon: HugeIcons.strokeRoundedCalendar03,
                        onTap: () {},
                      ),

                      const SizedBox(height: 16),

                      // Notes Action
                      ActionButton(
                        color: const Color(0xFFD84FA1),
                        title: 'Notes',
                        subtitle: 'Create and view your notes',
                        icon: HugeIcons.strokeRoundedTaskEdit02,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon container with improved styling
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: HugeIcon(
                      icon: icon,
                      size: 24.0,
                      color: const Color(0xffffffff),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Arrow icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
