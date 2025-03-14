import 'package:supabase_flutter/supabase_flutter.dart';

class QuizService {
  final SupabaseClient supabase = Supabase.instance.client;

//Retrieve
  Future<List<Map<String, dynamic>>> getQuestions(
      String subject, String topic) async {
    try {
      final response = await supabase
          .from('questions')
          .select()
          .eq('subject', subject)
          .eq('topic', topic);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching questions: $e');
      return [];
    }
  }
}
