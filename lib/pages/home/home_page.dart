import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schemex/components/Gallery.dart';
import 'package:schemex/components/heading.dart';
import 'package:schemex/pages/home/Specialty%20Drinks/all_drinks_specialty_list.dart';
import 'package:schemex/pages/home/Specialty%20Drinks/all_drinks_specialty_page.dart';
import 'package:schemex/pages/home/Specialty%20Food/all_food_specialty_list.dart';
import 'package:schemex/pages/home/Specialty%20Food/all_food_specialty_page.dart';
import 'package:schemex/components/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Define keys for each widget
  Key galleryKey = UniqueKey();
  Key allDrinksSpecialKey = UniqueKey();
  Key allDrinkSpecialtyListKey = UniqueKey();
  Key allFoodSpecialsKey = UniqueKey();
  Key allFoodSpecialtyListKey = UniqueKey();

  // Refresh page function
  Future<void> _refreshPage() async {
    setState(() {
      // Generate new keys to force rebuild of widgets
      galleryKey = UniqueKey();
      allDrinksSpecialKey = UniqueKey();
      allDrinkSpecialtyListKey = UniqueKey();
      allFoodSpecialsKey = UniqueKey();
      allFoodSpecialtyListKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HomePageAppBar(titleText: 'SCHEME'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 60.w,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: h * 0.3, child: Gallery(key: galleryKey)),
                  Heading(
                    text: "Drink Specials",
                    color: Colors.white,
                    onTap: () {
                      Get.to(
                        AllDrinkSpecialsPage(),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 1000),
                      );
                    },
                  ),
                  AllDrinkSpecialtyList(key: allDrinkSpecialtyListKey),
                  SizedBox(height: h * 0.03),
                  Heading(
                    text: "Food Specials",
                    color: Colors.white,
                    onTap: () {
                      Get.to(
                        AllFoodSpecialsPage(),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 1000),
                      );
                    },
                  ),
                  AllFoodSpecialtyList(key: allFoodSpecialtyListKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
