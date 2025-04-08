import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';

class EventsService {
  final _supabase = SupabaseConfig.client;
  Timer? _cleanupTimer;

  // Initialize the service without notification setup
  Future<void> initialize() async {
    // Set up auto cleanup of expired events
    startEventCleanup();
    print('Notifications functionality is temporarily disabled');
  }

  // Start a timer to clean up expired events
  void startEventCleanup() {
    // Check for expired events every day
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(days: 1), (_) {
      _cleanupExpiredEvents();
    });

    // Run cleanup immediately on app start
    _cleanupExpiredEvents();
  }

  // Remove expired events from the database
  Future<void> _cleanupExpiredEvents() async {
    try {
      final now = DateTime.now().toIso8601String();
      await _supabase.from('events').delete().lt('event_date', now);

      print('Cleaned up expired events');
    } catch (e) {
      print('Error cleaning up expired events: $e');
    }
  }

  Future<Map<String, dynamic>> scheduleEvent({
    required String userId,
    required String title,
    required String description,
    required DateTime eventDate,
    required TimeOfDay notificationTime,
  }) async {
    try {
      // Format time as string
      final timeString =
          '${notificationTime.hour.toString().padLeft(2, '0')}:${notificationTime.minute.toString().padLeft(2, '0')}';

      // Create event
      final response = await _supabase
          .from('events')
          .insert({
            'user_id': userId,
            'title': title,
            'description': description,
            'event_date': eventDate.toIso8601String(),
            'notification_time': timeString,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return {
        'success': true,
        'event': response,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getUserEvents(String userId) async {
    try {
      final now = DateTime.now().toIso8601String();
      final events = await _supabase
          .from('events')
          .select()
          .eq('user_id', userId)
          .gte('event_date', now)
          .order('event_date', ascending: true);

      return {
        'success': true,
        'events': events,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getUpcomingEvents(String userId, {int limit = 2}) async {
    try {
      final now = DateTime.now().toIso8601String();
      final events = await _supabase
          .from('events')
          .select()
          .eq('user_id', userId)
          .gte('event_date', now)
          .order('event_date', ascending: true)
          .limit(limit);

      return {
        'success': true,
        'events': events,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> deleteEvent(String eventId) async {
    try {
      // Delete from database
      await _supabase.from('events').delete().eq('id', eventId);

      return {
        'success': true,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Subscribe to event notifications
  RealtimeChannel subscribeToEvents(String userId) {
    return _supabase
        .channel('events')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'events',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            print('New event: ${payload.newRecord}');
          },
        )
        .subscribe();
  }

  // Dispose resources
  void dispose() {
    _cleanupTimer?.cancel();
  }
}
