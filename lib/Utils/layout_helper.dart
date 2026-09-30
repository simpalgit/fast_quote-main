import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    //required this.desktop,
    required this.largeMobile,
    required this.mediumMobile,
    required this.mobile,
    required this.tablet,
    // this.extraLargeScreen
  });
  // final Widget desktop;
  final Widget? largeMobile;
  final Widget? mediumMobile;
  final Widget mobile;
  final Widget? tablet;
  // final Widget? extraLargeScreen;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= 320;
  }

  static bool isMobileM(BuildContext context) {
    return MediaQuery.of(context).size.width <= 375;
  }

  static bool isMobileL(BuildContext context) {
    return MediaQuery.of(context).size.width <= 425;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width <= 768;
  }

  // static bool isDesktop(BuildContext context) {
  //   return MediaQuery.of(context).size.width <= 1024;
  // }

  // static bool isExtraLargeScreen(BuildContext context) {
  //   return MediaQuery.of(context).size.width > 1024;
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // if (size.width > 1024 && extraLargeScreen != null) {
    //   return extraLargeScreen!;
    // } else if (size.width > 768 && size.width >= 1024) {
    //   return desktop;
    // } else
    if (size.width > 425 && size.width >= 768) {
      return tablet!;
    } else if (size.width > 375 && size.width <= 425 && tablet != null) {
      return largeMobile!;
    } else if (size.width > 320 && size.width <= 375 && largeMobile != null) {
      return mediumMobile!;
    } else {
      return mobile;
    }
  }
}
