import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar commonAppBar(
    {required BuildContext context,
    required String heading,
    String? subtitle,
    double? elv = 0,
    List<Widget>? widgetList,
    VoidCallback? onPressed}) {
  return AppBar(
    elevation: elv,
    automaticallyImplyLeading: false,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5).w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onPressed ??
                () {
                  Navigator.pop(context);
                },
            child: Container(
              height: 25.h,
              width: 40.w,
              margin: EdgeInsets.only(right: 0.w),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10).r),
              child: Center(
                child: Icon(
                  Icons.arrow_back_sharp,
                  color: whiteColor,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
          Text(
            heading,
            style: TextStyle(
              color: secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Container()
        ],
      ),
    ),
    actions: widgetList,
  );
}
