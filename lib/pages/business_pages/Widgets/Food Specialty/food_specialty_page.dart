import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/safe_navigation.dart';
import 'package:schemex/components/service_hours.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/pages/business_pages/Widgets/Food%20Specialty/food_specialty_tile.dart';
import 'package:schemex/pages/focused_pages/drink_details_page.dart';

class FoodSpecialsPage extends StatelessWidget {
  FoodSpecialsPage({super.key, required this.businessId});
  final UserDataService _userDataService = UserDataService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  final String businessId;

  Stream<List<QuerySnapshot>> _mergedStream(String businessId) {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());
    DocumentReference businessRef = FirebaseFirestore.instance.doc(
      "Businesses/$businessId",
    );

    Stream<QuerySnapshot> regularsStream =
        FirebaseFirestore.instance
            .collection('Specialty Food')
            .doc(dayOfWeek)
            .collection('Regulars')
            .where('businessID', isEqualTo: businessRef)
            .snapshots();

    Stream<QuerySnapshot> happyHourStream =
        FirebaseFirestore.instance
            .collection('Specialty Food')
            .doc('Happy Hour')
            .collection('Mon-Fri')
            .where('businessID', isEqualTo: businessRef)
            .snapshots();

    Stream<QuerySnapshot> dailyStream =
        FirebaseFirestore.instance
            .collection('Specialty Food')
            .doc('Everyday')
            .collection('Regulars')
            .where('businessID', isEqualTo: businessRef)
            .snapshots();

    List<Stream<QuerySnapshot>> streams = [regularsStream, dailyStream];

    // Check if today is a weekday (Monday to Friday)
    if (dayOfWeek != 'Saturday' && dayOfWeek != 'Sunday') {
      streams.add(happyHourStream);
    }

    return StreamZip(streams);
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference businessRef = FirebaseFirestore.instance.doc(
      "Businesses/$businessId",
    );
    ServiceHours businessHoursService = ServiceHours();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black12,
          title: ResuableText(
            text: "Food Specials",
            style: appStyle(15, Colors.white, FontWeight.w600),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
        ),
        body: StreamBuilder<List<QuerySnapshot>>(
          stream: _mergedStream(businessId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> allFoods =
                snapshot.data!
                    .expand((querySnapshot) => querySnapshot.docs)
                    .toList();

            if (allFoods.isEmpty) {
              return Center(
                child: ResuableText(
                  text: 'No specialty food available',
                  style: appStyle(16.sp, Colors.white, FontWeight.bold),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(12.h),
              itemCount: allFoods.length,
              itemBuilder: (context, index) {
                DocumentSnapshot food = allFoods[index];
                Map<String, dynamic> foodData =
                    food.data() as Map<String, dynamic>;

                // Extract the Category document references from the array
                List<DocumentReference>? categoryRefs =
                    foodData['Category']?.cast<DocumentReference>();

                return FutureBuilder<DocumentSnapshot>(
                  future: businessRef.get(),
                  builder: (context, businessSnapshot) {
                    if (businessSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (businessSnapshot.hasError ||
                        !businessSnapshot.data!.exists) {
                      return const Text('Business data not available');
                    }

                    Map<String, dynamic> businessData =
                        businessSnapshot.data!.data() as Map<String, dynamic>;

                    return FutureBuilder<String>(
                      future: businessHoursService.getBusinessHours(
                        businessId,
                        specialTime: foodData['Time'],
                      ),
                      builder: (context, timeSnapshot) {
                        if (timeSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        String time = timeSnapshot.data ?? 'Unavailable';

                        return FutureBuilder<List<DocumentSnapshot>>(
                          future: Future.wait(
                            categoryRefs?.map((ref) => ref.get()).toList() ??
                                [],
                          ),
                          builder: (context, categorySnapshots) {
                            if (categorySnapshots.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            List<Map<String, dynamic>?>? categoryDataList =
                                categorySnapshots.data
                                    ?.map(
                                      (snapshot) =>
                                          snapshot.data()
                                              as Map<String, dynamic>?,
                                    )
                                    .toList();
                            List<String> categoryNames =
                                categorySnapshots.data?.map((snapshot) {
                                  Map<String, dynamic>? data =
                                      snapshot.data() as Map<String, dynamic>?;
                                  return data?['Name'] as String? ?? '';
                                }).toList() ??
                                [];

                            return FoodSpecialtyTile(
                              price: foodData['Price'],
                              image: foodData['URL'],
                              logo: businessData['URL'],
                              title: businessData['Name'],
                              itemName: foodData['Name'],
                              time: time,
                              onTap: () {
                                if (userId != null) {
                                  _userDataService.logUserInteraction(
                                    userId: userId!,
                                    action: 'selected_business_page_food',
                                    itemName: foodData['Name'],
                                    businessId: businessId,
                                    categoryNames: categoryNames,
                                  );
                                }
                                safeNavigate(
                                  context,
                                  DrinkDetailsPage(
                                    image: foodData['URL'],
                                    logo: businessData['URL'],
                                    title: businessData['Name'],
                                    itemName: foodData['Name'],
                                    price: foodData['Price'],
                                    time: time,
                                    categoryDataList: categoryDataList ?? [],
                                    description: foodData['Description'] ?? '',
                                    businessId: foodData['businessID'].id,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
