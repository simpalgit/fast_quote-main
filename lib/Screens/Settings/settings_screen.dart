import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fast_quote/Screens/Settings/Components/Profile/profile_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/custom_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/common_appbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsRepository settingsRepository = SettingsRepository();
  bool isDeleting = false;
  @override
  void initState() {
    getInitData();

    super.initState();
  }

  ProfileModel profileModel = ProfileModel();
  bool businessFill = false,
      quotationFill = false,
      invoiceFill = false,
      hasPlan = false;

  navigateToupdateProfile() async {
    await Navigator.pushNamed(context, RouteNames.profileScreen)
        .then(onRefresh);
  }

  navigateToBusinessSettings() async {
    await Navigator.pushNamed(context, RouteNames.manageBusiness)
        .then(onRefresh);
  }

  navigateToQuotationSettings() async {
    await Navigator.pushNamed(context, RouteNames.quotationSetting)
        .then(onRefresh);
  }

  navigateToInvoiceSettings() async {
    await Navigator.pushNamed(context, RouteNames.invoiceSetting)
        .then(onRefresh);
  }

  navigateToSubscriptionSettings() async {
    await Navigator.pushNamed(context, RouteNames.subscriptionScreen)
        .then(onRefresh);
  }

  FutureOr onRefresh(dynamic value) {
    getInitData();
  }

  int subscriptionId = 0;

  getInitData() async {
    profileModel = await CommonFunctions().getStoredProfileData();
    subscriptionId = await LocalPreferences().getSubscriptionId() ?? 0;

    businessFill = await LocalPreferences().getBusinessFill() ?? false;
    quotationFill = await LocalPreferences().getQuotationFill() ?? false;
    invoiceFill = await LocalPreferences().getInvoiceFill() ?? false;
    hasPlan = await LocalPreferences().getHasPlan() ?? false;
    setState(() {});
  }

  deleteAccount(BuildContext context) async {
    setState(() {
      isDeleting = true;
    });
    CommonFunctions.showProgressBar(context);
    var result =
        await settingsRepository.deleteAccount(context, profileModel.id!);

    result.fold((error) {
      Navigator.of(context)
        ..pop()
        ..pop();
      setState(() {
        isDeleting = false;
      });
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) async {
      setState(() {
        isDeleting = false;
      });
      LocalPreferences().setLoginBool(false);
      final preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      if (context.mounted) {
        CommonFunctions().logOut(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(
        context: context, heading: 'Settings',
        // widgetList: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => const MerchantApp()));
        //       },
        //       icon: const Icon(
        //         Icons.add,
        //         color: Colors.black,
        //       ))
        // ]
      ),
      body:Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minWidth: 800, maxWidth: 800),
child:       SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              FadeIn(
                delay: const Duration(milliseconds: 300),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.height * 0.3),
                    child: CustomImage(
                      path: profileModel.image,
                      height: size.height * .14,
                      width: size.height * .14,
                      fit: BoxFit.fill,
                    )),
              ),
              SizedBox(
                height: 12.h,
              ),
              FadeIn(
                delay: const Duration(milliseconds: 350),
                child: Text(
                  profileModel.name ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondary,
                      letterSpacing: 0.8),
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: ProfileCardHelper(
                  heading: "Profile",
                  onPressed: () {
                    navigateToupdateProfile();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const MerchantApp()));
                  },
                  passIcon: CupertinoIcons.person_solid,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 250),
                child: ProfileCardHelper(
                  fillBusiness: businessFill,
                  heading: "Manage Business",
                  onPressed: () {
                    navigateToBusinessSettings();
                  },
                  passIcon: CupertinoIcons.building_2_fill,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: ProfileCardHelper(
                  heading: "Column Heading",
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.columnHeading);
                  },
                  passIcon: CupertinoIcons.list_bullet_below_rectangle,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 350),
                child: ProfileCardHelper(
                  fillQuotationSetting: quotationFill,
                  heading: "Quotation Settings",
                  onPressed: () {
                    navigateToQuotationSettings();
                  },
                  passIcon: CupertinoIcons.doc_circle,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: ProfileCardHelper(
                  fillInvoiceSetting: invoiceFill,
                  heading: "Invoice Settings",
                  onPressed: () {
                    navigateToInvoiceSettings();
                  },
                  passIcon: CupertinoIcons.doc_circle,
                ),
              ),
              // subscriptionId == 3
              hasPlan
                  ? Column(
                      children: [
                        SizedBox(
                          height: 14.h,
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 450),
                          child: ProfileCardHelper(
                            tileColor: const Color(0xFFffd700),
                            heading: "Corporate Plan Setting",
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RouteNames.corporatePlanScreen);
                            },
                            passIcon:
                                CupertinoIcons.person_crop_circle_badge_plus,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),

              Column(
                children: [
                  SizedBox(
                    height: 14.h,
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: ProfileCardHelper(
                      heading: "Subscription",
                      onPressed: () {
                        navigateToSubscriptionSettings();
                      },
                      passIcon: CupertinoIcons.doc_circle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 550),
                child: ProfileCardHelper(
                  heading: "Payment history",
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.paymmentHistory);
                  },
                  passIcon: CupertinoIcons.doc_circle,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: ProfileCardHelper(
                  heading: "Refund Policy",
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.webviewScreen,
                        arguments: {
                          "appBartitle": "Refund Policy",
                          "url": "https://fastquote.co.in/refund-policy.php"
                        });
                  },
                  passIcon: CupertinoIcons.doc_circle,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 650),
                child: ProfileCardHelper(
                  heading: "Terms & Conditions",
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.webviewScreen,
                        arguments: {
                          "appBartitle": "Terms & Conditions",
                          "url": "https://fastquote.co.in/terms-condition.php"
                        });
                  },
                  passIcon: CupertinoIcons.doc_circle,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: ProfileCardHelper(
                  heading: "Privacy Policy",
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.webviewScreen,
                        arguments: {
                          "appBartitle": "Privacy Policy",
                          "url": "https://fastquote.co.in/privacy-policy.php"
                        });
                  },
                  passIcon: CupertinoIcons.doc_circle,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 750),
                child: ProfileCardHelper(
                  heading: "Delete Account",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => PlaceholderDialog(
                        icon: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.close))),
                            Icon(
                              Icons.delete_forever_rounded,
                              color: primaryColor,
                              size: 80.0,
                            ),
                          ],
                        ),
                        title: 'Delete Account',
                        message:
                            'This will erase all your data and you cannot create your account again with this mobile number. \n\n Are you sure you want to delete your account ?? ',
                        actions: [
                          isDeleting
                              ? const SizedBox(
                                  height: 10,
                                  width: 15,
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)))),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('No'),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.03,
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              shape: WidgetStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)))),
                                          onPressed: () {
                                            deleteAccount(context);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                        ],
                      ),
                    );
                  },
                  passIcon: Icons.delete_forever_rounded,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              FadeInUp(
                delay: const Duration(milliseconds: 750),
                child: ProfileCardHelper(
                  heading: "Logout",
                  onPressed: () async {
                    LocalPreferences().setLoginBool(false);
                    final preferences = await SharedPreferences.getInstance();
                    await preferences.clear();
                    if (context.mounted) {
                      CommonFunctions().logOut(context);
                    }
                  },
                  passIcon: CupertinoIcons.square_arrow_left,
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              Text(
                'AppVersion 1.0.0',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: secondary,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          )),
    ));
  }
}

class ProfileCardHelper extends StatelessWidget {
  final VoidCallback onPressed;
  final String heading;
  final IconData passIcon;
  final bool? fillBusiness;
  final bool? fillInvoiceSetting;
  final bool? fillQuotationSetting;
  final Color? tileColor;

  const ProfileCardHelper(
      {super.key,
      this.fillBusiness = true,
      this.fillInvoiceSetting = true,
      this.fillQuotationSetting = true,
      required this.heading,
      required this.onPressed,
      required this.passIcon,
      this.tileColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: tileColor ?? Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: tileColor != null ? Colors.brown : primaryColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 12.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      heading,
                      style: TextStyle(
                          color:
                              tileColor != null ? Colors.brown : primaryColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ),
                  Icon(
                    passIcon,
                    color: tileColor != null ? Colors.brown : primaryColor,
                  )
                ],
              ),
            ),
            !fillBusiness!
                ? const FillUpWidget(
                    text: 'Fill up your Business settings.',
                  )
                : Container(),
            !fillInvoiceSetting!
                ? const FillUpWidget(
                    text: 'Fill up your Invoice settings.',
                  )
                : Container(),
            !fillQuotationSetting!
                ? const FillUpWidget(
                    text: 'Fill up your Quotation settings.',
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class FillUpWidget extends StatelessWidget {
  final String text;
  const FillUpWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          Icon(
            CupertinoIcons.info_circle,
            color: whiteColor,
            size: 15,
          ),
          SizedBox(
            width: 5.w,
          ),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                text,
                speed: const Duration(milliseconds: 150),
                textStyle: TextStyle(
                  color: whiteColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            isRepeatingAnimation: true,
            repeatForever: true,
            displayFullTextOnTap: true,
            stopPauseOnTap: false,
          ),
        ],
      ),
    );
  }
}

class PlaceholderDialog extends StatelessWidget {
  const PlaceholderDialog({
    this.icon,
    this.title,
    this.message,
    this.actions = const [],
    super.key,
  });

  final Widget? icon;
  final String? title;
  final String? message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        icon: icon,
        title: title == null
            ? null
            : Text(
                title!,
                textAlign: TextAlign.center,
              ),
        titleTextStyle: TextStyle(
            color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15.sp),
        content: message == null
            ? null
            : Text(
                message!,
                textAlign: TextAlign.center,
              ),
        contentTextStyle: TextStyle(
            color: secondary, fontWeight: FontWeight.bold, fontSize: 14.sp),
        actionsAlignment: MainAxisAlignment.center,
        actionsOverflowButtonSpacing: 8.0,
        actions: actions,
      );
    });
  }
}
