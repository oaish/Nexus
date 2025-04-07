import 'package:nexus/app.dart';
import 'package:nexus/data/repositories/document_repository_impl.dart';
import 'package:nexus/presentation/pages/auth_screen.dart';
import 'package:nexus/presentation/pages/bio_auth_screen.dart';
import 'package:nexus/presentation/pages/event_detail_screen.dart';
import 'package:nexus/presentation/pages/silencer_screen.dart';
import 'package:nexus/presentation/pages/time_table_editor_screen.dart';
import 'package:nexus/presentation/pages/time_table_manager_screen.dart';
import 'package:nexus/presentation/pages/time_table_viewer_screen.dart';
import 'package:nexus/presentation/screens/document_screen.dart';
import 'package:nexus/presentation/widgets/auth/auth_wrapper.dart';

class AppRoutes {
  static var authWrapper = (context) => const AuthWrapper();
  static var homePage = (context) => const HomePage();
  static var authPage = (context) => const AuthScreen();
  static var bioAuthPage = (context) => const BioAuthScreen();
  static var silencerPage = (context) => const SilencerScreen();
  static var eventDetailPage = (context) => const EventDetailScreen();
  static var timeTableViewerPage = (context) => TimeTableViewerScreen();
  static var timeTableEditorPage = (context) => const TimeTableEditorScreen();
  static var timeTableManagerPage = (context) => const TimeTableManagerScreen();
  static var documentsOrganizerPage = (context) => DocumentScreen(
        documentRepository: DocumentRepositoryImpl(),
      );
}
