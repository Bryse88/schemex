import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schemex/pages/Login_SignUp/login_page.dart';
import 'package:schemex/pages/entrypoint.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if user is logged in
          if (snapshot.hasData) {
            return MainScreen();
          }
          // user is not logged in
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
