import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/safe_navigation.dart';
import 'package:schemex/components/service_hours.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/pages/business_pages/Widgets/Food%20Specialty/food_specialty_widget.dart';
import 'package:schemex/pages/focused_pages/drink_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrinkSpecialtyList extends StatelessWidget {
  DrinkSpecialtyList({super.key, required this.businessId});
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
            .collection('Specialty Drinks')
            .doc(dayOfWeek)
            .collection('Regulars')
            .where('businessID', isEqualTo: businessRef)
            .snapshots();

    Stream<QuerySnapshot> happyHourStream =
        FirebaseFirestore.instance
            .collection('Specialty Drinks')
            .doc('Happy Hour')
            .collection('Mon-Fri')
            .where('businessID', isEqualTo: businessRef)
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
    DocumentReference businessRef = FirebaseFirestore.instance.doc(
      "Businesses/$businessId",
    );
    ServiceHours businessHoursService = ServiceHours();

    return StreamBuilder<List<QuerySnapshot>>(
      stream: _mergedStream(businessId),
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

        // Limit the number of items to display
        int itemCount = allDrinks.length > 5 ? 5 : allDrinks.length;

        if (allDrinks.isEmpty) {
          return FutureBuilder<DocumentSnapshot>(
            future: businessRef.get(),
            builder: (context, businessSnapshot) {
              if (businessSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (businessSnapshot.hasError || !businessSnapshot.data!.exists) {
                return const Text('Business data not available');
              }

              String businessName = businessSnapshot.data!['Name'];
              return Center(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_drink,
                        size: 50.sp,
                        color: Colors.grey[700],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'No specialty drinks today',
                        style: appStyle(18, Colors.grey[700]!, FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        return SizedBox(
          height: 190.h,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ), // Horizontal padding
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                DocumentSnapshot drink = allDrinks[index];
                Map<String, dynamic> drinkData =
                    drink.data() as Map<String, dynamic>;

                List<DocumentReference>? categoryRefs;
                if (drinkData['Category'] is List) {
                  categoryRefs =
                      (drinkData['Category'] as List)
                          .where((element) => element is DocumentReference)
                          .cast<DocumentReference>()
                          .toList();
                } else {
                  categoryRefs = [];
                }

                return FutureBuilder<List<dynamic>>(
                  future: Future.wait([
                    businessRef.get(),
                    businessHoursService.getBusinessHours(
                      businessId,
                      specialTime: drinkData['Time'],
                    ),
                    if (categoryRefs != null)
                      Future.wait(categoryRefs.map((ref) => ref.get()))
                    else
                      Future.value([]), // handle null case
                  ]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    DocumentSnapshot businessSnapshot =
                        snapshot.data![0] as DocumentSnapshot;
                    String time = snapshot.data![1] as String;
                    List<DocumentSnapshot> categorySnapshots =
                        snapshot.data![2] as List<DocumentSnapshot>;

                    if (!businessSnapshot.exists) {
                      return const Text('Business data not available');
                    }

                    Map<String, dynamic> businessData =
                        businessSnapshot.data() as Map<String, dynamic>;

                    List<Map<String, dynamic>?>? categoryDataList =
                        categorySnapshots
                            .map(
                              (snapshot) =>
                                  snapshot.data() as Map<String, dynamic>?,
                            )
                            .toList();
                    List<String> categoryNames =
                        categorySnapshots.map((snapshot) {
                          Map<String, dynamic>? data =
                              snapshot.data() as Map<String, dynamic>?;
                          return data?['Name'] as String? ?? '';
                        }).toList();

                    return FoodSpecialtyWidget(
                      image: drinkData['URL'],
                      logo: businessData['URL'],
                      title: businessData['Name'],
                      itemName: drinkData['Name'],
                      price: drinkData['Price'],
                      time: time,
                      businessId: businessId,
                      onTap: () {
                        if (userId != null) {
                          _userDataService.logUserInteraction(
                            userId: userId!,
                            action: 'selected_business_page_drink',
                            itemName: drinkData['Name'],
                            businessId: businessId,
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
                            categoryDataList:
                                categorySnapshots
                                    .map(
                                      (snapshot) =>
                                          snapshot.data()
                                              as Map<String, dynamic>,
                                    )
                                    .toList(),
                            description: drinkData['Description'] ?? '',
                            businessId:
                                (drinkData['businessID'] as DocumentReference)
                                    .id,
                          ),
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
