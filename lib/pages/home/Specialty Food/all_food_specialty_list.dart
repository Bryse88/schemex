import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:schemex/components/safe_navigation.dart';
import 'package:schemex/components/service_hours.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/pages/focused_pages/drink_details_page.dart';
import 'package:schemex/pages/home/Specialty%20Drinks/all_drinks_specialty_widget.dart';
import 'package:async/async.dart'; // Import the async package

class AllFoodSpecialtyList extends StatelessWidget {
  AllFoodSpecialtyList({super.key});
  final UserDataService _userDataService = UserDataService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<List<QuerySnapshot>> _mergedStream() {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());

    Stream<QuerySnapshot> regularsStream =
        FirebaseFirestore.instance
            .collection('Specialty Food')
            .doc(dayOfWeek)
            .collection('Regulars')
            .snapshots();

    Stream<QuerySnapshot> happyHourStream =
        FirebaseFirestore.instance
            .collection('Specialty Food')
            .doc('Happy Hour')
            .collection('Mon-Fri')
            .snapshots();

    List<Stream<QuerySnapshot>> streams = [regularsStream];

    // Check if today is a weekday (Monday to Friday)
    if (dayOfWeek != 'Saturday' && dayOfWeek != 'Sunday') {
      streams.add(happyHourStream);
    }

    return StreamZip(streams);
  }

  @override
  Widget build(BuildContext context) {
    ServiceHours businessHoursService = ServiceHours();

    return StreamBuilder<List<QuerySnapshot>>(
      stream: _mergedStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Combine documents from all snapshots
        List<DocumentSnapshot> docs =
            snapshot.data!
                .expand((querySnapshot) => querySnapshot.docs)
                .toList();

        // Randomize the list of documents
        docs.shuffle(Random());

        return SizedBox(
          height: 190.h,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ), // Add horizontal padding
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(), // Apply bouncing physics
              padding: EdgeInsets.only(right: 16.w), // Add padding to the right
              itemCount: docs.length + 1, // Add one extra item for spacing
              itemBuilder: (context, index) {
                if (index == docs.length) {
                  // Add an extra blank space at the end
                  return SizedBox(width: 16.w);
                }

                DocumentSnapshot food = docs[index];
                Map<String, dynamic> foodData =
                    food.data() as Map<String, dynamic>;
                DocumentReference businessRef =
                    foodData['businessID'] as DocumentReference;
                String businessId =
                    businessRef.id; // Get the document ID as a string
                // Extract the Category document references from the array
                List<DocumentReference>? categoryRefs =
                    foodData['Category']?.cast<DocumentReference>();

                // Fetch the business document using the business reference
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

                            return AllDrinkSpecialtyWidget(
                              price: foodData['Price'],
                              image: foodData['URL'],
                              logo: businessData['URL'],
                              title: businessData['Name'],
                              onTap: () {
                                if (userId != null) {
                                  _userDataService.logUserInteraction(
                                    userId: userId!,
                                    action: 'selected_food',
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
                                    businessId: businessRef.id,
                                  ),
                                );
                              },
                              itemName: foodData['Name'],
                              time: time,
                              businessId: businessRef.id,
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
      },
    );
  }
}
