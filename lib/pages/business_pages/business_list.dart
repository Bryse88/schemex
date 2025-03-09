import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/businessHours.dart';
import 'package:schemex/components/circular_icon.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/heading.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/pages/business_pages/Widgets/Drink%20Specialty/drink_specials_page.dart';
import 'package:schemex/pages/business_pages/Widgets/Drink%20Specialty/drink_specialty_list.dart';
import 'package:schemex/pages/business_pages/Widgets/Events/event_list.dart';
import 'package:schemex/pages/business_pages/Widgets/Events/event_page.dart';
import 'package:schemex/pages/business_pages/Widgets/Food%20Specialty/food_specialty_list.dart';
import 'package:schemex/pages/business_pages/Widgets/Food%20Specialty/food_specialty_page.dart';
import 'package:schemex/pages/business_pages/business.dart';
import 'package:schemex/pages/business_pages/business_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessListScreen extends StatelessWidget {
  final String businessId;
  final String imagePath = "lib/img/instagram_logoo.png";
  final String imagePath1 = "lib/img/phone1.png";
  final String imagePath2 = "lib/img/website1.png";
  final String imagePath3 = "lib/img/menu_icon.png";
  BusinessHours businessHours = BusinessHours();

  // Existing methods...

  call(Business business) async {
    String phoneNumber = business.phoneNumber.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    ); // Remove any non-numeric characters
    String phoneUrl = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(Uri.parse(phoneUrl));
    } else {
      // Handle the error or show a message if the phone call can't be made
      //print('Could not launch $phoneUrl');
    }
  }

  openInstagram(Business business) async {
    String instagramUrl = 'https://www.instagram.com/${business.instagram}';
    if (await canLaunchUrl(Uri.parse(instagramUrl))) {
      await launchUrl(Uri.parse(instagramUrl));
    } else {
      // Handle the error or show a message if the Instagram app can't be opened
      //print('Could not launch $instagramUrl');
    }
  }

  openWebsite(Business business) async {
    String websiteUrl = business.website;
    if (await canLaunchUrl(Uri.parse(websiteUrl))) {
      await launchUrl(Uri.parse(websiteUrl));
    } else {
      // Handle the error or show a message if the website can't be opened
      //print('Could not launch $websiteUrl');
    }
  }

  openMenu(Business business) async {
    String menuUrl =
        business
            .menuUrl; // Assuming 'menuUrl' is the field in your Business class that contains the menu URL
    if (await canLaunchUrl(Uri.parse(menuUrl))) {
      await launchUrl(Uri.parse(menuUrl));
    } else {
      // Handle the error or show a message if the menu URL can't be opened
      //print('Could not launch $menuUrl');
    }
  }

  openMap(String address) async {
    String encodedAddress = Uri.encodeComponent(address);
    String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$encodedAddress";
    String appleMapsUrl = "http://maps.apple.com/?q=$encodedAddress";

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
      await launchUrl(Uri.parse(appleMapsUrl));
    } else {
      // Handle the error or show a message if neither Google Maps nor Apple Maps can be opened
      //print('Could not launch map for $address');
    }
  }

  BusinessListScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return FutureBuilder<Business?>(
      future: BusinessService().fetchBusinessById(businessId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('No business found')));
        }

        Business business = snapshot.data!;

        // Create a list of available icons
        List<Widget> availableIcons = [];
        if (business.instagram.isNotEmpty) {
          availableIcons.add(
            CircularIcon(
              imagePath: imagePath,
              onTap: () => openInstagram(business),
            ),
          );
        }
        if (business.phoneNumber.isNotEmpty) {
          availableIcons.add(
            CircularIcon(imagePath: imagePath1, onTap: () => call(business)),
          );
        }
        if (business.website.isNotEmpty) {
          availableIcons.add(
            CircularIcon(
              imagePath: imagePath2,
              onTap: () => openWebsite(business),
            ),
          );
        }
        if (business.menuUrl.isNotEmpty) {
          // Add the menu icon if a menu URL is available
          availableIcons.add(
            CircularIcon(
              imagePath: imagePath3,
              onTap: () => openMenu(business),
            ),
          );
        }

        return GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: ResuableText(
                text: business.name,
                style: appStyle(20, Colors.white, FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(
                color: Colors.white, // Change this to your desired color
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SafeArea(
                      //child: Padding(
                      // padding: EdgeInsets.only(
                      //     bottom: MediaQuery.of(context).padding.bottom),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            width: w * .9,
                            height: 250,
                            imageUrl: business.logoUrl,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    //),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: availableIcons,
                    ),
                    SizedBox(height: h * 0.04),
                    GestureDetector(
                      onTap: () => openMap(business.adress),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 2.0,
                            ), // Adjust the space between text and underline
                            child: ResuableText(
                              text: business.adress,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                // No underline here; we're adding a custom one
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0, // Align the underline
                            child: Container(
                              width:
                                  business.adress.length *
                                  8.0, // Adjust width to fit the text
                              height: 1.0, // Height of the underline
                              color: Colors.white, // Color of the underline
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.02),
                    FutureBuilder<String>(
                      future: businessHours.getBusinessHours(businessId),
                      builder: (context, hoursSnapshot) {
                        if (hoursSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return ResuableText(
                          text: hoursSnapshot.data ?? 'Unavailable',
                          style: appStyle(15, Colors.white, FontWeight.w400),
                        );
                      },
                    ),

                    SizedBox(height: h * 0.02),
                    Heading(
                      text: "Drink Specials",
                      color: Colors.white,
                      onTap: () {
                        Get.to(
                          DrinkSpecialsPage(businessId: businessId),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 1000),
                        );
                      },
                    ),
                    DrinkSpecialtyList(businessId: businessId),
                    SizedBox(height: h * 0.02),
                    Heading(
                      text: "Food Specials",
                      color: Colors.white,
                      onTap: () {
                        Get.to(
                          FoodSpecialsPage(businessId: businessId),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 1000),
                        );
                      },
                    ),
                    FoodSpecialtyList(businessId: businessId),
                    SizedBox(height: h * 0.02),
                    Heading(
                      text: "Events",
                      color: Colors.white,
                      onTap: () {
                        Get.to(
                          EventsPage(businessId: businessId),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 1000),
                        );
                      },
                    ),
                    EventsList(businessId: businessId),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
