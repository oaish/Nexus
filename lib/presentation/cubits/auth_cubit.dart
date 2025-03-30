import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/supabase_config.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String title;
  final String message;

  const AuthError(this.title, this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final SupabaseClient _supabaseClient = SupabaseConfig.client;

  AuthCubit() : super(AuthInitial()) {
    checkSession();
  }

  Future<void> checkSession() async {
    try {
      final session = _supabaseClient.auth.currentSession;

      if (session != null) {
        emit(Authenticated(session.user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError('Error', e.toString()));
    }
  }

  Future<void> signUp(String email, String password, {String? name}) async {
    try {
      emit(AuthLoading());
      final AuthResponse response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user != null) {
        await _supabaseClient.from('profiles').insert({'id': user.id, 'username': name});
        emit(Authenticated(user));
      }
    } catch (e) {
      emit(AuthError('Error', e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthLoading());
      final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        emit(Authenticated(response.user!));
      }
    } catch (e) {
      emit(AuthError('Error', e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());

      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final webClientId = dotenv.env['WEB_CLIENT_ID']!;

        final GoogleSignIn googleSignIn = GoogleSignIn(
          serverClientId: webClientId,
        );
        final googleUser = await googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;

        if (accessToken == null) {
          throw 'No Access Token found.';
        }
        if (idToken == null) {
          throw 'No ID Token found.';
        }

        final AuthResponse response = await _supabaseClient.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
        final user = response.user;
        if (user != null) {
          final displayName = user.userMetadata?['full_name'] ?? user.userMetadata?['display_name'];
          await _supabaseClient.from('profiles').insert({'id': user.id, 'username': displayName});
          emit(Authenticated(user));
        }
      } else {
        throw 'Google Sign In is only supported on Android and iOS';
      }
    } catch (e) {
      emit(AuthError('Error', e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await _supabaseClient.auth.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Error', e.toString()));
    }
  }
}
