import 'dart:ui' as ui;

import 'package:fast_quote/Screens/Auth/Registration/registration_provider.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/common_loaders.dart';
import 'package:fast_quote/Widgets/error_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart' as nbUtils;
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../Utils/constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
      Provider.of<RegistrationProvider>(context, listen: false);
      provider.iniData();
    });
    nbUtils.setStatusBarColor(primaryColor.withOpacity(0.05));

    super.initState();
  }

  @override
  void dispose() {
    nbUtils.setStatusBarColor(primaryColor.withOpacity(0.05));
    super.dispose();
  }

  String strCode = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minWidth: 700, maxWidth: 700),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Column(
                children: [
                  // --- Header Banner & Logo Section ---
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: size.height * 0.24,
                        child: Stack(
                          children: [
                            Container(
                              height: size.height * 0.20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.elliptical(200.w, 70.h),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    primaryColor,
                                    primaryColor.withOpacity(0.85),
                                    secondary.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(
                                    sigmaX: 1.0, sigmaY: 2.0),
                                child: Container(
                                  height: 10.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: primaryColor, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 26.w, vertical: 14.h),
                          child: Text(
                            'Q',
                            style: TextStyle(
                              fontSize: 28.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  // --- Title & Subtitle ---
                  Text(
                    'Create Account',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 22.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Sign up to get started with FastQuote',
                    style: TextStyle(
                      color: secondary.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // --- Form Fields ---
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Username
                          _buildCustomInputCard(
                            child: TextFormField(
                              controller: provider.ctlUserName,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Cant be Empty.";
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                hintText: 'Username',
                                prefixIcon: Icons.person_outline_rounded,
                              ),
                            ),
                          ),
                          if (provider.errorUserNameText.isNotEmpty)
                            ErrorText(error: provider.errorUserNameText),
                          SizedBox(height: 14.h),

                          // Mobile Number
                          _buildCustomInputCard(
                            child: TextFormField(
                              readOnly: provider.otpVerified,
                              onChanged: (val) {
                                if (val.length == 10) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }
                                provider.onChangedFun(val, context);
                              },
                              keyboardType: TextInputType.phone,
                              controller: provider.ctlMobile,
                              maxLength: 10,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Cant be Empty.";
                                } else if (value.length < 10) {
                                  return "enter 10 digit mobile number";
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                hintText: 'Mobile',
                                prefixIcon: Icons.phone_android_rounded,
                              ),
                            ),
                          ),
                          if (provider.errorMobileText.isNotEmpty)
                            ErrorText(error: provider.errorMobileText),

                          // --- OTP Section ---
                          if (provider.otpLoading)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Column(
                                children: [
                                  const CommonButtonLoader(),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'sending otp..',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontSize: 13.sp,
                                    ),
                                  )
                                ],
                              ),
                            )
                          else if (provider.showOtp)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 12.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.08),
                                        borderRadius:
                                        BorderRadius.circular(8.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.mark_email_read_rounded,
                                              size: 16.sp, color: primaryColor),
                                          SizedBox(width: 6.w),
                                          Text(
                                            "OTP sent to ${provider.mobileNn}",
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  darkRoundedPinPut(provider),
                                  SizedBox(height: 8.h),
                                  TextButton(
                                    onPressed: () {
                                      provider.getOtp(context);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: primaryColor,
                                    ),
                                    child: Text(
                                      'Resend OTP',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          SizedBox(height: 14.h),

                          // Email
                          _buildCustomInputCard(
                            child: TextFormField(
                              controller: provider.ctlEmail,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Cant be Empty.";
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icons.email_outlined,
                              ),
                            ),
                          ),
                          if (provider.errorEmailText.isNotEmpty)
                            ErrorText(error: provider.errorEmailText),
                          SizedBox(height: 14.h),

                          // Password
                          _buildCustomInputCard(
                            child: TextFormField(
                              controller: provider.ctlPassword,
                              obscureText: provider.showHidePass,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Cant be Empty.";
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                hintText: 'Password',
                                prefixIcon: Icons.lock_outline_rounded,
                                suffixIcon: InkWell(
                                  borderRadius: BorderRadius.circular(20.r),
                                  onTap: () {
                                    provider.changeShowhidePass(
                                        provider.showHidePass);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 8.h),
                                    child: Icon(
                                      provider.showHidePass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: secondary.withOpacity(0.7),
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (provider.errorPasswordText.isNotEmpty)
                            ErrorText(error: provider.errorPasswordText),
                          SizedBox(height: 14.h),

                          // Confirm Password
                          _buildCustomInputCard(
                            child: TextFormField(
                              controller: provider.ctlConfPassword,
                              obscureText: provider.showHideConfPassPass,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Cant be Empty.";
                                }
                                return null;
                              },
                              decoration: _buildInputDecoration(
                                hintText: 'Confirm Password',
                                prefixIcon: Icons.lock_reset_rounded,
                                suffixIcon: InkWell(
                                  borderRadius: BorderRadius.circular(20.r),
                                  onTap: () {
                                    provider.changeShowhideConfPass(
                                        provider.showHideConfPassPass);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 8.h),
                                    child: Icon(
                                      provider.showHideConfPassPass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: secondary.withOpacity(0.7),
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Sign Up Button
                          SizedBox(
                            width: size.width,
                            height: 50.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: primaryColor.withOpacity(0.35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed: provider.isLoading
                                  ? null
                                  : () {
                                final isValid =
                                _formKey.currentState!.validate();
                                if (!isValid) {
                                  return;
                                }

                                provider.registerUser(
                                    context, "userType");
                              },
                              child: provider.isLoading
                                  ? const CommonButtonLoader()
                                  : Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Already have an account Footer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: blackColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(4.r),
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteNames.loginScreen,
                                          (route) => false);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 2.h),
                                  child: Text(
                                    "Sign In here.",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Reusable Modern Container Card Helper ---
  Widget _buildCustomInputCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: child,
      ),
    );
  }

  // --- Reusable InputDecoration Helper ---
  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      counterText: '',
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      prefixIcon: Icon(
        prefixIcon,
        color: primaryColor.withOpacity(0.7),
        size: 20.sp,
      ),
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: TextStyle(
        color: primaryColor.withValues(alpha: 0.45),
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
      ),
      fillColor: Colors.transparent,
    );
  }

  // --- Pinput Configuration ---
  Widget darkRoundedPinPut(RegistrationProvider provider) {
    return Pinput(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter OTP.';
        }
        return null;
      },
      controller: provider.textOTPController,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => SizedBox(width: 12.w),
      onTap: () => FocusScope.of(context).unfocus(),
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: (pin) {
        debugPrint('onCompleted: $pin');
      },
      onChanged: (value) {
        debugPrint('onChanged: $value');
      },
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 9.h),
            width: 20.w,
            height: 2.h,
            color: primaryColor,
          ),
        ],
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: primaryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: primaryColor, width: 1.5),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 48.w,
    height: 50.h,
    textStyle: TextStyle(
      fontSize: 20.sp,
      color: primaryColor,
      fontWeight: FontWeight.bold,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: primaryColor.withValues(alpha:      0.25), width: 1.5),
    ),
  );
}