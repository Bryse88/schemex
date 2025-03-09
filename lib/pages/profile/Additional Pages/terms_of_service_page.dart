import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    double size = 10;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black12,
          title: ResuableText(
            text: "Encite",
            style: appStyle(15, Colors.white, FontWeight.w600),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ), // Add horizontal padding
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the start (left)
                children: [
                  Container(
                    width: w,
                    height: h * 0.15,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/img/GFSDAMKO'.png"),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "Terms of Service for Encite",
                    style: appStyle(15, Colors.white, FontWeight.bold),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "Last Updated: 8/05/2024",
                    style: appStyle(10, Colors.grey, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.1 Acceptance of Terms",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "By accessing and using Encite, you agree to be bound by these Terms of Service and all applicable laws and regulations",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.2 Description of Services",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "Encite provides information about available specials at various local businesses. Users can view these items by business location and categorization type.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.3 User Responsibilities",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "Users must be of legal drinking age to use Encite to find alcohol. Users agree to use the information provided by the app responsibly and legally. Users must not use the app for any illegal or unauthorized purpose.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.4 Intellectual Property Rights",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "All content provided on the app, including text, graphics, logos, and images, is the property of Encite or its content suppliers and protected by international copyright laws. In addition, all user interactions with the app, including but not limited to actions, preferences, and behaviors, will be stored and utilized to enhance and personalize the user experience through the app's adaptability component. This data will be used to improve the app's recommendations and tailor content to the user's preferences. By using the app, you consent to the collection, storage, and use of this data as part of the app's functionality. ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.5 User-Generated Content",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "Users may be able to submit content to the app. By submitting content, users grant Encite a non-exclusive, royalty-free license to use, modify, publicly display, reproduce, and distribute such content on and through the app.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.6 Privacy Policy",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "User data will be handled in accordance with the app's Privacy Policy.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.7 Disclaimer of Warranties",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "The app is provided \"as is\" without warranty of any kind, either express or implied.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.8 Limitations of Liability",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "Encite shall not be liable for any indirect, incidental, special, consequential or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses, resulting from (a) your access to or use of or inability to access or use the app; (b) any conduct or content of any third party on the app; (c) any content obtained from the app; and (d) unauthorized access, use or alteration of your transmissions or content.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.9 Changes to Terms and Conditions",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "Encite reserves the right, at its sole discretion, to modify or replace these Terms at any time.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.10 Governing Law",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "These Terms shall be governed and construed in accordance with the laws of The United States, without regard to its conflict of law provisions.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.10 Governing Law",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "These Terms shall be governed and construed in accordance with the laws of the United States, without regard to its conflict of law provisions.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.11 Contact Information",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "If you have any questions about these Terms, please contact us at bryson@encite.net or www.encite.net.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
