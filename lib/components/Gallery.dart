import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  GalleryState createState() => GalleryState();
}

class GalleryState extends State<Gallery> {
  final PageController _pageController = PageController();
  Timer? _timer;
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _startAutoScroll();
  }

  Future<void> _fetchImages() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('photos').get();

      List<String> fetchedImages =
          querySnapshot.docs.map((doc) => doc['URL'] as String).toList();

      setState(() {
        images = fetchedImages;
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching images: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_pageController.hasClients) {
        int currentPage = _pageController.page?.toInt() ?? 0;
        int nextPage = currentPage + 1;

        if (nextPage >= images.length) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Container(
          width: w,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: w * 0.01),
            borderRadius: BorderRadius.circular(40),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21.r),
            child: CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error),
              ),
            ),
          ),
        );
      },
    );
  }
}
