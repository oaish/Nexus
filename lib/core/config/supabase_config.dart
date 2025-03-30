import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    try {
      await dotenv.load();
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );
    } catch (e) {
      print('Error loading .env file: $e');
      await Supabase.initialize(
        url: 'https://dooxwciipfwwbxuxjqex.supabase.co',
        anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRvb3h3Y2lpcGZ3d2J4dXhqcWV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMwODYwNTQsImV4cCI6MjA1ODY2MjA1NH0.0pZLYie1qcvXpd7aApt5Vh7MMyukWElVhPxm4aibp1g',
      );
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
} 