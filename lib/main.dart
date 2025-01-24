import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/base/app_routes.dart';
import 'package:nexus/screens/home_screen.dart';
import 'package:nexus/theme/app_theme.dart';
import 'package:nexus/theme/color_scheme.dart';
import 'package:window_manager/window_manager.dart';

import 'base/utils/window_resize_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.dark(),
      routes: {
        '/': AppRoutes.authPage,
        // '/': AppRoutes.homePage,
        '/home': AppRoutes.homePage,
        '/event-detail': AppRoutes.eventDetailPage,
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
    HomeScreen(),
    Container(),
    Container(),
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
          animationDuration: Duration(milliseconds: 400),
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
