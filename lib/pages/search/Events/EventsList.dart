import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/service_hours.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/pages/focused_pages/event_details_page.dart';
import 'package:schemex/pages/search/Events/EventsWidget.dart';

class AllEventsList extends StatelessWidget {
  AllEventsList({super.key});
  final UserDataService _userDataService = UserDataService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());
    ServiceHours businessHoursService = ServiceHours();

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('Events')
              .doc(dayOfWeek)
              .collection('Regulars')
              .limit(5) // Limit to 5 documents
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Randomize the list of documents
        List<DocumentSnapshot> docs = snapshot.data!.docs;
        docs.shuffle(Random());

        // If there are no events, show the "No events today" message
        if (docs.isEmpty) {
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
                  Icon(Icons.event, size: 50.sp, color: Colors.grey[700]),
                  SizedBox(height: 10.h),
                  ResuableText(
                    text: 'No events today',
                    style: appStyle(18, Colors.grey[700]!, FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }

        return SizedBox(
          height: 190.h,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ), // Add horizontal padding
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot event = docs[index];
                Map<String, dynamic> eventData =
                    event.data() as Map<String, dynamic>;
                DocumentReference businessRef =
                    eventData['businessID'] as DocumentReference;
                String businessId =
                    businessRef.id; // Get the document ID as a string
                List<DocumentReference>? categoryRefs =
                    eventData['Category']?.cast<DocumentReference>();

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
                        specialTime: eventData['Time'],
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

                            return AllEventsWidget(
                              price: eventData['Price'],
                              image: businessData['URL'],
                              title: businessData['Name'],
                              onTap: () {
                                if (userId != null) {
                                  _userDataService.logUserInteraction(
                                    userId: userId!,
                                    action: 'selected_event',
                                    itemName: eventData['Name'],
                                    businessId: businessId,
                                  );
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => EventDetailPage(
                                          image: eventData['URL'],
                                          logo: businessData['URL'],
                                          title: businessData['Name'],
                                          itemName: eventData['Name'],
                                          price: eventData['Price'],
                                          time: time,
                                          description:
                                              eventData['Description'] ?? '',
                                          businessId: businessRef.id,
                                        ),
                                  ),
                                );
                              },
                              EventName: eventData['Name'],
                              time: time,
                              businessId: businessId,
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
