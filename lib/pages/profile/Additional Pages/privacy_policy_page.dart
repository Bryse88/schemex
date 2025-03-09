import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
                    text: "Privacy Policy for Encite",
                    style: appStyle(15, Colors.white, FontWeight.bold),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "Last Updated: 8/05/2024",
                    style: appStyle(10, Colors.grey, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.1 Introduction",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "This Privacy Policy explains how Encite collects, uses, and discloses information about its users.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.2 Information Collection",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "Personal Information: We may collect personal information such as your name, email address, and age to ensure you meet the legal drinking age. Usage Data: Information on how the service is accessed and used may also be collected. Location Data: We may use location data to provide location-based services.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.3 Use of Information",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "Information collected is used to provide and maintain the service, notify you about changes to our service, allow you to participate in interactive features, provide customer support, gather analysis or valuable information so that we can improve the service, and monitor the usage of the service.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.4 Data Sharing and Disclosure",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "We do not sell your personal data. We may share personal information with third-party services for the purpose of improving our services, conducting business analysis, or for legal reasons.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.5 Data Security",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "The security of your data is important to us, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.6 Your data Protection Rights",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "Depending on your location, you may have certain data protection rights, including the right to access, update, or delete the information we have on you.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.7 Changes to this Privacy Policy",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  ResuableText(
                    text: "1.8 Contact Information",
                    style: appStyle(12, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    "If you have any questions about this Privacy Policy, please contact us at bryson@encite.net or www.encite.net.",
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
