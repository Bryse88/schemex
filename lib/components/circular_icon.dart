import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  final Function()? onTap;
  final String imagePath;
  const CircularIcon({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(imagePath, height: 55),
    );
  }
}
