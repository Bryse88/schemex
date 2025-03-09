import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:schemex/components/error_page.dart';

void safeNavigate(BuildContext context, Widget destination) {
  try {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => destination));
  } catch (error, stackTrace) {
    // Record the error in Firebase Crashlytics
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);

    // Navigate to the 504 error page
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => Error504Page()));
  }
}
