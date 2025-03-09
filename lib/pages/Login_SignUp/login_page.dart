import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/gradient_background.dart';
import 'package:schemex/components/resuable_text.dart';
import 'package:schemex/pages/auth_services.dart' show AuthServices;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 70.h),
              Container(
                width: 1.sw,
                height: 200.h,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/img/GFSDAMKO'.png"),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ResuableText(
                text: "ENCITE",
                style: TextStyle(
                  fontFamily: 'Kalam',
                  fontSize: 38.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 210.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await AuthServices().signInWithApple();
                    },
                    child: SizedBox(
                      width: 210.w,
                      height: 50.h, // Set a consistent height
                      child: Image.asset(
                        'lib/img/ContwApple.png', // Make sure this path is correct
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await AuthServices().signInWithGoogle();
                    },
                    child: SizedBox(
                      width: 210.w,
                      height: 50.h, // Set a consistent height
                      child: Image.asset(
                        'lib/img/ContwGoogle.png', // Make sure this path is correct
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
