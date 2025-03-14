import 'package:quiz_app_project/model/account_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountDatabase {
  final database = Supabase.instance.client.from('account');

  // Create Account
  Future<void> createAccount(Account newAccount) async {
    try {
      await database.insert(newAccount.toMap());
    } catch (e) {
      print('Error creating account: $e');
      throw Exception('Failed to create account: $e'); // Rethrow for handling
    }
  }

  // Read Accounts (as a stream)
  Stream<List<Account>> getAccountsStream() {
    return database.stream(primaryKey: ['id']).map((data) =>
        data.map((accountMap) => Account.fromMap(accountMap)).toList());
  }

  // Update Account (excluding password)
  Future<void> updateAccount(Account oldAccount, String newFname,
      String newLname, String newEmail) async {
    try {
      //Check for email uniqueness
      final existingEmail =
          await database.select('email').eq('email', newEmail);
      if (existingEmail.isNotEmpty &&
          existingEmail[0]['email'] != oldAccount.email) {
        throw Exception('Email already in use');
      }

      await database.update({
        'fname': newFname,
        'lname': newLname,
        'email': newEmail,
      }).eq('id', oldAccount.id!);
    } catch (e) {
      print('Error updating account: $e');
      throw Exception('Failed to update account: $e'); // Rethrow
    }
  }

  // Delete Account
  Future<void> deleteAccount(Account account) async {
    try {
      await database.delete().eq('id', account.id!);
    } catch (e) {
      print('Error deleting account: $e');
      throw Exception('Failed to delete account: $e'); // Rethrow
    }
  }

  //Update password.
  Future<void> updateUserPassword(String newPassword) async {
    try {
      await Supabase.instance.client.auth
          .updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      print('Error updating password: $e');
      throw Exception('Failed to update password: $e');
    }
  }

  //get user by email.
  Future<Account?> getAccountByEmail(String email) async {
    try {
      final response = await database.select().eq('email', email).single();
      if (response.isNotEmpty) {
        return Account.fromMap(response);
      }
      return null;
    } catch (e) {
      print("Error getting account by email: $e");
      return null;
    }
  }
}

// import 'package:quiz_app_project/model/account_model.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AccountDatabase {
//   final database = Supabase.instance.client.from('account');

//   //create
//   Future createAccount(Account newAccount) async {
//     await database.insert(newAccount.toMap());
//   }

//   //read
//     final stream = Supabase.instance.client.from('account').stream(
//       primaryKey: ['id'],
//     ).map(
//         (data) => data.map((accountMap) => Account.fromMap(accountMap)).toList());

//   //update
//   Future updateAccount(Account oldAccount, String newFname, String newLname,
//       String newEmail, String newPassword) async {
//     await database.update({
//       'fname': newFname,
//       'lname': newLname,
//       'email': newEmail,
//       'password': newPassword
//     }).eq('id', oldAccount.id!);
//   }

//   //delete
//   Future deleteAccount(Account account) async {
//     await database.delete().eq('id', account.id!);
//   }
// }

///////////////////////////////////////////////////////////////////////////////

// class Newww {
//   final accs = AccountDatabase();

//   final ferson = Account(
//       fname: "textcontroller.text",
//       lname: "textcontroller.text",
//       email: "textcontroller.text",
//       password: "textcontroller.text");

//   void create() {
//     accs.createAccount(ferson);
//   }
// }

// class Quizz {}
