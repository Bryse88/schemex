import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/pages/search/widgets/category_widget.dart';

class CategoryList extends StatelessWidget {
  CategoryList({super.key});

  // Define the order of the categories
  final List<String> categoryOrder = [
    'Whiskey',
    'Beer',
    'Vodka',
    'Tequila',
    'Snacks',
    'More',
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 75.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter and sort the categories based on the predefined order
          List<DocumentSnapshot> filteredAndSortedCategories =
              snapshot.data!.docs
                  .where((doc) => categoryOrder.contains(doc['Name']))
                  .toList();
          filteredAndSortedCategories.sort((a, b) {
            int indexA = categoryOrder.indexOf(a['Name']);
            int indexB = categoryOrder.indexOf(b['Name']);
            return indexA.compareTo(indexB);
          });

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredAndSortedCategories.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot category =
                  filteredAndSortedCategories[index];
              return CategoryWidget(category: category, width: width);
            },
          );
        },
      ),
    );
  }
}
