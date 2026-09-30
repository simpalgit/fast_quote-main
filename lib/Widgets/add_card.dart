import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCardHelper extends StatelessWidget {
  final String heading;
  final VoidCallback? onPressed;
  const AddCardHelper({super.key, required this.heading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: secondary),
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0))),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: secondary, width: 8),
              ),
            ),
            padding: EdgeInsets.only(top: 0, bottom: 0, left: 15.w, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: TextStyle(
                      fontSize: 12.sp,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                Container(
                  height: 40.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  color: secondary,
                  child: Icon(
                    CupertinoIcons.add,
                    color: whiteColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
