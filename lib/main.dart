import 'dart:convert';
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/constants/app_routes.dart';
import 'package:nexus/core/theme/app_theme.dart';
import 'package:nexus/core/theme/color_scheme.dart';
import 'package:nexus/core/utils/timetable_extensions.dart';
import 'package:nexus/core/utils/window_resize_utils.dart';
import 'package:nexus/data/datasources/timetable_data_source.dart';
import 'package:nexus/data/repositories/timetable_repository_impl.dart';
import 'package:nexus/presentation/bloc/timetable_view_bloc/time_table_bloc.dart';
import 'package:window_manager/window_manager.dart';

import 'data/models/timetable_slot_model.dart';
import 'presentation/bloc/week_bloc/week_bloc.dart';
import 'presentation/pages/action_hub_screen.dart';
import 'presentation/pages/home_screen.dart';
import 'presentation/pages/silencer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(350, 600),
      center: true,
      title: 'Nexus',
      skipTaskbar: false,
      backgroundColor: Colors.transparent,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      snapWindow('Nexus');
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Roboto", "Poppins");
    MaterialTheme theme = MaterialTheme(textTheme);
    final schedule =
        <String, List<TimeTableSlotModel>>{}.fromJson(jsonEncode(timeTable));
    final TimeTableDataSource dataSource =
        TimeTableLocalDataSource(schedule: schedule);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeekBloc()..add(const LoadCurrentDayEvent()),
        ),
        BlocProvider(
          create: (context) =>
              TimeTableViewBloc(repository: TimeTableRepositoryImpl(dataSource))
                ..add(const LoadTimeTableView()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(scheme: FlexScheme.aquaBlue),
        // The Mandy red, dark theme.
        // darkTheme: FlexThemeData.dark(scheme: FlexScheme.aquaBlue),
        // Use dark or light theme based on system setting.
        darkTheme: theme.dark(),
        themeMode: ThemeMode.system,
        routes: {
          // '/': AppRoutes.authPage,
          '/': AppRoutes.homePage,
          // '/': AppRoutes.silencerPage,
          '/home': AppRoutes.homePage,
          '/silencer': AppRoutes.silencerPage,
          '/event-detail': AppRoutes.eventDetailPage,
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
