import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nexus/core/constants/app_media.dart';

class BioAuthScreen extends StatefulWidget {
  const BioAuthScreen({super.key});

  @override
  State<BioAuthScreen> createState() => _BioAuthScreenState();
}

class _BioAuthScreenState extends State<BioAuthScreen> {
  final key = GlobalKey<ScaffoldMessengerState>();
  final auth = LocalAuthentication();
  late var isHovered = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () => _authenticate());
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to access the application',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      authenticated = false;
    }

    if (authenticated && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: key,
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            elevation: WidgetStateProperty.all(0),
          ),
          onPressed: _authenticate,
          onHover: (value) {
            setState(() {
              isHovered = value;
            });
          },
          child: AppMedia.authIcon(
            color: isHovered ? Colors.teal : colorScheme.primary,
            size: 150.0,
          ),
        ),
      ),
    );
  }
}
