import 'package:flutter/material.dart';
import 'package:quiz_app_project/model/account_model.dart';
import 'package:quiz_app_project/database/account_database.dart';

class EditAccountPage extends StatefulWidget {
  final Account account;

  const EditAccountPage({super.key, required this.account});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final AccountDatabase _accountDatabase = AccountDatabase();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current account data
    _firstNameController = TextEditingController(text: widget.account.fname);
    _lastNameController = TextEditingController(text: widget.account.lname);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // Method to handle the form submission
  Future<void> _updateAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        await _accountDatabase.updateAccount(
          widget.account,
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          widget.account.email, // Keep the original email
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          // Show success message and navigate back
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Failed to update account. Please try again.';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 217, 217),
      appBar: AppBar(
        title: const Text('Edit Account'),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          height: 844,
          width: 390,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 50),

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
                          color: Color.fromARGB(255, 124, 169, 130),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),

                    // Edit Profile title
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 124, 169, 130), //
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Empty container for symmetry
                    Container(
                      width: 40,
                    ),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Error message display
                        if (_errorMessage.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),

                        // First Name field
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 4),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Last Name field
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 4),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email field (read-only)
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              initialValue: widget.account.email,
                              decoration: const InputDecoration(
                                labelText: 'Email (Cannot be changed)',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                prefixIcon: Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: Color(0xFFEEEEEE),
                              ),
                              enabled: false, // Make it read-only
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Update Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _updateAccount,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Color.fromARGB(255, 0, 92, 83), //
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Update Profile',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
