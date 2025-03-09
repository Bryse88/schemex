import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';

class Error504Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: ResuableText(
            text: 'Oops!',
            style: appStyle(24.sp, Colors.white, FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error_outline, size: 40.w, color: Colors.red),
              ),
              SizedBox(height: 24.h),
              Center(
                child: ResuableText(
                  text: '504 Gateway Timeout',
                  style: appStyle(18.sp, Colors.white, FontWeight.bold),
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: ResuableText(
                  text: 'Sorry, please try again later',
                  style: appStyle(16.sp, Colors.white, FontWeight.normal),
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: ResuableText(
                  text: 'Go Back',
                  style: appStyle(16.sp, Colors.white, FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
