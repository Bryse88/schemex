import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/my_button_logout.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/controllers/user_controller.dart';
import 'package:schemex/pages/profile/Additional%20Pages/add_phone_number_page.dart';
import 'package:schemex/pages/profile/Additional%20Pages/change_name_page.dart';
import 'package:schemex/pages/profile/Additional%20Pages/delete_account.dart';
import 'package:schemex/pages/profile/Additional%20Pages/notification_page.dart';
import 'package:schemex/pages/profile/Additional%20Pages/privacy_policy_page.dart';
import 'package:schemex/pages/profile/Additional%20Pages/terms_of_service_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final UserController userController = Get.find<UserController>();

  // Sign user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive design
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
      minTextAdapt: true,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: ResuableText(
          text: "Profile",
          style: appStyle(20.sp, Colors.white, FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              CircleAvatar(
                radius: 65.w,
                backgroundColor: Colors.transparent,
                backgroundImage: const AssetImage("lib/img/GFSDAMKO'.png"),
              ),
              SizedBox(height: 30.h),
              Obx(() {
                var user = userController.user; // Access the user directly
                return Column(
                  children: [
                    ResuableText(
                      text: user?.displayName ?? "No Name",
                      style: appStyle(15.sp, Colors.white, FontWeight.bold),
                    ),
                  ],
                );
              }),
              SizedBox(height: 30.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ResuableText(
                    text: "Edit your profile",
                    style: appStyle(14.sp, Colors.white, FontWeight.normal),
                  ),
                ),
              ),
              _buildListTile(
                context,
                icon: Icons.edit,
                title: "Change my Name",
                onTap: () async {
                  await Get.to(
                    () => ChangeNamePage(),
                    transition: Transition.cupertino,
                  );
                  userController.updateDisplayName(
                    userController.user?.displayName ?? "",
                  );
                },
              ),
              _buildListTile(
                context,
                icon: Icons.phone,
                title: "Add my Phone Number",
                onTap: () async {
                  await Get.to(
                    () => AddPhoneNumber(),
                    transition: Transition.cupertino,
                  );
                  userController.updatePhoneNumber(
                    userController.user?.phoneNumber ?? "",
                  );
                },
              ),
              SizedBox(height: 30.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ResuableText(
                    text: "Settings",
                    style: appStyle(14.sp, Colors.white, FontWeight.normal),
                  ),
                ),
              ),
              _buildListTile(
                context,
                icon: Icons.notifications,
                title: "Notifications settings",
                onTap:
                    () => Get.to(
                      () => NotificationPage(),
                      transition: Transition.cupertino,
                    ),
              ),
              _buildListTile(
                context,
                icon: Icons.delete_forever,
                title: "Delete Account",
                onTap:
                    () => Get.to(
                      () => DeleteAccountPage(),
                      transition: Transition.cupertino,
                    ),
              ),
              SizedBox(height: 30.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ResuableText(
                    text: "About",
                    style: appStyle(14.sp, Colors.white, FontWeight.normal),
                  ),
                ),
              ),
              _buildListTile(
                context,
                icon: Icons.info,
                title: "Terms of Service",
                onTap:
                    () => Get.to(
                      () => TermsOfService(),
                      transition: Transition.cupertino,
                    ),
              ),
              _buildListTile(
                context,
                icon: Icons.privacy_tip,
                title: "Privacy Policy",
                onTap:
                    () => Get.to(
                      () => PrivacyPolicy(),
                      transition: Transition.cupertino,
                    ),
              ),
              SizedBox(height: 30.h),
              MyButtonLogout(onPressed: signUserOut, text: "Sign Out"),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.white, size: 24.sp),
      title: ResuableText(
        text: title,
        style: appStyle(14.sp, Colors.white, FontWeight.normal),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
        size: 24.sp,
      ),
    );
  }
}
