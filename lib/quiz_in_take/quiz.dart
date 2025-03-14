import 'package:flutter/material.dart';
import 'package:quiz_app_project/database/account_database.dart';
import 'package:quiz_app_project/database/activity_service.dart';
import 'package:quiz_app_project/database/quiz_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  final String topic;
  final List<Map<String, dynamic>>? customQuestions;

  const QuizScreen({
    super.key,
    required this.subject,
    required this.topic,
    this.customQuestions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService _quizService = QuizService();
  final ActivityService _activityService =
      ActivityService(); // Add this service

  bool _isLoading = true;
  bool _isSaving = false;
  int? _activityId;

  List<int> _selectedAnswers = [];
  int _currentQuestionIndex = 0;
  bool _quizCompleted = false;
  int _finalScore = 0;

  late final List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  // Method to load questions from the service
  Future<void> _loadQuestions() async {
    if (widget.customQuestions != null) {
      setState(() {
        _questions = widget.customQuestions!;
        _selectedAnswers = List.filled(_questions.length, -1);
        _isLoading = false;
      });
    } else {
      try {
        final questionsList = await _quizService.getQuestions(
          widget.subject,
          widget.topic,
        );

        // Convert Question objects to the map format expected by the UI
        final formattedQuestions = questionsList.map((q) {
          return {
            'id': q['id'],
            'question': q['question'],
            'answers': q['answers'],
            'correctanswer': q['correctanswer'],
            'subject': q['subject'],
            'topic': q['topic'],
          };
        }).toList();

        setState(() {
          _questions = formattedQuestions;
          _selectedAnswers = List.filled(_questions.length, -1);
          _isLoading = false;
        });
      } catch (e) {
        print('Error loading questions: $e');
        setState(() {
          _questions = [];
          _isLoading = false;
        });
      }
    }
  }

  void _answerQuestion(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _submitQuiz();
    }
  }

  void _restartQuiz() {
    setState(() {
      _selectedAnswers = List.filled(_questions.length, -1);
      _currentQuestionIndex = 0;
      _quizCompleted = false;
      _finalScore = 0;
      _activityId = null;
    });
  }

  void _submitQuiz() async {
    _finalScore = 0;
    for (int i = 0; i < _questions.length; i++) {
      // Convert both values to int to ensure consistent comparison
      int selectedAnswer = _selectedAnswers[i];
      int correctAnswer = _questions[i]['correctanswer'] is int
          ? _questions[i]['correctanswer']
          : int.parse(_questions[i]['correctanswer'].toString());

      if (selectedAnswer == correctAnswer) {
        _finalScore++;
      }
    }

    setState(() {
      _quizCompleted = true;
      _isSaving = true;
    });

    try {
      // Get the current user's account ID
      final currentEmail = Supabase.instance.client.auth.currentUser?.email;
      if (currentEmail != null) {
        final accountDB = AccountDatabase();
        final account = await accountDB.getAccountByEmail(currentEmail);

        if (account != null && account.id != null) {
          final id = await _activityService.saveQuizActivity(
            subject: widget.subject,
            topic: widget.topic,
            score: _finalScore,
            accountId: account.id!, // Add the account ID parameter
          );

          setState(() {
            _activityId = id;
            _isSaving = false;
          });
        } else {
          print('Error: Unable to get account ID');
          setState(() {
            _isSaving = false;
          });
        }
      } else {
        print('Error: User not logged in');
        setState(() {
          _isSaving = false;
        });
      }
    } catch (e) {
      print('Error saving quiz result: $e');
      setState(() {
        _isSaving = false;
      });
    }
  }

  Widget _buildResultScreen() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 231),
      // appBar: AppBar(
      //   title: Text("${widget.subject} - Results"),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Container(
          height: 844,
          width: 390,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Quiz Results',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _finalScore > (_questions.length / 2)
                      ? Colors.green[100]
                      : Colors.red[100],
                  border: Border.all(
                    color: _finalScore > (_questions.length / 2)
                        ? Colors.green
                        : Colors.red,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_finalScore',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: _finalScore > (_questions.length / 2)
                              ? Colors.green[800]
                              : Colors.red[800],
                        ),
                      ),
                      Text(
                        'out of ${_questions.length}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isSaving)
                const CircularProgressIndicator()
              else if (_activityId != null)
                Text(
                  'Score saved! Activity ID: $_activityId',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 32),
              Text(
                _finalScore > (_questions.length / 2)
                    ? 'Great job!'
                    : 'Keep practicing!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: _finalScore > (_questions.length / 2)
                      ? Colors.green[700]
                      : Colors.red[700],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _restartQuiz,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: Color.fromARGB(255, 125, 172, 167)),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(_finalScore);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: Color.fromARGB(255, 125, 172, 167)),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 232, 231, 231),
        // appBar: AppBar(
        //   title: Text(widget.subject),
        //   centerTitle: true,
        // ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_quizCompleted) {
      return _buildResultScreen();
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 232, 231, 231),
        // appBar: AppBar(
        //   title: Text(widget.subject),
        //   centerTitle: true,
        // ),
        body: Center(
          child: Container(
            height: 844,
            width: 390,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No questions available for this topic.',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 4, 41, 64)),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back to Topics'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 231),
      // appBar: AppBar(
      //   title: Text("${widget.subject} - ${widget.topic}"),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Container(
          height: 844,
          width: 390,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        //           .pop(); //Color.fromARGB(255, 0, 92, 83)
                      },
                      child: Container(
                          height: 60,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 4, 157, 142),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Back",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          )),
                    ),
                    // SizedBox(
                    //   width: 150,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: Color.fromARGB(255, 4, 157, 142),
                    //         foregroundColor: Colors.white,
                    //         textStyle: TextStyle(fontSize: 18)),
                    //     onPressed: () {
                    //       Navigator.of(context)
                    //           .pop(); //Color.fromARGB(255, 0, 92, 83)
                    //     },
                    //     child: const Text(
                    //       'Back',
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 50),
                Text(
                  'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  _questions[_currentQuestionIndex]['question'],
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 24),
                ...(_questions[_currentQuestionIndex]['answers'] as List)
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  String answer = entry.value.toString();
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () => _answerQuestion(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _selectedAnswers[_currentQuestionIndex] == index
                                ? Color.fromARGB(255, 224, 238, 198)
                                : Color.fromARGB(255, 241, 247, 237),
                      ),
                      child: Text(answer,
                          style:
                              TextStyle(color: Color.fromARGB(255, 4, 41, 64))),
                    ),
                  );
                }),
                // const Spacer(),

                SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: _selectedAnswers[_currentQuestionIndex] != -1
                        ? _nextQuestion
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                          255,
                          124,
                          169,
                          130,
                        ),
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 18)),
                    child: Text(_currentQuestionIndex < _questions.length - 1
                        ? 'Next'
                        : 'Submit'),
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
