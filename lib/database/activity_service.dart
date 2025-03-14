import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fix saveQuizActivity to use correct column name: accountid
  Future<int?> saveQuizActivity({
    required String subject,
    required int score,
    required String topic,
    required int accountId,
  }) async {
    try {
      final response = await _supabase
          .from('activity_table')
          .insert({
            'subject': subject,
            'score': score,
            'topic': topic,
            'accountid': accountId, // Changed from account_id to accountid
          })
          .select('id')
          .single();

      return response['id'] as int;
    } catch (e) {
      print('Error saving quiz activity: $e');
      return null;
    }
  }

  // Fix getQuizActivitiesByAccountId to use correct column name: accountid
  Future<List<Map<String, dynamic>>> getQuizActivitiesByAccountId(
      int accountId) async {
    try {
      final response = await _supabase
          .from('activity_table')
          .select()
          .eq('accountid', accountId) // Changed from account_id to accountid
          .order('id', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching quiz activities by account ID: $e');
      return [];
    }
  }

  // Get quiz activities for a specific subject
  Future<List<Map<String, dynamic>>> getQuizActivitiesBySubject(
      String subject) async {
    try {
      final response = await _supabase
          .from('activity_table')
          .select()
          .eq('subject', subject)
          .order('id', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching quiz activities by subject: $e');
      return [];
    }
  }

  //Get quiz activities by topic
  Future<List<Map<String, dynamic>>> getQuizActivitiesByTopic(
      String topic) async {
    try {
      final response = await _supabase
          .from('activity_table')
          .select()
          .eq('topic', topic)
          .order('id', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching quiz activities by topic: $e');
      return [];
    }
  }

  //Get quiz activities by subject and topic
  Future<List<Map<String, dynamic>>> getQuizActivitiesBySubjectAndTopic(
      String subject, String topic) async {
    try {
      final response = await _supabase
          .from('activity_table')
          .select()
          .eq('subject', subject)
          .eq('topic', topic)
          .order('id', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching quiz activities by subject and topic: $e');
      return [];
    }
  }
}
