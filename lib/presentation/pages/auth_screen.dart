import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import '../../core/theme/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  void _showErrorSnackBar(String title, String message) {
    print('Error: $message');
    shadcn.showToast(
      context: context,
      builder: (BuildContext context, shadcn.ToastOverlay overlay) {
        return shadcn.SurfaceCard(
          child: shadcn.Basic(
            title: Text(title),
            subtitle: Text(message),
            trailing: shadcn.PrimaryButton(
                size: shadcn.ButtonSize.small,
                onPressed: () {
                  overlay.close();
                },
                child: const Text('Close')),
            trailingAlignment: Alignment.center,
          ),
        );
      },
      location: shadcn.ToastLocation.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            _showErrorSnackBar(state.title, state.message);
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AuthForm(
                isLogin: _isLogin,
                onSubmit: (email, password, {String? name}) {
                  if (_isLogin) {
                    context.read<AuthCubit>().signIn(email, password);
                  } else {
                    context.read<AuthCubit>().signUp(email, password, name: name);
                  }
                },
                onToggleMode: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                onGoogleSignIn: () {
                  context.read<AuthCubit>().signInWithGoogle();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
