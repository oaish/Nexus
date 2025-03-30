import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus/app.dart';
import 'package:nexus/presentation/cubits/auth_cubit.dart';
import 'package:nexus/presentation/screens/auth/auth_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomePage();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
