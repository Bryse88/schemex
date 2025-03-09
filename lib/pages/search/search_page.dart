import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schemex/components/app_style.dart';
import 'package:schemex/components/heading.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/components/search_bar.dart';
import 'package:schemex/pages/business_pages/business_list.dart';
import 'package:schemex/pages/search/Events/EventsList.dart';
import 'package:schemex/pages/search/Events/EventsPage.dart';
import 'package:schemex/pages/search/Featured%20Bars/featured_list.dart';
import 'package:schemex/pages/search/Featured%20Bars/featured_page.dart';
import 'package:schemex/pages/search/search_result_page.dart';
import 'package:schemex/pages/search/widgets/category_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  Stream<List<DocumentSnapshot>>? searchResults;
  String previousQuery = '';

  // Unique keys for each list to force rebuild on refresh
  Key featuredListKey = UniqueKey();
  Key eventsListKey = UniqueKey();

  void searchBusinesses(String query) {
    if (query != previousQuery) {
      setState(() {
        previousQuery = query;
        if (query.isNotEmpty) {
          searchResults = FirebaseFirestore.instance
              .collection('Businesses')
              .snapshots()
              .map(
                (snapshot) =>
                    snapshot.docs
                        .where(
                          (doc) => doc['Name']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()),
                        )
                        .toList(),
              );
        } else {
          searchResults = null;
        }
      });
    }
  }

  void unfocusTextField() {
    FocusScope.of(context).unfocus();
  }

  // Refresh function to regenerate keys and force rebuild
  Future<void> _refreshPage() async {
    setState(() {
      featuredListKey = UniqueKey();
      eventsListKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: unfocusTextField,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: h * 0.07),
                MySearchBar(
                  controller: searchController,
                  hintText: "Bar Names",
                  obscureText: false,
                  icon: const Icon(Icons.search, color: Colors.black),
                  onChanged: searchBusinesses,
                ),
                // Search results or default lists
                searchResults != null
                    ? StreamBuilder<List<DocumentSnapshot>>(
                      stream: searchResults,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var doc = snapshot.data![index];
                              return SearchWidget(
                                logo: doc['URL'] ?? 'default_logo.png',
                                title: doc['Name'],
                                businessID: doc.id,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => BusinessListScreen(
                                            businessId: doc.id,
                                          ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Center(
                              child: ResuableText(
                                text: 'No items available today',
                                style: appStyle(
                                  18,
                                  Colors.white,
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )
                    : Column(
                      children: [
                        CategoryList(),
                        SizedBox(height: h * 0.03),
                        Heading(
                          text: "Featured",
                          color: Colors.white,
                          onTap: () {
                            Get.to(
                              FeaturedBars(),
                              transition: Transition.cupertino,
                              duration: const Duration(milliseconds: 1000),
                            );
                          },
                        ),
                        FeaturedList(key: featuredListKey),
                        SizedBox(height: h * 0.03),
                        Heading(
                          text: "Events",
                          color: Colors.white,
                          onTap: () {
                            Get.to(
                              AllEventsPage(),
                              transition: Transition.cupertino,
                              duration: const Duration(milliseconds: 1000),
                            );
                          },
                        ),
                        AllEventsList(key: eventsListKey),
                        SizedBox(height: h * 0.1),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
