import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schemex/components/gradient_background.dart';

class ChangeNamePage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  ChangeNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Change Name',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'New Name'),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: h * 0.03),
              ElevatedButton(
                onPressed: () => _changeName(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Update Name",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontFamily: AutofillHints.birthdayDay,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeName(BuildContext context) async {
    String newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        // Update the display name in Firebase Authentication
        await user?.updateDisplayName(newName);
        await user?.reload(); // Ensure the local user instance is updated

        // Update the name in Firestore
        if (user != null) {
          DocumentReference userDoc = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid);

          await userDoc.update({'name': newName});
        }

        Get.back(); // Return to the previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error updating name')));
      }
    }
  }
}
