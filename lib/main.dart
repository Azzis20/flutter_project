import 'package:flutter/material.dart';
import 'package:quiz_app_project/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://ymoxguyoatfkzldyyfki.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inltb3hndXlvYXRma3psZHl5ZmtpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA2MTg0OTAsImV4cCI6MjA1NjE5NDQ5MH0.jWh5sjVyyDCyXzEDGGaVVcKeOWFzHfG3Yi13xVyLhjY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Proposal',
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
