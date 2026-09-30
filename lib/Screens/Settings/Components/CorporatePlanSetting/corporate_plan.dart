import 'dart:ui';

import 'package:fast_quote/Screens/Settings/Components/CorporatePlanSetting/corporate_model.dart';
import 'package:fast_quote/Screens/Settings/Components/CorporatePlanSetting/corporate_plan_provider.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:fast_quote/Widgets/input_fields.dart';
import 'package:fast_quote/Widgets/shimmer_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class CorporatePlanScreen extends StatefulWidget {
  const CorporatePlanScreen({super.key});

  @override
  State<CorporatePlanScreen> createState() => _CorporatePlanScreenState();
}

class _CorporatePlanScreenState extends State<CorporatePlanScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<CorporatePlanProvider>(
        context,
        listen: false,
      );
      provider.getAssignedUsers(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final provider = Provider.of<CorporatePlanProvider>(context);
    return Scaffold(
      appBar: commonAppBar(context: context, heading: 'Corporate Setting'),
      body:
          provider.isLoading
              ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) {
                  return SizedBox(height: 2.h);
                },
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: BorderSide(color: secondary),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(width: double.infinity, height: 7.h),
                          SizedBox(height: 10.h),
                          ShimmerBox(width: size.width / 2, height: 7.h),
                          SizedBox(height: 5.h),
                          ShimmerBox(width: size.width / 3, height: 7.h),
                        ],
                      ),
                    ),
                  );
                },
              )
              : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 10.w,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: StepperTextField(
                                controllerValue: provider.ctlMobile,
                                inputType: TextInputType.phone,
                                validate: (val) {
                                  if (val!.isEmpty) {
                                    return "Field Cant be empty";
                                  } else if (val.length < 10) {
                                    return "mobile num 10";
                                  } else {
                                    return null;
                                  }
                                },
                                mLength: 10,
                                hintValue: "Mobile",
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ElevatedButton(
                              onPressed: () {
                                if (provider.ctlMobile.length == 10) {
                                  if (provider.userList.length < 4) {
                                    showAddDialogue(
                                      context,
                                      provider,
                                      provider.ctlMobile.text,
                                    );
                                  } else {
                                    CommonFunctions.showWarningSnackbar(
                                      context,
                                      "Your subscription has only allow to add 4 Users.",
                                    );
                                  }
                                } else {
                                  CommonFunctions.showErrorSnackbar(
                                    context,
                                    "10 Digit mobile required.",
                                  );
                                }
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                        provider.errorMobile.isEmpty
                            ? Container()
                            : ErrorText(error: provider.errorMobile),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 5.h);
                      },
                      itemCount: provider.userList.length,
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 10.w,
                      ),
                      itemBuilder: (context, index) {
                        CorporateModel user = provider.userList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            side: BorderSide(color: secondary),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 15.sp,
                                  left: 15.sp,
                                  right: 15.sp,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            user.user!.name!,
                                            style: headerTextStyle(),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Type :  ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              user.user!.type!,
                                              style: subTextStyle(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.phone_circle_fill,
                                          color: primaryColor,
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          user.user!.phone!,
                                          style: subTextStyle(),
                                        ),
                                        const Text(
                                          "  |  ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          CupertinoIcons.mail_solid,
                                          color: primaryColor,
                                        ),
                                        SizedBox(width: 5.w),
                                        Flexible(
                                          child: Text(
                                            user.user!.email!,
                                            style: subTextStyle(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.calendar_circle,
                                          color: primaryColor,
                                        ),
                                        SizedBox(width: 5.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5.h,
                                            horizontal: 10.w,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.green,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "From - ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteColor,
                                                ),
                                              ),
                                              Text(
                                                user.startDate!
                                                    .toIso8601String()
                                                    .split('T')
                                                    .first,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          "  |  ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5.h,
                                            horizontal: 10.w,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.red,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "To : ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteColor,
                                                ),
                                              ),
                                              Text(
                                                user.endDate!
                                                    .toIso8601String()
                                                    .split('T')
                                                    .first,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
                                  onTap: () {
                                    showAlertDialouge(user, context, provider);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(7.r),
                                        bottomRight: Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          CupertinoIcons.delete,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10.w),
                                        const Text(
                                          'Remove',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  void showAlertDialouge(
    CorporateModel user,
    BuildContext context,
    CorporatePlanProvider provider,
  ) {
    showDialog(
      barrierColor: Colors.white.withOpacity(0.1),
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            titleTextStyle: TextStyle(fontSize: 12.sp, color: secondary),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_forever_rounded,
                  color: primaryColor,
                  size: 80.0,
                ),
                SizedBox(height: 10.h),
                Text(
                  '*This will remove trial period of user if user is in trial period..',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Are you sure you want to remove this user from Subscription services??',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            // content: const Text('FilerBackDrop'),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: secondary),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                  ),
                  SizedBox(width: 30.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: secondary),
                    onPressed: () {
                      provider.removeUser(context, user);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showAddDialogue(
    BuildContext context,
    CorporatePlanProvider provider,
    String mobile,
  ) {
    showDialog(
      barrierColor: Colors.white.withOpacity(0.1),
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            titleTextStyle: TextStyle(fontSize: 12.sp, color: secondary),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.group_add_outlined, color: primaryColor, size: 80.0),
                SizedBox(height: 10.h),
                Text(
                  'Are you sure you want to add +91$mobile to user subscription.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            // content: const Text('FilerBackDrop'),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: secondary),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                  ),
                  SizedBox(width: 30.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: secondary),
                    onPressed: () {
                      Navigator.pop(context);
                      provider.addUserSubscription(context);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
