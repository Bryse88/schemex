import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/resuable_text.dart';

class AllEventsWidget extends StatelessWidget {
  const AllEventsWidget({
    super.key,
    required this.image,
    required this.title,
    required this.EventName,
    required this.price,
    required this.onTap,
    required this.time,
    required String businessId,
  });

  final String image;
  final String title;
  final String EventName;
  final String price;
  final String time;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Container(
          width: width * 0.75,
          height: 190.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            // gradient: const LinearGradient(
            //   begin: Alignment.bottomCenter,
            //   end: Alignment.topCenter,
            //   colors: [
            //     Color.fromRGBO(1, 5, 25, 1), // Darker color at the bottom
            //     Color.fromRGBO(48, 55, 52, 1), // Lighter color towards the top
            //   ],
            // ),
            color: Colors.black12,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: SizedBox(
                        height: 112.h,
                        width: width * 0.75,
                        child: Image.network(image, fit: BoxFit.fitWidth),
                      ),
                    ),
                    // Positioned(
                    //   right: 10.w,
                    //   top: 10.h,
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(50.r),
                    //     child: Container(
                    //       color: Colors.white,
                    //       child: Padding(
                    //         padding: EdgeInsets.all(2.h),
                    //         child: ClipRRect(
                    //           borderRadius: BorderRadius.circular(50.r),
                    //           child: Image.network(
                    //             image,
                    //             fit: BoxFit.cover,
                    //             width: 35.w,
                    //             height: 35.h,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResuableText(
                      text: EventName,
                      style: appStyle(13, Colors.white, FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ResuableText(
                          text: title,
                          style: appStyle(
                            11,
                            const Color.fromARGB(255, 190, 189, 189),
                            FontWeight.w500,
                          ),
                        ),
                        ResuableText(
                          text: price,
                          style: appStyle(16, Colors.pink, FontWeight.w900),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ResuableText(
                          text: time,
                          style: appStyle(
                            9,
                            const Color.fromARGB(255, 190, 189, 189),
                            FontWeight.w500,
                          ),
                        ),
                      ],
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
