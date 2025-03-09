import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/resuable_text.dart';

class Heading extends StatelessWidget {
  const Heading({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
  });

  final String text;
  final void Function()? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: ResuableText(
              text: text,
              style: appStyle(16, color, FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24), // Circular ripple effect
            child: Padding(
              padding: const EdgeInsets.all(
                8.0,
              ), // Padding for a larger touch area
              child: Icon(AntDesign.appstore1, color: color, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
