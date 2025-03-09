import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/service_hours.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/pages/focused_pages/event_details_page.dart';
import 'package:schemex/pages/search/Events/EventsTiles.dart';

class AllEventsPage extends StatelessWidget {
  AllEventsPage({super.key});
  final UserDataService _userDataService = UserDataService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());
    ServiceHours businessHoursService = ServiceHours();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black12,
          title: ResuableText(
            text: "Events",
            style: appStyle(15, Colors.white, FontWeight.w600),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('Events')
                  .doc(dayOfWeek)
                  .collection('Regulars')
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

            // Check if there are no events
            if (docs.isEmpty) {
              return Center(
                child: ResuableText(
                  text: 'No events available today',
                  style: appStyle(18, Colors.white, FontWeight.w600),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(12.h),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot events = docs[index];
                Map<String, dynamic> eventData =
                    events.data() as Map<String, dynamic>;
                DocumentReference businessRef =
                    eventData['businessID'] as DocumentReference;

                // Fetch the business document using the reference
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
                        businessRef!.id, // Pass the business ID
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

                        return AllEventsTile(
                          price: eventData['Price'],
                          image: businessData['URL'],
                          logo: businessData['URL'],
                          title: businessData['Name'],
                          eventName: eventData['Name'],
                          time: time,
                          onTap: () {
                            if (userId != null) {
                              _userDataService.logUserInteraction(
                                userId: userId!,
                                action: 'selected_event',
                                itemName: eventData['Name'],
                                businessId: businessRef.id,
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
