import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoDataFoundScreen extends StatelessWidget {
  final String passedData;
  const NoDataFoundScreen({super.key, required this.passedData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          'assets/gif/empty.gif',
        ),
        Positioned(
          bottom: 20,
          child: Text(
            passedData,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5B358D),
                fontSize: 16.sp),
          ),
        ),
      ],
    );
  }
}
