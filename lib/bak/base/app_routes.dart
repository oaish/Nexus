import 'package:nexus/main.dart';
import 'package:nexus/screens/auth_screen.dart';
import 'package:nexus/screens/event_detail_screen.dart';
import 'package:nexus/screens/silencer_screen.dart';

class AppRoutes {
  static var homePage = (context) => HomePage();
  static var authPage = (context) => AuthScreen();
  static var silencerPage = (context) => SilencerScreen();
  static var eventDetailPage = (context) => EventDetailScreen();
}
