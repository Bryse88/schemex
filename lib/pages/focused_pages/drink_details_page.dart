import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/safe_navigation.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/controllers/category_controller.dart';
import 'package:schemex/pages/business_pages/business_list.dart';

class DrinkDetailsPage extends StatelessWidget {
  final String image;
  final String logo;
  final String title;
  final String itemName;
  final String price;
  final String time;
  final List<Map<String, dynamic>?> categoryDataList;
  final String description;
  final String businessId;

  final UserDataService _userDataService = UserDataService();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  DrinkDetailsPage({
    super.key,
    required this.image,
    required this.logo,
    required this.title,
    required this.itemName,
    required this.price,
    required this.time,
    required this.categoryDataList,
    this.description = '',
    required this.businessId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final bool hasPercentageOrDollarSign =
        price.contains('%') || price.contains('\$');

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: ResuableText(
            text: title,
            style: appStyle(20, Colors.white, FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            width: w * 0.9,
                            height: 250,
                            imageUrl: image,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        ),
                        SizedBox(height: 0.04 * h),
                        ResuableText(
                          text: itemName,
                          style: appStyle(18, Colors.white, FontWeight.bold),
                        ),
                        SizedBox(height: 0.02 * h),
                        ResuableText(
                          text: hasPercentageOrDollarSign ? price : "\$$price",
                          style: appStyle(20, Colors.pink, FontWeight.w900),
                        ),
                        SizedBox(height: 0.02 * h),
                        ResuableText(
                          text: "Time: $time",
                          style: appStyle(16, Colors.white, FontWeight.normal),
                        ),
                        SizedBox(height: 0.02 * h),
                        for (var categoryData in categoryDataList)
                          if (categoryData != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      width: 50,
                                      height: 50,
                                      imageUrl: categoryData?['URL'] ?? '',
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) =>
                                              const CircularProgressIndicator(),
                                      errorWidget:
                                          (context, url, error) =>
                                              const Icon(Icons.error),
                                    ),
                                  ),
                                  SizedBox(width: 0.01 * h),
                                  ResuableText(
                                    text:
                                        categoryData?['Name'] ??
                                        'Unknown Category',
                                    style: appStyle(
                                      16,
                                      Colors.white,
                                      FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        SizedBox(height: 0.03 * h),
                        if (description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              description,
                              style: appStyle(
                                14,
                                Colors.white,
                                FontWeight.normal,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    onPressed: () {
                      safeNavigate(
                        context,
                        BusinessListScreen(businessId: businessId),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    label: ResuableText(
                      text: "Go to Bar Page",
                      style: appStyle(15, Colors.white, FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
