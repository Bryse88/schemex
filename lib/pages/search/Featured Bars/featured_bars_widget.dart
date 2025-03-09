import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/safe_navigation.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/pages/business_pages/business_list.dart';

class FeaturedBarsWidget extends StatelessWidget {
  FeaturedBarsWidget({
    super.key,
    required this.logo,
    required this.title,
    required this.adress,
    required this.time,
    required this.onTap,
    required this.businessId,
  });

  final String logo;
  final String title;
  final String adress;
  final String time;
  final VoidCallback? onTap;
  final String businessId;
  final UserDataService _userDataService = UserDataService();

  void move(BuildContext context, String document) {
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      // Log the user interaction
      _userDataService.logUserInteraction(
        userId: userId,
        action: 'selected_bar',
        businessName: title,
        businessId: businessId,
      );
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => BusinessListScreen(businessId: document),
    //   ),
    // );
    // Use the safeNavigate function to handle navigation
    safeNavigate(context, BusinessListScreen(businessId: document));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => move(context, businessId),
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Container(
          width: width * 0.75,
          height: 190.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.black12,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    height: 112.h,
                    width: width * 0.75,
                    child: Image.network(logo, fit: BoxFit.fitWidth),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResuableText(
                      text: title,
                      style: appStyle(13, Colors.white, FontWeight.w600),
                    ),
                    ResuableText(
                      text: time,
                      style: appStyle(
                        9,
                        const Color.fromARGB(255, 190, 189, 189),
                        FontWeight.w500,
                      ),
                    ),
                    ResuableText(
                      text: adress,
                      style: appStyle(
                        9,
                        const Color.fromARGB(255, 190, 189, 189),
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
