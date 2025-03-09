import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/controllers/category_controller.dart';
import 'package:schemex/pages/search/category_page.dart';
import 'package:schemex/pages/search/widgets/all_categories.dart';

class CategoryWidget extends StatelessWidget {
  final DocumentSnapshot category;
  final double width;
  final UserDataService _userDataService = UserDataService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  CategoryWidget({super.key, required this.category, required this.width});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    Map<String, dynamic> categoryData = category.data() as Map<String, dynamic>;

    return GestureDetector(
      onTap: () {
        if (controller.categoryValue == category.id) {
          controller.updateCategory = '';
          controller.updateTitle = '';
        } else if (categoryData['Name'] == 'More') {
          Get.to(
            () => AllCategories(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500),
          );
        } else {
          controller.updateCategory = category.id;
          controller.updateTitle = categoryData["Name"];
          // Log user interaction
          if (userId != null) {
            _userDataService.logUserInteraction(
              userId: userId!,
              action: 'selected_category',
              categoryNames: [categoryData["Name"]],
            );
          }
          // Navigate to the CategoryPage
          Get.to(
            () => CategoryPage(
              categoryName: categoryData["Name"],
              categoryId: category.id,
            ),
            duration: const Duration(milliseconds: 900),
          );
        }
      },
      child: Obx(
        () => Container(
          margin: EdgeInsets.only(right: 5.w),
          padding: EdgeInsets.only(top: 4.h),
          width: width * 0.19,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color:
                  controller.categoryValue == category.id
                      ? Colors
                          .transparent // Border color when selected
                      : Colors.transparent, // Border color when not selected
              width: .5.w,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 35.h,
                child: Image.network(categoryData["URL"], fit: BoxFit.contain),
              ),
              SizedBox(height: 5.h),
              ResuableText(
                text: categoryData["Name"],
                style: appStyle(12, Colors.white, FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
