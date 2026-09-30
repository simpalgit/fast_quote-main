import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'splash_screen_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider =
          Provider.of<SplashScreenProvider>(context, listen: false);
      homeProvider.checkVersion(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minWidth: 800, maxWidth: 800),
   child:    Center(
        child: Image.asset(
          'assets/images/app_splash.gif',
        ),
      ),
    ));
  }
}
