import 'dart:io';

import 'package:app_version_update/app_version_update.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreenProvider with ChangeNotifier {
  Future<void> checkVersion(BuildContext context) async {
    await getislogin(context);
    // final info = await PackageInfo.fromPlatform();

    // if (Platform.isAndroid) {
    //   if (info.version.isNotEmpty) {
    //     _verifyVersionAndroid(context);
    //   }
    // } else if (Platform.isIOS) {
    //   if (info.version.isNotEmpty) {
    //     _verifyVersion(context);
    //   }
    // }
  }

  void _verifyVersionAndroid(context) async {
    await AppVersionUpdate.checkForUpdates(
      //  appleId: '6448658758',
      playStoreId: 'com.webvision.fastquote',

      country: 'in',
    ).then((result) async {
      if (result.canUpdate!) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("Update Available"),
              content: const Text("Would you like to update your application?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    getislogin(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Update"),
                  onPressed: () {
                    final url = Uri.parse(
                      "market://details?id=com.webvision.fastquote",
                    );
                    launchUrl(url, mode: LaunchMode.externalApplication);
                    exit(0);
                  },
                ),
              ],
            );
          },
        );
      } else {
        await getislogin(context);
      }
    });
  }

  void _verifyVersion(context) async {
    await AppVersionUpdate.checkForUpdates(
      appleId: '6471255733',
      playStoreId: 'com.webvision.fastquote',
      // appleId: '6447180128',
      // playStoreId: 'com.weblord.yarave_app',
      country: 'in',
    ).then((result) async {
      if (result.canUpdate!) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("Update Available"),
              content: const Text("Would you like to update your application?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    getislogin(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Update"),
                  onPressed: () {
                    final url = Uri.parse(
                      "https://apps.apple.com/app/id6471255733",
                    );
                    launchUrl(url, mode: LaunchMode.externalApplication);
                    exit(0);
                  },
                ),
              ],
            );
          },
        );
      } else {
        await getislogin(context);
      }
    });
  }

  getislogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLogin = prefs.getBool(loginKey) ?? false;
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (isLogin) {
        Navigator.pushReplacementNamed(context, RouteNames.homeScreen);
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
      }
    });
  }
}
