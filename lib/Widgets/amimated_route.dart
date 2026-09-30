import 'package:flutter/material.dart';

Route createRoute(passedClass, double dx, double dy) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return passedClass;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin = Offset(dx, dy);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}
