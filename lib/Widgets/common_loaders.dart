import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CommonButtonLoader extends StatelessWidget {
  const CommonButtonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      width: 15,
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }
}

progressIndicator(BuildContext context) {
  return Center(
    child: SizedBox(
      height: 80,
      width: 80,
      child: LoadingIndicator(
        indicatorType: Indicator.ballSpinFadeLoader,
        colors: [primaryColor, lightPrimary, secondary],
        strokeWidth: 2,
        backgroundColor: bgColor,
      ),
    ),
  );
}
