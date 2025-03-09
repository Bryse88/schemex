import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/search_bar.dart';
import 'package:schemex/components/user_data_service.dart';
import 'package:schemex/pages/search/category_page.dart';

class AllCategories extends StatefulWidget {
  AllCategories({super.key});

  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  final UserDataService _userDataService = UserDataService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  void navigateToCategory(
    BuildContext context,
    String categoryName,
    String categoryId,
  ) {
    // Log user interaction
    if (userId != null) {
      _userDataService.logUserInteraction(
        userId: userId!,
        action: 'selected_category',
        categoryNames: [categoryName],
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CategoryPage(
              categoryName: categoryName,
              categoryId: categoryId,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black12,
          title: ResuableText(
            text: "All Categories",
            style: appStyle(15, Colors.white, FontWeight.w600),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 12.w, top: 10.h),
          height: height,
          child: Column(
            children: [
              MySearchBar(
                controller: _searchController,
                hintText: "Search Categories",
                obscureText: false,
                icon: const Icon(Icons.search, color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('categories')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Filter and sort categories
                    List<DocumentSnapshot> filteredCategories =
                        snapshot.data!.docs
                            .where(
                              (doc) =>
                                  (doc.data() as Map<String, dynamic>)['Name']
                                      .toLowerCase()
                                      .contains(searchQuery) &&
                                  (doc.data()
                                          as Map<String, dynamic>)['Name'] !=
                                      'More',
                            )
                            .toList();
                    filteredCategories.sort((a, b) {
                      String idA = a.id;
                      String idB = b.id;
                      bool isFoodA = idA.startsWith('Food');
                      bool isFoodB = idB.startsWith('Food');
                      if (isFoodA && !isFoodB) {
                        return 1;
                      } else if (!isFoodA && isFoodB) {
                        return -1;
                      }
                      return idA.compareTo(idB);
                    });

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot category = filteredCategories[index];
                        Map<String, dynamic> categoryData =
                            category.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 18.r,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(categoryData["URL"]),
                          ),
                          title: ResuableText(
                            text: categoryData["Name"],
                            style: appStyle(
                              12,
                              Colors.white,
                              FontWeight.normal,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 15.r,
                          ),
                          onTap:
                              () => navigateToCategory(
                                context,
                                categoryData["Name"],
                                category.id,
                              ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
