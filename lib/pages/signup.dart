import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_project/model/account_model.dart';
import 'package:quiz_app_project/database/account_database.dart';
import 'package:quiz_app_project/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Create extends StatefulWidget {
  final Map<String, dynamic>? account;
  const Create({super.key, this.account});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final SupabaseClient supabase = Supabase.instance.client;

  final accountDatabase = AccountDatabase();

  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
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
                  AssetImage('assets/images/signup.png'), // Path to your image
              // fit: BoxFit.cover, // Makes the image cover the entire screen
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 300),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: TextFormField(
                                controller: fnameController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  filled: true,
                                  hintText: 'First name',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),

                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  //     prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            width: 150,
                            child: TextFormField(
                                controller: lnameController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  filled: true,
                                  hintText: 'Last name',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  //     prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  return null;
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.withOpacity(0.2),
                            filled: true,
                            hintText: 'Enter the email',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            //        prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.withOpacity(0.2),
                          filled: true,
                          hintText: 'password',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          //        prefixIcon: Icon(Icons.person),
                        ),
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
                                //
                                final newAccount = Account(
                                    fname: fnameController.text,
                                    lname: lnameController.text,
                                    email: emailController.text,
                                    password: passwordController.text);

                                final sm = ScaffoldMessenger.of(context);
                                final authResponse = await supabase.auth.signUp(
                                    password: passwordController.text,
                                    email: emailController.text);
                                sm.showSnackBar(SnackBar(
                                  content: Text(
                                      "Registed: ${authResponse.user!.email!}"),
                                ));

                                accountDatabase.createAccount(newAccount);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              }
                              fnameController.clear();
                              lnameController.clear();
                              emailController.clear();
                              passwordController.clear();

                              //      Navigator.push(context,
                              //         MaterialPageRoute(builder: (_) => Login()));
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            focusColor:
                                Colors.blue, // Color of the ripple effect
                            child: Padding(
                              padding: EdgeInsets.only(right: 5.0),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 0, 92, 83)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
