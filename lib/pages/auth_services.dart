import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:schemex/pages/Login_SignUp/checking_page.dart'; // Adjust this import based on your project structure

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign-In with Google
  Future<User?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null; // User canceled the sign-in

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      if (user != null) {
        await _handleUserData(user, user.displayName ?? '', user.email ?? '');
      }

      return user;
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  // Sign-In with Apple
  Future<User?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        oAuthCredential,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Use the provided full name and email only if it's the first sign-in
        String fullName =
            "${credential.givenName ?? ''} ${credential.familyName ?? ''}"
                .trim();
        String email = credential.email ?? ''; // Apple's email (first sign-in)

        await _handleUserData(user, fullName, email);
      }

      return user;
    } catch (e) {
      print('Error during Apple Sign-In: $e');
      return null;
    }
  }

  // Handle user data and navigate accordingly
  Future<void> _handleUserData(User user, String name, String email) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    // If the user document doesn't exist, create a new one
    if (userData == null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name.isNotEmpty ? name : '', // Only set name if provided
        'email': email.isNotEmpty ? email : '', // Only set email if provided
      });

      Get.to(() => CompleteProfilePage(user: user));
    } else if (userData['name'] == '' ||
        !userData.containsKey('agreedToPrivacyPolicy') ||
        !userData.containsKey('agreedToTermsOfService')) {
      Get.to(() => CompleteProfilePage(user: user));
    } else {
      Get.offAllNamed('/home');
    }
  }
}
