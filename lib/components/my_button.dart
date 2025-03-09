import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  const MyButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Container(
            width: w * 0.5,
            height: h * 0.06,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.pink),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontFamily: AutofillHints.birthdayDay,
                    fontWeight: FontWeight.bold),
              ),
            )));
  }
}
