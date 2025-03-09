import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/resuable_text.dart';

class EventsTile extends StatelessWidget {
  const EventsTile({
    super.key,
    required this.price,
    required this.image,
    required this.title,
    required this.eventName,
    required this.time,
    this.onTap,
  });

  final String price;
  final String image;
  final String title;
  final String eventName;
  final String time;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Check if the price contains a percentage sign or a dollar sign
    final bool hasPercentageOrDollarSign =
        price.contains('%') || price.contains('\$');

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            height: 81.h,
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
                          child: Image.network(image, fit: BoxFit.cover),
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
                        text: eventName,
                        style: appStyle(13, Colors.white, FontWeight.w500),
                      ),
                      ResuableText(
                        text: hasPercentageOrDollarSign ? price : "\$$price",
                        style: appStyle(13, Colors.pink, FontWeight.w900),
                      ),
                      ResuableText(
                        text: title,
                        style: appStyle(11, Colors.white, FontWeight.w400),
                      ),
                      ResuableText(
                        text: time,
                        style: appStyle(11, Colors.white, FontWeight.w400),
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
