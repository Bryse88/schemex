import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    // Bind the firebaseUser to FirebaseAuth user changes
    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());
  }

  User? get user => firebaseUser.value;

  // Method to update the display name of the user
  Future<void> updateDisplayName(String newName) async {
    try {
      await user?.updateDisplayName(newName);
      await user?.reload(); // Reload the user to ensure changes are reflected
      firebaseUser.value =
          FirebaseAuth.instance.currentUser; // Update the local user
    } catch (e) {
      Get.snackbar("Error", "Failed to update display name: $e");
    }
  }

  // Method to update the phone number of the user
  Future<void> updatePhoneNumber(String newPhone) async {
    try {
      // Since Firebase does not allow directly updating the phone number through the User object,
      // you would typically update it in your Firestore database or wherever you're storing user data.
      // This example assumes you have a Firestore document to update the phone number.
      // You may also need to re-authenticate the user to update the phone number.

      // Example: Update the phone number in Firestore (assuming you have a user collection)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'phone': newPhone});

      // Assuming you might reload the user here if necessary
      firebaseUser.value = FirebaseAuth.instance.currentUser;
    } catch (e) {
      Get.snackbar("Error", "Failed to update phone number: $e");
    }
  }
}
