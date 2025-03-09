import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/safe_navigation.dart';
import 'package:schemex/components/service_hours.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/pages/business_pages/Widgets/Events/event_widget.dart';
import 'package:schemex/pages/focused_pages/event_details_page.dart';

class EventsList extends StatelessWidget {
  EventsList({super.key, required this.businessId});
  final UserDataService _userDataService = UserDataService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  final String businessId;

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat('EEEE').format(DateTime.now());

    // Create a DocumentReference for the business
    DocumentReference businessRef = FirebaseFirestore.instance.doc(
      "Businesses/$businessId",
    );

    ServiceHours businessHoursService = ServiceHours();

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('Events')
              .doc(dayOfWeek)
              .collection('Regulars')
              .where('businessID', isEqualTo: businessRef)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return FutureBuilder<DocumentSnapshot>(
            future: businessRef.get(),
            builder: (context, businessSnapshot) {
              if (businessSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (businessSnapshot.hasError || !businessSnapshot.data!.exists) {
                return const Text('Business data not available');
              }

              String restaurantName = businessSnapshot.data!['Name'];
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
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot event = snapshot.data!.docs[index];
                Map<String, dynamic> eventData =
                    event.data() as Map<String, dynamic>;

                // Check for the existence of the "Category" field
                List<DocumentReference>? categoryRefs =
                    eventData.containsKey('Category')
                        ? eventData['Category']?.cast<DocumentReference>()
                        : null;

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

                            return EventsWidget(
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
                                safeNavigate(
                                  context,
                                  EventDetailPage(
                                    image: eventData['URL'],
                                    logo: businessData['URL'],
                                    title: businessData['Name'],
                                    itemName: eventData['Name'],
                                    price: eventData['Price'],
                                    time: time,
                                    description: eventData['Description'] ?? '',
                                    businessId: businessRef.id,
                                  ),
                                );
                              },
                              eventName: eventData['Name'],
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
