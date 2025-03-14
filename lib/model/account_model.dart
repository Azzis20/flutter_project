class Account {
  int? id;
  String fname;
  String lname;
  String email;
  String password;

  Account({
    this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
  });

  // Map -> Account  or database to account object
  //Retrive info
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as int?,
      fname: map['fname'] as String,
      lname: map['lname'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  //Account -> Map   or Object to Database
  //Send data
  Map<String, dynamic> toMap() {
    return {
      'fname': fname,
      'lname': lname,
      'email': email,
      'password': password,
    };
  }
}
