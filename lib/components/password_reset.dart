import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/my_textfield.dart';
import 'package:schemex/components/resuable_text.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final emailController = TextEditingController();

  void resetPassword() async {
    final email = emailController.text;
    if (email.isEmpty) {
      showErrorMessage("Please enter your email");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Use a local variable to store the context before the async gap
      final localContext = context;

      showDialog(
        context: localContext,
        builder: (context) {
          return AlertDialog(
            title: const Text('Password Reset'),
            content: Text('A password reset link has been sent to $email.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(
                    localContext,
                  ).pop(); // Navigate back to the login page
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message ?? "An error occurred");
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.pink,
          title: Center(
            child: Text(message, style: const TextStyle(color: Colors.black)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: h * 0.1),
            ResuableText(
              text: "Reset Password",
              style: appStyle(30, Colors.black, FontWeight.bold),
            ),
            SizedBox(height: h * 0.05),
            MyTextField(
              controller: emailController,
              hintText: "Enter your email",
              obscureText: false,
              icon: const Icon(Icons.email, color: Colors.black),
            ),
            SizedBox(height: h * 0.02),
            ElevatedButton(
              onPressed: resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Container(
                width: w * 0.3,
                height: h * 0.02,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.pink,
                ),
                child: const Center(
                  child: Text(
                    "Send Reset Link",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: AutofillHints.birthdayDay,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
