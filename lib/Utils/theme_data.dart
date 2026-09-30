import 'package:flutter/material.dart';

import 'constants.dart';

class MyTheme {
  static final lightTheme = ThemeData(
      primaryColor: primaryColor,
      primarySwatch: Palette.kToDark,
      scaffoldBackgroundColor: bgColor,
      tooltipTheme: TooltipThemeData(
        textStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      appBarTheme: AppBarTheme(backgroundColor: bgColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8))),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(5),
        thumbColor: WidgetStateProperty.all(primaryColor),
        radius: const Radius.circular(10),
      ));
}

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xFF2596be, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF070961),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
}
