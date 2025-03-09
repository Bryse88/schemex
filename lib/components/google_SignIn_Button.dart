import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Add your Google Sign-In logic here
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFF747775)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Continue with Google',
            style: TextStyle(
              color: Color(0xFF1F1F1F),
              fontFamily: 'Roboto',
              fontSize: 14,
              letterSpacing: 0.25,
            ),
          ),
        ),
      ),
    );
  }
}
