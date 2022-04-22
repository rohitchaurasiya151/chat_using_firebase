import 'package:chat_using_firebase/FirebaseAuthServices/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  User? user;

  signUp(
      {required String name,
      required String password,
      required String email}) async {
    user = await FireAuth.registerUsingEmailPassword(
        name: name, email: email, password: password);
    notifyListeners();
  }
}
