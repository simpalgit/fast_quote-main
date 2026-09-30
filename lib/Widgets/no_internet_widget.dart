import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/no_internet.svg',
              width: size.height * 0.22,
              height: size.height * 0.22,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Slow or no internet connection.',
              style: TextStyle(
                  letterSpacing: 0.5,
                  color: const Color(0xFF32539D),
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.04),
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            Text(
              'Please check your internet and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 0.5,
                  color: const Color(0xFF32539D),
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.04),
            )
          ],
        ),
      ),
    );
  }
}
