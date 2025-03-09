import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schemex/components/gradient_background.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isNotificationsEnabled = true; // Initial state of the switch

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Notification Settings',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to your desired color
          ),
          // Set the background color, elevation, etc., as needed
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SwitchListTile(
            title: Text(
              'Enable Notifications',
              style: TextStyle(color: Colors.white, fontSize: 15.sp),
            ),
            value: isNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                isNotificationsEnabled = value;
              });
              // Add additional logic here if you need to do something when the switch changes
            },
            // Additional styling if needed
          ),
        ),
      ),
    );
  }
}
