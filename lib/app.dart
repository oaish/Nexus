import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_routes.dart';
import 'package:nexus/presentation/cubits/auth_cubit.dart';
import 'package:nexus/presentation/cubits/batch_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_manager_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_view_cubit.dart';
import 'package:nexus/presentation/cubits/week_cubit.dart';
import 'package:nexus/presentation/pages/action_hub_screen.dart';
import 'package:nexus/presentation/pages/home_screen.dart';
import 'package:nexus/presentation/pages/settings_screen.dart';
import 'package:nexus/presentation/pages/silencer_screen.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const material.MaterialApp(
            home: material.Scaffold(
              body: material.Center(
                child: material.CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return material.MaterialApp(
            home: material.Scaffold(
              body: material.Center(
                child: material.Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        }

        final prefs = snapshot.data!;

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => WeekCubit()..loadCurrentDay(),
            ),
            BlocProvider<BatchCubit>(
              create: (context) => BatchCubit(),
            ),
            BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(),
            ),
            BlocProvider<TimeTableManagerCubit>(
              create: (context) => TimeTableManagerCubit(prefs),
            ),
            BlocProvider<TimeTableViewCubit>(
              create: (context) =>
                  TimeTableViewCubit(context.read<TimeTableManagerCubit>())
                    ..loadTimeTable(),
            ),
            BlocProvider<TimeTableEditorCubit>(
              create: (context) => TimeTableEditorCubit(
                context.read<TimeTableManagerCubit>(),
              ),
            ),
          ],
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return ShadcnApp(
                debugShowCheckedModeBanner: false,
                routes: {
                  '/': AppRoutes.authWrapper,
                  '/home': AppRoutes.homePage,
                  '/silencer': AppRoutes.silencerPage,
                  '/event-detail': AppRoutes.eventDetailPage,
                  '/time-table-viewer': AppRoutes.timeTableViewerPage,
                  '/time-table-editor': AppRoutes.timeTableEditorPage,
                  '/time-table-manager': AppRoutes.timeTableManagerPage,
                },
                theme: ThemeData(
                  colorScheme: const ColorScheme(
                    brightness: Brightness.dark,
                    background: const Color(0xff1a1a1a),
                    foreground: const Color(0xfff2f2f2),
                    card: const Color(0xff1c1917),
                    cardForeground: const Color(0xfff2f2f2),
                    popover: const Color(0xff171717),
                    popoverForeground: const Color(0xfff2f2f2),
                    primary: const Color(0xff7ed1d7),
                    primaryForeground: const Color(0xff0f172a),
                    secondary: const Color(0xff27272a),
                    secondaryForeground: const Color(0xfffafafa),
                    muted: const Color(0xff262626),
                    mutedForeground: const Color(0xffa1a1aa),
                    accent: const Color(0xff292524),
                    accentForeground: const Color(0xfffafafa),
                    destructive: const Color(0xff811d1d),
                    destructiveForeground: const Color(0xfffef1f1),
                    border: const Color(0xff27272a),
                    input: const Color(0xff27272a),
                    ring: const Color(0xff157f3c),
                    chart1: const Color(0xff2662d9),
                    chart2: const Color(0xff2eb88a),
                    chart3: const Color(0xffe88c30),
                    chart4: const Color(0xffaf57db),
                    chart5: const Color(0xffe23670),
                  ),
                  radius: 0.4,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  final List<Widget?> screens = [
    const HomeScreen(),
    const ActionHubScreen(),
    const SilencerScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        footers: [
          CurvedNavigationBar(
            height: 60,
            color: colorScheme.primary,
            backgroundColor: Colors.transparent,
            animationDuration: const Duration(milliseconds: 400),
            onTap: (int selectedIndex) {
              setState(() {
                index = selectedIndex;
              });
            },
            items: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedHome01,
                color: colorScheme.primaryForeground,
                size: 32.0,
              ),
              HugeIcon(
                icon: HugeIcons.strokeRoundedStarSquare,
                color: colorScheme.primaryForeground,
                size: 34.0,
              ),
              HugeIcon(
                icon: HugeIcons.strokeRoundedCalendar02,
                color: colorScheme.primaryForeground,
                size: 32.0,
              ),
              HugeIcon(
                icon: HugeIcons.strokeRoundedSettings03,
                color: colorScheme.primaryForeground,
                size: 32.0,
              ),
            ],
          )
        ],
        child: screens[index]!,
      ),
    );
  }
}
