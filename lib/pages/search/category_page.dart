import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/pages/focused_pages/drink_details_page.dart';
import 'package:schemex/components/service_hours.dart';
import 'package:schemex/components/user_data_service.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  final String categoryId;

  CategoryPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  final UserDataService _userDataService = UserDataService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<List<QuerySnapshot>> _mergedStream() {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());

    Stream<QuerySnapshot> drinksStream =
        FirebaseFirestore.instance
            .collection('Specialty Drinks')
            .doc(dayOfWeek)
            .collection('Regulars')
            .where(
              'Category',
              arrayContains: FirebaseFirestore.instance
                  .collection('categories')
                  .doc(categoryId),
            )
            .snapshots();

    Stream<QuerySnapshot> foodStream =
        FirebaseFirestore.instance
            .collection('Specialty Food')
            .doc(dayOfWeek)
            .collection('Regulars')
            .where(
              'Category',
              arrayContains: FirebaseFirestore.instance
                  .collection('categories')
                  .doc(categoryId),
            )
            .snapshots();

    return StreamZip([drinksStream, foodStream]);
  }

  @override
  Widget build(BuildContext context) {
    ServiceHours businessHoursService = ServiceHours();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            categoryName,
            style: appStyle(20, Colors.white, FontWeight.w600),
          ),
          backgroundColor: Colors.transparent,
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

            List<DocumentSnapshot> documents =
                snapshot.data!
                    .expand((querySnapshot) => querySnapshot.docs)
                    .toList();

            if (documents.isEmpty) {
              return Center(
                child: ResuableText(
                  text: 'No items available today',
                  style: appStyle(18, Colors.white, FontWeight.w600),
                ),
              );
            }

            return ListView(
              children:
                  documents.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    DocumentReference businessRef = data['businessID'];
                    List<DocumentReference>? categoryRefs =
                        data['Category']?.cast<DocumentReference>();

                    return FutureBuilder<DocumentSnapshot>(
                      future: businessRef.get(),
                      builder: (context, businessSnapshot) {
                        if (businessSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (businessSnapshot.hasError ||
                            !businessSnapshot.data!.exists) {
                          return const Text('Business data not available');
                        }

                        Map<String, dynamic> businessData =
                            businessSnapshot.data!.data()
                                as Map<String, dynamic>;

                        return FutureBuilder<String>(
                          future: businessHoursService.getBusinessHours(
                            businessRef.id,
                            specialTime: data['Time'],
                          ),
                          builder: (context, timeSnapshot) {
                            if (timeSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            String time =
                                timeSnapshot.hasData
                                    ? timeSnapshot.data!
                                    : 'Unavailable';

                            return FutureBuilder<List<DocumentSnapshot>>(
                              future: Future.wait(
                                categoryRefs
                                        ?.map((ref) => ref.get())
                                        .toList() ??
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
                                          snapshot.data()
                                              as Map<String, dynamic>?;
                                      return data?['Name'] as String? ?? '';
                                    }).toList() ??
                                    [];

                                final bool hasPercentageOrDollarSign =
                                    data['Price'].contains('%') ||
                                    data['Price'].contains('\$') ||
                                    data['Price'].contains('off') ||
                                    data['Price'].contains('Off');

                                return GestureDetector(
                                  onTap: () {
                                    if (userId != null) {
                                      _userDataService.logUserInteraction(
                                        userId: userId!,
                                        action: 'selected_drink',
                                        itemName: data['Name'],
                                        businessId: businessRef.id,
                                        categoryNames: categoryNames,
                                      );
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DrinkDetailsPage(
                                              image: data['URL'],
                                              logo: businessData['URL'],
                                              title: businessData['Name'],
                                              itemName: data['Name'],
                                              price: data['Price'],
                                              time: time,
                                              categoryDataList:
                                                  categoryDataList ?? [],
                                              description:
                                                  data['Description'] ?? '',
                                              businessId: businessRef.id,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    height: 81.h,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(9.r),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(4.r),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12.r),
                                            ),
                                            child: SizedBox(
                                              height: 70.w,
                                              width: 70.w,
                                              child: Image.network(
                                                data["URL"],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ResuableText(
                                                text: data['Name'],
                                                style: appStyle(
                                                  13,
                                                  Colors.white,
                                                  FontWeight.w500,
                                                ),
                                              ),
                                              ResuableText(
                                                text:
                                                    hasPercentageOrDollarSign
                                                        ? data['Price']
                                                        : "\$${data['Price']}",
                                                style: appStyle(
                                                  15,
                                                  Colors.pink,
                                                  FontWeight.w900,
                                                ),
                                              ),
                                              ResuableText(
                                                text: businessData['Name'],
                                                style: appStyle(
                                                  11,
                                                  Colors.white,
                                                  FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }
}
