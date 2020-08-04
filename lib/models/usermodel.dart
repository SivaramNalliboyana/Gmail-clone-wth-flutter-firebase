import 'package:flumail/utils/variables.dart';

class User {
  storeuser(user, email, password, username, profilepic) {
    users.document(email).setData({
      'uid': user.uid,
      'email': email,
      'username': username,
      'password': password,
      'profilepic': profilepic,
    });
  }
}
