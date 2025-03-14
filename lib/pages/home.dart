import 'package:flutter/material.dart';
import 'package:quiz_app_project/database/account_database.dart';
import 'package:quiz_app_project/pages/account_settings.dart';
import 'package:quiz_app_project/pages/login.dart';
import 'package:quiz_app_project/pages/quiz_history.dart';
import 'package:quiz_app_project/quiz_in_take/quiz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SupabaseClient supabase = Supabase.instance.client;
  final AccountDatabase _accountDatabase = AccountDatabase();
  String? fname;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final account = await _accountDatabase.getAccountByEmail(user.email!);
      if (account != null) {
        setState(() {
          fname = account.fname;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return Scaffold(body: Center(child: Text("No user logged in")));
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 231, 231),
      endDrawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 100,
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text(
                "Activities",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 4, 41, 64),
                ),
              ),
              onTap: () async {
                // Get the current account
                final currentEmail = supabase.auth.currentUser?.email;
                if (currentEmail != null) {
                  final account =
                      await _accountDatabase.getAccountByEmail(currentEmail);
                  if (account != null) {
                    navigator(
                        context, QuizHistoryPage(currentAccount: account));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Unable to load account data')),
                    );
                  }
                }
              },
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                "Account Settings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 4, 41, 64),
                ),
              ),
              onTap: () async {
                // Example: Get user account using the current authenticated email
                final currentEmail =
                    Supabase.instance.client.auth.currentUser?.email;
                if (currentEmail != null) {
                  final accountDB = AccountDatabase();
                  final account =
                      await accountDB.getAccountByEmail(currentEmail);
                  if (account != null) {
                    navigator(context, EditAccountPage(account: account));
                  } else {
                    // Handle case where account is not found
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unable to load account data')));
                  }
                } else {
                  // Handle case where user is not logged in
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('You must be logged in to edit your account')));
                }
              },
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 4, 41, 64),
                ),
              ),
              onTap: () async {
                try {
                  await supabase.auth.signOut();
                  // Logout successful
                  Navigator.of(context)
                      .pop(); // Navigate after successful logout
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout successful')),
                  );
                } catch (e) {
                  // Logout failed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout failed: $e')),
                  );
                }
                navigator(context, Login());
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 390,
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                  height: 200,
                  width: 390,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: const Color.fromARGB(255, 4, 41, 64),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 50),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Welcome",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            Builder(builder: (context) {
                              return GestureDetector(
                                onTap: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                child: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              );
                            }),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$fname",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              Column(
                children: [
                  SizedBox(height: 30),
                  Text("Mathematics",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 4, 41, 64))),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 92, 83), // Outline color
                              width: 5.0, // Outline thickness
                            ),
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child:
                                      Image.asset('assets/images/algebra.jpg')),
                              Text("Algebra"),
                            ],
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              subject: "Mathematics", // Provide the subject
                              topic: "Algebra", // Provide the topic
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 92, 83), // Outline color
                              width: 5.0, // Outline thickness
                            ),
                            borderRadius: BorderRadius.circular(10),
                            // Rounded corners
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Image.asset(
                                      'assets/images/calculus.jpg')),
                              Text("Calculus"),
                            ],
                          ),
                        ),
                        onTap: () => navigator(
                          context,
                          QuizScreen(
                            subject: "Mathematics", // Provide the subject
                            topic: "Calculus", // Provide the topic
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 92, 83), // Outline color
                              width: 5.0, // Outline thickness
                            ),
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Image.asset(
                                      'assets/images/geometry.jpg')),
                              Text("Geometry"),
                            ],
                          ),
                        ),
                        onTap: () => navigator(
                          context,
                          QuizScreen(
                            subject: "Mathematics", // Provide the subject
                            topic: "Geometry", // Provide the topic
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text("Science",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 4, 41, 64))),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 92, 83), // Outline color
                              width: 5.0, // Outline thickness
                            ),
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/images/biology.png',
                                ),
                              ),
                              Text("Biology"),
                            ],
                          ),
                        ),
                        onTap: () => navigator(context,
                            QuizScreen(subject: "Science", topic: "Biology")),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 92, 83), // Outline color
                              width: 5.0, // Outline thickness
                            ),
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Image.asset(
                                      'assets/images/chemistry.png')),
                              Text("Chemistry"),
                            ],
                          ),
                        ),
                        onTap: () => navigator(context,
                            QuizScreen(subject: "Science", topic: "Chemistry")),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 92, 83), // Outline color
                              width: 5.0, // Outline thickness
                            ),
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child:
                                      Image.asset('assets/images/physics.png')),
                              Text("Physics"),
                            ],
                          ),
                        ),
                        onTap: () => navigator(context,
                            QuizScreen(subject: "Science", topic: "Physics")),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text("Social Studies",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 4, 41, 64))),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 92, 83), // Outline color
                              width: 5.0, // Outline thickness
                            ),
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child:
                                      Image.asset('assets/images/history.png')),
                              Text("History"),
                            ],
                          ),
                        ),
                        onTap: () => navigator(
                            context,
                            QuizScreen(
                                subject: "Social Studies", topic: "History")),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 92, 83), // Outline color
                              width: 5.0, // Outline thickness
                            ),
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Image.asset(
                                      'assets/images/geography.png')),
                              Text("Geography"),
                            ],
                          ),
                        ),
                        onTap: () => navigator(
                            context,
                            QuizScreen(
                                subject: "Social Studies", topic: "Geography")),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 0, 92, 83), // Outline color
                              width: 5.0, // Outline thickness
                            ),
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child:
                                      Image.asset('assets/images/civics.png')),
                              Text("Civics"),
                            ],
                          ),
                        ),
                        onTap: () => navigator(
                            context,
                            QuizScreen(
                                subject: "Social Studies", topic: "Civics")),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigator(BuildContext context, Widget page) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    // Refresh user data when returning from any page
    // (or you could check if returning from EditAccountPage specifically)
    _fetchUserData();
  }
}
