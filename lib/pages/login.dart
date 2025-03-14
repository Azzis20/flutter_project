import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_project/pages/home.dart';
import 'package:quiz_app_project/pages/signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 844,
          width: 390,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/images/Widget.png'), // Path to your image
              // fit: BoxFit.cover, // Makes the image cover the entire screen
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150, // Adjust size
                  height: 150, // Must be equal to width for a perfect circle
                  decoration: BoxDecoration(
                      // Background color
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Color.fromARGB(255, 124, 169, 130), width: 5),
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo3.jpeg"),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 250, left: 50, right: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              hintText: 'example@gmail.com',
                              // labelText: 'Email',
                              // labelStyle: TextStyle(
                              //   fontSize: 15,
                              //   fontWeight: FontWeight.bold,
                              //   color: Colors.grey,
                              // ),
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                              fillColor: Colors.grey.withOpacity(0.2),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: Icon(Icons.mail)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                            fillColor: Colors.grey.withOpacity(0.2),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20)),
                            prefixIcon: Icon(Icons.security)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 300,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 4, 41, 64),
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final authResponse =
                                      await supabase.auth.signInWithPassword(
                                    password: _passController.text,
                                    email: _emailController.text,
                                  );

                                  if (authResponse.user != null) {
                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Login Successful!')),
                                    );

                                    // Navigate to Home after successful login
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Login failed: Invalid credentials')),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Login Failed: $e')),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Create()));
                      },
                      focusColor: Colors.blue, // Color of the ripple effect
                      child: Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 92, 83)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
