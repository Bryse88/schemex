import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddPhoneNumber extends StatefulWidget {
  AddPhoneNumber({super.key});

  @override
  _AddPhoneNumberState createState() => _AddPhoneNumberState();
}

class _AddPhoneNumberState extends State<AddPhoneNumber> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final User? _user = FirebaseAuth.instance.currentUser!;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Phone number mask formatter
  var phoneFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _fetchPhoneNumber();
  }

  // Fetch the phone number from Firestore and set it in the text field
  Future<void> _fetchPhoneNumber() async {
    if (_user != null) {
      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid);
      try {
        DocumentSnapshot snapshot = await userDoc.get();
        if (snapshot.exists) {
          String? phoneNumber = snapshot.get('phone');
          if (phoneNumber != null) {
            _phoneNumberController.text =
                phoneFormatter
                    .formatEditUpdate(
                      TextEditingValue.empty,
                      TextEditingValue(text: phoneNumber),
                    )
                    .text;
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching phone number')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Add Phone Number',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _phoneNumberController,
                  inputFormatters: [phoneFormatter], // Apply the formatter here
                  decoration: const InputDecoration(
                    labelText: 'New Number',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^\(\d{3}\) \d{3}-\d{4}$').hasMatch(value)) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h * 0.03),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _updatePhoneNumber(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Update Phone Number",
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
      ),
    );
  }

  void _updatePhoneNumber(BuildContext context) async {
    String phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isNotEmpty) {
      if (_user != null) {
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid);

        try {
          // Update the phone number in Firestore
          await userDoc.update({'phone': phoneNumber});
          Get.back(); // Close the page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number updated successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error updating phone number')),
          );
        }
      }
    }
  }
}
