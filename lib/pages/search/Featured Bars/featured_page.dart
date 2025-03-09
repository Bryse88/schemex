import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/firestore_service.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/safe_navigation.dart';
import 'package:schemex/pages/business_pages/business_list.dart';
import 'package:schemex/pages/search/Featured%20Bars/featured_bars_tile.dart';

class FeaturedBars extends StatelessWidget {
  FeaturedBars({super.key});
  final FirestoreService _firestoreService = FirestoreService();

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

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black12,
          title: ResuableText(
            text: "Featured",
            style: appStyle(15, Colors.white, FontWeight.w600),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.h),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestoreService.getBusinessesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Text('No bars found');
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var barData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  var barId = snapshot.data!.docs[index].id;

                  return FutureBuilder<String>(
                    future: _firestoreService.getBusinessHours(barId),
                    builder: (context, hoursSnapshot) {
                      if (hoursSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      String time = hoursSnapshot.data ?? 'Unavailable';
                      return FeaturedBarsTile(
                        logo: barData['URL'] as String? ?? 'default_logo_url',
                        title: barData['Name'] as String? ?? 'Unknown Title',
                        adress:
                            barData['Adress'] as String? ?? 'Unknown Address',
                        time: time,
                        businessID: barId,
                        onTap: () async {
                          await logUserInteraction(barId);
                          safeNavigate(
                            context,
                            BusinessListScreen(businessId: barId),
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
      ),
    );
  }
}
