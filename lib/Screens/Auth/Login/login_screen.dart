import 'package:animate_do/animate_do.dart';
import 'package:fast_quote/Screens/Auth/Login/login_provider.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/Anime/fade_in_anime.dart';
import 'package:fast_quote/Widgets/common_loaders.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart' as nbUtils;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     systemNavigationBarColor: Colors.white,
    //     statusBarColor: Colors.transparent));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<LoginProvider>(context, listen: false);
      provider.initData();
    });
    nbUtils.setStatusBarColor(primaryColor.withOpacity(0.05));
    super.initState();
  }

  @override
  void dispose() {
    nbUtils.setStatusBarColor(bgColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
                      constraints: BoxConstraints(minWidth: 800, maxWidth: 800),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    FadeInWidget(
                      duration: const Duration(milliseconds: 500),
                      child: SizedBox(
                        height: size.height * 0.23,
                        child: Stack(
                          children: [
                            Container(
                              height: size.height * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.elliptical(200, 70),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    primaryColor,
                                    secondary.withOpacity(0.2),
                                  ], // Adjust gradient colors
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(
                                  sigmaX: 1.0,
                                  sigmaY: 2.0,
                                ),
                                child: Container(height: 10.h),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: FadeInWidget(
                        duration: const Duration(milliseconds: 600),
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: primaryColor, width: 2.5),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 23,
                              vertical: 14,
                            ),
                            child: Text(
                              'Q',
                              style: TextStyle(
                                fontSize: 25,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FadeInWidget(
                        duration: const Duration(milliseconds: 600),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            FadeInWidget(
                              duration: const Duration(milliseconds: 700),
                              child: Card(
                                margin: EdgeInsets.zero,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: TextFormField(
                                      controller: provider.ctlMobile,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      style: TextStyle(color: primaryColor),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Cant be Empty.";
                                        } else if (value.length < 10) {
                                          return "enter 10 digit mobile number";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (value) {
                                        provider.checkNumberLength(value.length);
                                      },
                                      decoration: InputDecoration(
                                        counterText: '',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        hintText: 'Mobile',
                                        hintStyle: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            provider.errorMobileText.isEmpty
                                ? Container()
                                : ErrorText(error: provider.errorMobileText),
                            SizedBox(height: 15),
                            FadeInWidget(
                              duration: const Duration(milliseconds: 700),
                              child: Card(
                                margin: EdgeInsets.zero,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: TextFormField(
                                      controller: provider.ctlPassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Cant be Empty.";
                                        } else {
                                          return null;
                                        }
                                      },
                                      obscureText: provider.showHidePass,
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        suffixIconConstraints:
                                            const BoxConstraints(
                                              minWidth: 2,
                                              minHeight: 2,
                                            ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            provider.changeShowhidePass(
                                              provider.showHidePass,
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: Icon(
                                              provider.showHidePass
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: secondary,
                                            ),
                                          ),
                                        ),
                                        counterText: '',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            provider.errorPasswordText.isEmpty
                                ? Container()
                                : ErrorText(error: provider.errorPasswordText),
                            SizedBox(height: 8),
                            FadeInWidget(
                              duration: const Duration(milliseconds: 900),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.forgotPasswordScreen,
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password ??",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'sofiapro',
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            FadeInWidget(
                              duration: const Duration(milliseconds: 1000),
                              child: SizedBox(
                                width: size.width,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  onPressed:
                                      provider.btnEnable
                                          ? provider.isLoading
                                              ? null
                                              : () {
                                                final isValid =
                                                    _formKey.currentState!
                                                        .validate();

                                                if (!isValid) {
                                                  return;
                                                }

                                                provider.login(context);
                                              }
                                          : null,
                                  child:
                                      provider.isLoading
                                          ? const CommonButtonLoader()
                                          : const Text('Login'),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            FadeInWidget(
                              duration: const Duration(milliseconds: 1100),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have account ? ",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'sofiapro',
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.registrationScreen,
                                      );
                                    },
                                    child: Text(
                                      "Sign Up here.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'sofiapro',
                                        color: const Color.fromARGB(
                                          255,
                                          15,
                                          7,
                                          255,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.06),
                FadeInUp(
                  delay: const Duration(milliseconds: 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () async {
                        Navigator.pushNamed(
                          context,
                          RouteNames.youtubePlayerFlutter,
                          arguments: {
                            "videoLink": "https://youtu.be/qepAj0nQP7c",
                          },
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(color: secondary),
                            ),
                            elevation: 5,
                            child: Image(
                              width: size.width * 8,
                              image: const AssetImage(
                                'assets/images/login_video.jpeg',
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            "assets/images/youtube_logo.svg",
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
