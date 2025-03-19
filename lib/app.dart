import 'dart:convert';
import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/core/constants/app_data.dart';
import 'package:nexus/core/constants/app_routes.dart';
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
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MyApp extends StatelessWidget {
  final TimeTableRepository timetableRepository;
  const MyApp({super.key, required this.timetableRepository});

  @override
  Widget build(BuildContext context) {
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
      child: ShadcnApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': AppRoutes.loginPage,
          // '/': AppRoutes.bioAuthPage,
          // '/': AppRoutes.homePage,
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
            background: Color(0xff020817),
            foreground: Color(0xfff2f2f2),
            card: Color(0xff1c1917),
            cardForeground: Color(0xfff2f2f2),
            popover: Color(0xff171717),
            popoverForeground: Color(0xfff2f2f2),
            primary: Color(0xff7ed1d7),
            primaryForeground: Color(0xff0f172a),
            secondary: Color(0xff27272a),
            secondaryForeground: Color(0xfffafafa),
            muted: Color(0xff262626),
            mutedForeground: Color(0xffa1a1aa),
            accent: Color(0xff292524),
            accentForeground: Color(0xfffafafa),
            destructive: Color(0xff811d1d),
            destructiveForeground: Color(0xfffef1f1),
            border: Color(0xff27272a),
            input: Color(0xff27272a),
            ring: Color(0xff157f3c),
            chart1: Color(0xff2662d9),
            chart2: Color(0xff2eb88a),
            chart3: Color(0xffe88c30),
            chart4: Color(0xffaf57db),
            chart5: Color(0xffe23670),
          ),
          radius: 0.4,
        ),
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
        footers: [
          CurvedNavigationBar(
            height: 60,
            color: colorScheme.primary,
            backgroundColor: colorScheme.background,
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
