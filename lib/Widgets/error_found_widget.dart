import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorFoundWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String errorString;
  const ErrorFoundWidget(
      {super.key, required this.errorString, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            errorString,
            style: TextStyle(
                color: primaryColor,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: onTap, child: const Text('Try Again'))
        ],
      ),
    );
  }
}

class ErrorText extends StatelessWidget {
  final String error;
  const ErrorText({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 3.h,
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 11.sp),
              ),
            )),
      ],
    );
  }
}
