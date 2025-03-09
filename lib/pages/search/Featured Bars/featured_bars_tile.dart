import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/resuable_text.dart';

class FeaturedBarsTile extends StatelessWidget {
  const FeaturedBarsTile({
    super.key,
    required this.logo,
    required this.title,
    required this.adress,
    required this.time,
    this.onTap,
    required this.businessID,
  });

  final String logo;
  final String title;
  final String adress;
  final String time;
  final String businessID;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // bool isBarAvailable = time != 'Closed' && time != 'Unavailable';

    // Find the corresponding bars
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            height: 78.h,
            width: width,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Container(
              padding: EdgeInsets.all(4.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 70.w,
                          width: 70.w,
                          child: Image.network(logo, fit: BoxFit.cover),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.only(left: 6.w, bottom: 2.h),
                            color: Colors.transparent,
                            height: 16.h,
                            width: width,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResuableText(
                        text: title,
                        style: appStyle(11, Colors.white, FontWeight.w500),
                      ),
                      ResuableText(
                        text: time,
                        style: appStyle(9, Colors.white, FontWeight.w500),
                      ),
                      ResuableText(
                        text: adress,
                        style: appStyle(9, Colors.white, FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
