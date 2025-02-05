import 'package:nexus/main.dart';
import 'package:nexus/presentation/pages/auth_screen.dart';
import 'package:nexus/presentation/pages/event_detail_screen.dart';
import 'package:nexus/presentation/pages/silencer_screen.dart';
import 'package:nexus/presentation/pages/time_table_manager_screen.dart';

class AppRoutes {
  static var homePage = (context) => const HomePage();
  static var authPage = (context) => const AuthScreen();
  static var silencerPage = (context) => const SilencerScreen();
  static var eventDetailPage = (context) => const EventDetailScreen();
  static var timeTableManagerPage = (context) => TimeTableManagerScreen();
}
