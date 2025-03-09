import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/pages/Login_SignUp/login_page.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  // Function to store the user's data in Firestore before deletion
  Future<void> storeDeletedUserData(User? user) async {
    if (user != null) {
      // Reference to Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Reference to the new Deleted User Data collection
      final deletedUserRef = firestore
          .collection('Deleted User Data')
          .doc(user.uid);

      // Store basic user information in the Deleted User Data collection
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'phoneNumber':
            user.phoneNumber ?? '', // Save the phone number if it exists
        'deletedAt':
            FieldValue.serverTimestamp(), // Track when the user was deleted
      };

      // Save the basic user data to Firestore
      await deletedUserRef.set(userData);
    }
  }

  // Function to delete user data from Firestore (users -> document: UID)
  Future<void> deleteOriginalUserData(User? user) async {
    if (user != null) {
      // Reference to Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Delete the entire user document from the 'users' collection, including sub-collections
      await firestore.collection('users').doc(user.uid).delete();
    }
  }

  // Function to delete the user's Firebase account and store their data
  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Step 1: Store user data before deletion
      await storeDeletedUserData(user);

      // Step 2: Delete the user's original data from Firestore
      await deleteOriginalUserData(
        user,
      ); // This deletes the user's document and sub-collections

      // Step 3: Delete the user's Firebase Auth account
      await user?.delete();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );

      // Redirect to the login page or another screen
      Get.offAll(() => LoginPage()); // Assuming you use GetX for navigation
    } catch (e) {
      // Handle errors (e.g., reauthentication required)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete account: $e')));
    }
  }

  // Function to show the confirmation dialog
  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Colors.redAccent, // Set background color for the dialog
          title: Text(
            "Delete Account",
            style: appStyle(18, Colors.white, FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await deleteUserAccount(
                  context,
                ); // Call the function to delete the user and store data
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: appStyle(16, Colors.white, FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: appStyle(16, Colors.white, FontWeight.normal),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
      minTextAdapt: true,
    );

    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make the AppBar transparent
        elevation: 0, // Remove shadow for full transparency
        title: Text(
          "Delete Account",
          style: appStyle(22, Colors.white, FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  'Are you sure you want to delete your account? This action is irreversible.',
                  style: appStyle(18, Colors.white, FontWeight.bold),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                    horizontal: 50.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed:
                    () => _confirmDeleteAccount(
                      context,
                    ), // Show confirmation dialog on press
                child: Text(
                  'Delete Account',
                  style: appStyle(18, Colors.white, FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: appStyle(18, Colors.white, FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
