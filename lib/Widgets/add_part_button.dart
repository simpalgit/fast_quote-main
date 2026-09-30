import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAddPartButtonWidget extends StatelessWidget {
  final String btnText;
  final VoidCallback? onTap;

  const AppAddPartButtonWidget({
    super.key,
    required this.onTap,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r))),
            backgroundColor: WidgetStateProperty.all(primaryColor)),
        onPressed: onTap,
        child: Text(
          btnText,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class AppAddPartButtonSmall extends StatelessWidget {
  final String btnText;
  final VoidCallback? onTap;

  const AppAddPartButtonSmall({
    super.key,
    required this.onTap,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r))),
          backgroundColor: WidgetStateProperty.all(primaryColor)),
      onPressed: onTap,
      child: Text(
        btnText,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class AppButtonSecondary extends StatelessWidget {
  final String btnText;
  final VoidCallback? onTap;

  const AppButtonSecondary({
    super.key,
    required this.onTap,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r))),
            backgroundColor: WidgetStateProperty.all(secondary)),
        onPressed: onTap,
        child: Text(
          btnText,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class AppButtonSecondarySmall extends StatelessWidget {
  final String btnText;
  final VoidCallback? onTap;

  const AppButtonSecondarySmall({
    super.key,
    required this.onTap,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r))),
          backgroundColor: WidgetStateProperty.all(secondary)),
      onPressed: onTap,
      child: Text(
        btnText,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
