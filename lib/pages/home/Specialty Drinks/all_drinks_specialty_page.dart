import 'dart:math';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/safe_navigation.dart';
import 'package:schemex/components/service_hours.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/pages/focused_pages/drink_details_page.dart';
import 'package:schemex/pages/home/Specialty%20Drinks/all_drinks_specialty_tile.dart';

class AllDrinkSpecialsPage extends StatelessWidget {
  AllDrinkSpecialsPage({super.key});
  final UserDataService _userDataService = UserDataService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<List<QuerySnapshot>> _mergedStream() {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());

    Stream<QuerySnapshot> regularsStream =
        FirebaseFirestore.instance
            .collection('Specialty Drinks')
            .doc(dayOfWeek)
            .collection('Regulars')
            .limit(5)
            .snapshots();

    Stream<QuerySnapshot> happyHourStream =
        FirebaseFirestore.instance
            .collection('Specialty Drinks')
            .doc('Happy Hour')
            .collection('Mon-Fri')
            .snapshots();

    Stream<QuerySnapshot> dailyStream =
        FirebaseFirestore.instance
            .collection('Specialty Drinks')
            .doc('Everyday')
            .collection('Regulars')
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
    ServiceHours businessHoursService = ServiceHours();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black12,
          title: ResuableText(
            text: "Drink Specials",
            style: appStyle(15, Colors.white, FontWeight.w600),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
        ),
        body: StreamBuilder<List<QuerySnapshot>>(
          stream: _mergedStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> allDrinks =
                snapshot.data!
                    .expand((querySnapshot) => querySnapshot.docs)
                    .toList();

            allDrinks.shuffle(Random());

            return ListView.builder(
              padding: EdgeInsets.all(12.h),
              itemCount: allDrinks.length,
              itemBuilder: (context, index) {
                DocumentSnapshot drink = allDrinks[index];
                Map<String, dynamic> drinkData =
                    drink.data() as Map<String, dynamic>;
                DocumentReference? businessRef =
                    drinkData['businessID'] as DocumentReference?;

                // Extract the Category document references from the array
                List<DocumentReference>? categoryRefs =
                    drinkData['Category']?.cast<DocumentReference>();

                // Fetch the business document using the reference
                return FutureBuilder<DocumentSnapshot>(
                  future: businessRef?.get(),
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

                    // Use the service to get the time
                    return FutureBuilder<String>(
                      future: businessHoursService.getBusinessHours(
                        businessRef!.id, // Pass the business ID
                        specialTime: drinkData['Time'],
                      ),
                      builder: (context, timeSnapshot) {
                        if (timeSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        String time = timeSnapshot.data ?? 'Unavailable';
                        // Fetch the Category documents using the references
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

                            return AllDrinkSpecialtyTile(
                              price: drinkData['Price'],
                              image: drinkData['URL'],
                              logo: businessData['URL'],
                              title: businessData['Name'],
                              itemName: drinkData['Name'],
                              time: time,
                              onTap: () {
                                if (userId != null) {
                                  _userDataService.logUserInteraction(
                                    userId: userId!,
                                    action: 'selected_drink',
                                    itemName: drinkData['Name'],
                                    businessId: businessRef.id,
                                    categoryNames: categoryNames,
                                  );
                                }
                                safeNavigate(
                                  context,
                                  DrinkDetailsPage(
                                    image: drinkData['URL'],
                                    logo: businessData['URL'],
                                    title: businessData['Name'],
                                    itemName: drinkData['Name'],
                                    price: drinkData['Price'],
                                    time: time,
                                    categoryDataList: categoryDataList ?? [],
                                    description: drinkData['Description'] ?? '',
                                    businessId: businessRef.id,
                                  ),
                                );
                              }, // Use the time from the service
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
