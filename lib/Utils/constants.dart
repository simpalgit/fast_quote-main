import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pdf/pdf.dart';

Color blackColor = const Color(0xFF000000);
Color whiteColor = const Color(0xFFFFFFFF);
Color primaryColor = HexColor("#2596be");
Color lightPrimary = HexColor("#cbe2ef");
Color secondary = HexColor("#51536b");
Color bgColor = HexColor("#fef5fe");
Color greyColor = const Color(0xFF9E9E9E);
Color grey200 = const Color(0xFFEEEEEE);
Color grey300 = const Color(0xFFE0E0E0);
Color grey400 = const Color(0xFFBDBDBD);
Color yellowColor = HexColor("#f8ab52");
Color greenColor = HexColor("#60c879");
Color purpleColor = HexColor("#9290ff");
Color blueColor = HexColor("#278ce4");
PdfColor templateWhiteColor = PdfColor.fromHex("#ffffff");

PdfColor templateTwoPrimary = PdfColor.fromHex("#df1a2e");

PdfColor templateTwoSecondary = PdfColor.fromHex("#222933");
PdfColor templateThreePrimary = PdfColor.fromHex("#2065a8");

const Color kWhite = Colors.white70;

class Style {
  static TextStyle headLineStyle1 = TextStyle(
      fontSize: 12.sp, color: blackColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle2 = TextStyle(
      fontSize: 15.sp, color: blackColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle3 = TextStyle(
      fontSize: 17.sp, color: blackColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle4 = TextStyle(
      fontSize: 19.sp, color: blackColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle5 = TextStyle(
      fontSize: 22.sp, color: blackColor, fontWeight: FontWeight.w500);
}

TextStyle headerTextStyle() {
  return TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.sp, color: secondary);
}

TextStyle subTextStyle() {
  return TextStyle(
    color: secondary,
    fontSize: 12.sp,
  );
}

TextStyle subTextStyleTwo(Color color) {
  return TextStyle(
      color: color,
      fontSize: 11.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: .5);
}
