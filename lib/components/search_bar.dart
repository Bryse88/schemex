import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final Function(String)? onChanged;

  const MySearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: const Color.fromARGB(248, 249, 253, 255),
            prefixIcon: icon,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                controller.clear();
                FocusScope.of(context).unfocus(); // Unfocus the TextField
                if (onChanged != null) {
                  onChanged!(''); // Reset the search results
                }
              },
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 0, horizontal: 20), // Padding inside the search bar
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  color: Colors.black,
                  width: 2.0), // Border color when the TextField is focused
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              // Border color when the TextField is enabled but not focused
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  BorderSide.none, // No border when neither focused nor enabled
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
