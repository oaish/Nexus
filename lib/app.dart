import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/constants/app_routes.dart';
import 'package:nexus/core/theme/app_theme.dart';
import 'package:nexus/core/theme/color_scheme.dart';
import 'package:nexus/core/utils/timetable_extensions.dart';
import 'package:nexus/data/datasources/timetable_view_data_source.dart';
import 'package:nexus/data/models/timetable_slot_model.dart';
import 'package:nexus/data/repositories/timetable_view_repository_impl.dart';
import 'package:nexus/domain/repositories/timetable_repository.dart';
import 'package:nexus/presentation/cubits/batch_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_editor_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_manager_cubit.dart';
import 'package:nexus/presentation/cubits/timetable_view_cubit.dart';
import 'package:nexus/presentation/cubits/week_cubit.dart';
import 'package:nexus/presentation/pages/action_hub_screen.dart';
import 'package:nexus/presentation/pages/home_screen.dart';
import 'package:nexus/presentation/pages/silencer_screen.dart';

class MyApp extends StatelessWidget {
  final TimeTableRepository timetableRepository;
  const MyApp({super.key, required this.timetableRepository});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Poppins");
    MaterialTheme theme = MaterialTheme(textTheme);
    final schedule = <String, List<TimeTableSlotModel>>{}.fromJson(jsonEncode(timeTable));
    final TimeTableViewDataSource dataSource = TimeTableViewLocalDataSource(schedule: schedule);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeekCubit()..loadCurrentDay(),
        ),
        BlocProvider(
          create: (context) => TimeTableViewCubit(repository: TimeTableViewRepositoryImpl(dataSource))..loadTimeTable(),
        ),
        BlocProvider<TimeTableEditorCubit>(
          create: (_) => TimeTableEditorCubit(),
        ),
        BlocProvider<TimeTableManagerCubit>(
          create: (_) => TimeTableManagerCubit(timetableRepository: timetableRepository),
        ),
        BlocProvider<BatchCubit>(
          create: (context) => BatchCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: theme.dark(),
        themeMode: ThemeMode.system,
        routes: {
          // '/': AppRoutes.authPage,
          '/': AppRoutes.homePage,
          // '/': AppRoutes.silencerPage,
          '/home': AppRoutes.homePage,
          '/silencer': AppRoutes.silencerPage,
          '/event-detail': AppRoutes.eventDetailPage,
          '/time-table-viewer': AppRoutes.timeTableViewerPage,
          '/time-table-editor': AppRoutes.timeTableEditorPage,
          '/time-table-manager': AppRoutes.timeTableManagerPage,
        },
      ),
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
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        body: screens[index],
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          color: colorScheme.primary,
          backgroundColor: colorScheme.surface,
          animationDuration: const Duration(milliseconds: 400),
          onTap: (int selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
          items: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedHome01,
              color: colorScheme.onPrimary,
              size: 32.0,
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedStarSquare,
              color: colorScheme.onPrimary,
              size: 34.0,
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar02,
              color: colorScheme.onPrimary,
              size: 32.0,
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedSettings03,
              color: colorScheme.onPrimary,
              size: 32.0,
            ),
          ],
        ),
      ),
    );
  }
}
