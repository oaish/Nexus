import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';

class LinksService {
  final _supabase = SupabaseConfig.client;

  Future<Map<String, dynamic>> saveLink({
    required String userId,
    required String title,
    required String url,
    String? description,
  }) async {
    try {
      final response = await _supabase.from('links').insert({
        'user_id': userId,
        'title': title,
        'url': url,
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      return {
        'success': true,
        'link': response,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getUserLinks(String userId) async {
    try {
      final links = await _supabase
          .from('links')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return {
        'success': true,
        'links': links,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> deleteLink(String linkId) async {
    try {
      await _supabase.from('links').delete().eq('id', linkId);

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
} 