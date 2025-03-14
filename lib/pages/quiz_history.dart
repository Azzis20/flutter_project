import 'package:flutter/material.dart';
import 'package:quiz_app_project/database/activity_service.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app_project/model/account_model.dart'; // Add this for date formatting

class QuizHistoryPage extends StatefulWidget {
  final Account currentAccount; // Add this parameter

  const QuizHistoryPage({
    super.key,
    required this.currentAccount, // Require current account
  });

  @override
  State<QuizHistoryPage> createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage> {
  final ActivityService _quizService = ActivityService();
  List<Map<String, dynamic>> _quizActivities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizActivities();
  }

  Future<void> _loadQuizActivities() async {
    setState(() {
      _isLoading = true;
    });

    // Use the account ID from the current user to fetch only their activities
    final activities = await _quizService
        .getQuizActivitiesByAccountId(widget.currentAccount.id!);

    setState(() {
      _quizActivities = activities;
      _isLoading = false;
    });
  }

  String _formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    return DateFormat('MMM dd, yyyy - HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 217, 217),
      body: Center(
        child: Container(
          height: 844,
          width: 390,
          color: Color.fromARGB(255, 4, 41, 64),
          child: Column(
            children: [
              // Header section with back button and title
              Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 20, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),

                    // Activity title
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Activity History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Empty container for fixed position
                    Container(
                      width: 40,
                    ),
                  ],
                ),
              ),

              // List of activities
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _quizActivities.isEmpty
                        ? const Center(child: Text('No quiz history found'))
                        : ListView.builder(
                            itemCount: _quizActivities.length,
                            itemBuilder: (context, index) {
                              final activity = _quizActivities[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Subject and Topic section
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  activity['subject'] ??
                                                      'Unknown Subject',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Topic: ${activity['topic'] ?? 'N/A'}',
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Score section
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 124, 169, 130),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'Score: ${activity['score']}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Timestamp section
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _formatDateTime(
                                                    activity['created_at']),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
