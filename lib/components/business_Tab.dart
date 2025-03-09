import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessTab extends StatelessWidget {
  final String businessName;
  final String logoUrl;
  final void Function()? onTap;

  const BusinessTab({
    Key? key,
    required this.businessName,
    required this.logoUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(logoUrl),
          radius: 20.w,
        ),
        title: Text(
          businessName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.sp),
          onPressed: onTap,
        ),
        onTap: onTap,
      ),
    );
  }
}
