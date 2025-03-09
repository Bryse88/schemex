import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/controllers/user_controller.dart';
import 'package:schemex/pages/entrypoint.dart';
import 'package:schemex/pages/profile/Additional%20Pages/privacy_policy_page.dart';
import 'package:schemex/pages/profile/Additional%20Pages/terms_of_service_page.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class CompleteProfilePage extends StatefulWidget {
  final User user;

  CompleteProfilePage({required this.user});

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final UserController userController = Get.find<UserController>();

  bool agreeToPrivacyPolicy = false;
  bool agreeToTermsOfService = false;
  DateTime? completionDate; // Field to store the completion date
  bool isLoading = false; // Loading state

  // Phone number mask formatter
  var phoneFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();

    // Pre-fill the form with the existing user data (if available)
    phoneController.text =
        phoneFormatter
            .formatEditUpdate(
              TextEditingValue.empty,
              TextEditingValue(text: widget.user.phoneNumber ?? ''),
            )
            .text;
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateFirestore() async {
    completionDate = DateTime.now(); // Set the completion date to now

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({
          'phone': phoneFormatter.getMaskedText(),
          'agreedToPrivacyPolicy': agreeToPrivacyPolicy,
          'agreedToTermsOfService': agreeToTermsOfService,
          'profileCompletionDate': completionDate, // Save the completion date
        });

    // Update UserController for reflecting changes
    userController.updatePhoneNumber(phoneController.text);

    // Navigate to the home page or another appropriate page
    Get.offAll(() => MainScreen());
  }

  Future<void> _submitProfile() async {
    setState(() {
      isLoading = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      if (!agreeToPrivacyPolicy || !agreeToTermsOfService) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You must agree to the privacy policy and terms of service',
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Save the data directly to Firestore
      await _updateFirestore();

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ResuableText(
                      text: "Complete Your Profile",
                      style: appStyle(24, Colors.white, FontWeight.w600),
                    ),
                    SizedBox(height: 30.h),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [phoneFormatter],
                      decoration: InputDecoration(
                        labelText: 'Phone Number (Optional)',
                        labelStyle: appStyle(10, Colors.white, FontWeight.w400),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        suffixIcon:
                            phoneController.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => phoneController.clear(),
                                )
                                : null,
                      ),
                      style: appStyle(10, Colors.white, FontWeight.w400),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(
                            r'^\(\d{3}\) \d{3}-\d{4}$',
                          ).hasMatch(value)) {
                            return 'Enter a valid phone number';
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(
                          () {},
                        ); // Refresh to show/hide the clear button
                      },
                    ),
                    SizedBox(height: 20.h),
                    // Checkbox for Privacy Policy and Terms of Service
                    _buildCheckbox(
                      'Privacy Policy',
                      agreeToPrivacyPolicy,
                      () {
                        setState(() {
                          agreeToPrivacyPolicy = !agreeToPrivacyPolicy;
                        });
                      },
                      () => Get.to(() => PrivacyPolicy()),
                    ),
                    _buildCheckbox(
                      'Terms of Service',
                      agreeToTermsOfService,
                      () {
                        setState(() {
                          agreeToTermsOfService = !agreeToTermsOfService;
                        });
                      },
                      () => Get.to(() => TermsOfService()),
                    ),
                    SizedBox(height: 20.h),
                    // Display the completion date if available
                    if (completionDate != null)
                      ResuableText(
                        text:
                            'Profile completed on ${DateFormat.yMMMd().format(completionDate!)}',
                        style: appStyle(12, Colors.white, FontWeight.w400),
                      ),
                    SizedBox(height: 20.h),
                    isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: _submitProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: ResuableText(
                            text: "Submit",
                            style: appStyle(10, Colors.white, FontWeight.w600),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    Function onChanged,
    Function onTap,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? value) => onChanged(),
          activeColor: Colors.pink,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onTap(),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "I agree to the ",
                    style: appStyle(10, Colors.white, FontWeight.w400),
                  ),
                  TextSpan(
                    text: label,
                    style: appStyle(10, Colors.white, FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
