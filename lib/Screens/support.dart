import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:fast_quote/Screens/Settings/settings_screen.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  Future<void> _makePhoneCall() async {
    const String phoneNumber = 'tel:+918275577356';

    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      CommonFunctions.showErrorSnackbar(context, "Something went wrong.");
    }
  }

  Future emailFunction(String mail) async {
    String emailUrl = "mailto:$mail";

    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl));
    } else {
      CommonFunctions.showErrorSnackbar(context, "Could not launch email.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 30,
                  width: 40,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                'Support',
                style: TextStyle(color: secondary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          children: [
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: ProfileCardHelper(
                heading: "Instructions for Using App",
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.instructionsScreen,
                  );
                },
                passIcon: CupertinoIcons.doc_plaintext,
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: InkWell(
                onTap: () async {
                  LocalPreferences().getSupportVideoLink().then((value) {
                    Navigator.pushNamed(
                      context,
                      RouteNames.youtubePlayerFlutter,
                      arguments: {"videoLink": value},
                    );
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Card(
                      color: const Color.fromARGB(255, 251, 217, 78),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: secondary)),
                      elevation: 5,
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const Image(
                            image: AssetImage('assets/images/video_thumb.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/images/youtube_logo.svg",
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Image(
                      image: const AssetImage('assets/images/appLogo.png'),
                      width: size.width * 0.50,
                      height: size.height * 0.15,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _makePhoneCall();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.call,
                                color: primaryColor,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                '+91 8275577356',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.email,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    emailFunction("info@fastquote.co.in");
                                  },
                                  child: const Text(
                                    'info@fastquote.co.in',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                InkWell(
                                  onTap: () {
                                    emailFunction("webvisionsoftech@gmail.com");
                                  },
                                  child: const Text(
                                    'webvisionsoftech@gmail.com',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                '224/A,B4 ,2nd Floor,Vishwakarma Paradise,Phase -1, Ambadi Rd, Sai Nagar, Vasai West, Palghar, Vasai-Virar, Maharashtra 401202',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}