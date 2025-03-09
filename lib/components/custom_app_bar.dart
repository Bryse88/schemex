import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/resuable_text.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  const HomePageAppBar({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ResuableText(
            text: titleText,
            style: TextStyle(
              fontFamily: 'Kalam',
              fontSize: 19.sp,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0, // Removes shadow under the AppBar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
