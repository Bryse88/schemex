import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:schemex/pages/business_pages/business_list.dart';
import 'package:schemex/pages/search/Featured%20Bars/featured_bars_widget.dart';

class FeaturedList extends StatelessWidget {
  const FeaturedList({super.key});

  // Method to log user interaction
  Future<void> logUserInteraction(String businessId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      await FirebaseFirestore.instance.collection('UserInteractions').add({
        'userId': userId,
        'businessId': businessId,
        'source':
            'FeaturedList', // Indicate that it came from the featured list
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void move(BuildContext context, String documentId) {
    // Log user interaction
    logUserInteraction(documentId).then((_) {
      // Navigate to the business page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessListScreen(businessId: documentId),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());

    return Container(
      height: 192.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Businesses').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
            ), // Horizontal padding
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  (snapshot.data!.docs..shuffle(Random())).take(5).map((
                    DocumentSnapshot document,
                  ) {
                    // FutureBuilder to handle the asynchronous fetching of each document's hours
                    return FutureBuilder<DocumentSnapshot>(
                      future:
                          FirebaseFirestore.instance
                              .collection('Businesses')
                              .doc(document.id)
                              .collection('Hours')
                              .doc(dayOfWeek)
                              .get(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> hoursSnapshot,
                      ) {
                        if (hoursSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            width:
                                100.w, // Set a width for CircularProgressIndicator
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        String time = 'Unavailable'; // Default time
                        if (hoursSnapshot.hasData &&
                            hoursSnapshot.data!.exists) {
                          Map<String, dynamic> hoursData =
                              hoursSnapshot.data!.data()
                                  as Map<String, dynamic>? ??
                              {};
                          bool isClosed =
                              hoursData['Closed'] ==
                              true; // Check if Closed is true

                          if (isClosed) {
                            time = 'Closed';
                          } else {
                            String openTime =
                                hoursData['Open'] as String? ?? 'Unknown';
                            String closeTime =
                                hoursData['Close'] as String? ?? 'Unknown';
                            time = '$openTime - $closeTime';
                          }
                        }

                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>? ?? {};
                        String logo =
                            data['URL'] as String? ?? 'default_logo_url';
                        String title =
                            data['Name'] as String? ?? 'Unknown Title';
                        String address =
                            data['Adress'] as String? ?? 'Unknown Address';

                        return FeaturedBarsWidget(
                          logo: logo,
                          title: title,
                          adress: address,
                          time: time,
                          onTap: () => move(context, document.id),
                          businessId: document.id,
                        );
                      },
                    );
                  }).toList(),
            ),
          );
        },
      ),
    );
  }
}
