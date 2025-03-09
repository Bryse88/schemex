import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/controllers/tab_index_controller.dart';
import 'package:schemex/pages/home/home_page.dart';
import 'package:schemex/pages/profile/profile_page.dart';
import 'package:schemex/pages/search/search_page.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  List<Widget> pageList = [const HomePage(), SearchPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final TabIndexController controller = Get.put(TabIndexController());

    return GradientBackground(
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              pageList[controller.tabIndex],
              Align(
                alignment: Alignment.bottomCenter,
                child: Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.white),
                  child: BottomNavigationBar(
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    selectedItemColor: Colors.pink,
                    unselectedItemColor: Colors.black,
                    onTap: (value) {
                      controller.setTabIndex = value;
                    },
                    currentIndex: controller.tabIndex,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(
                          controller.tabIndex == 0
                              ? AntDesign.appstore1
                              : AntDesign.appstore_o,
                        ),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          controller.tabIndex == 1
                              ? AntDesign.search1
                              : AntDesign.search1,
                        ),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          controller.tabIndex == 2
                              ? FontAwesome.user_circle
                              : FontAwesome.user_circle_o,
                        ),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
