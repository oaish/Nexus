import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nexus/presentation/cubits/auth_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      child: Column(
        spacing: 20,
        children: [
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              color: Colors.red,
              child: Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedLogout01,
                    color: colorScheme.primary,
                    size: 24.0,
                  ),
                  const Text("Logout")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
