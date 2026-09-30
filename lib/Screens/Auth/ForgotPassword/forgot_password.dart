import 'package:fast_quote/Screens/Auth/ForgotPassword/forgot_password_provider.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart' as nbUtils;
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _forgotformKey = GlobalKey();

  bool passwordVisible = false, confirmpasswordVisible = false;
  bool showOTPField = false, showNewpasswordFields = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<ForgotPasswordProvider>(context, listen: false);
      provider.initData();
    });
    nbUtils.setStatusBarColor(bgColor);

    super.initState();
  }

  @override
  void dispose() {
    nbUtils.setStatusBarColor(primaryColor.withOpacity(0.05));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child:Center(
              child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(minWidth: 800, maxWidth: 800),
              child:             SingleChildScrollView(
                child: Form(
                  key: _forgotformKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: size.height * 0.2,
                          child: Lottie.asset('assets/gif/forgot_pass.json')),
                      Center(
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: primaryColor),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          'Enter your registered mobile number and we shall send you a OTP. Verify it and reset your password.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 12)),
                      Consumer<ForgotPasswordProvider>(
                        builder: (context, provider, child) {
                          return TextFormField(
                            style: TextStyle(fontSize: 15.sp),
                            controller: provider.textMobileController,
                            key: const ValueKey('mobile'),
                            maxLength: 10,
                            onChanged: (value) {
                              if (value.length > 9) {
                                provider.showOtpFieldFun(context, true);
                              } else {
                                provider.showOtpFieldFun(context, false);
                              }
                            },
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            validator: (value) {
                              String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = RegExp(patttern);
                              if (value!.isEmpty ||
                                  value.length < 10 ||
                                  value.length > 10) {
                                return 'Please enter mobile number';
                              } else if (!regExp.hasMatch(value)) {
                                return 'Please enter valid mobile number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              suffix: provider.otpLoading
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    )
                                  : const SizedBox(),
                              counterText: "",
                              hintStyle: TextStyle(fontSize: 15.sp),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.blueGrey,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.blueGrey,
                                  )),
                              labelText: 'Mobile Number',
                              hintText: 'Enter Mobile Number',
                            ),
                          );
                        },
                      ),
                      Consumer<ForgotPasswordProvider>(
                          builder: (context, provider, child) {
                        return provider.showOTPField
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  const Text(
                                    "Enter OTP",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  darkRoundedPinPut(provider),
                                  TextButton(
                                      onPressed: () {
                                        provider.getOtp(context);
                                      },
                                      child: Text(
                                        'Resend Otp',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                      )),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontSize: 15.sp),
                                    controller: provider.ctlPassword,
                                    obscureText: !passwordVisible,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                    enableSuggestions: false,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter password.';
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: 15.sp),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            width: 2,
                                            color: Colors.blueGrey,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            width: 2,
                                            color: Colors.blueGrey,
                                          )),
                                      labelText: 'New Password',
                                      hintText: 'Enter New Password.',
                                      suffixIcon: IconButton(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        icon: Icon(
                                          !passwordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        color: primaryColor,
                                        iconSize: 18.0,
                                        onPressed: () => setState(
                                          () =>
                                              passwordVisible = !passwordVisible,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 12)),
                                  TextFormField(
                                    style: TextStyle(fontSize: 15),
                                    controller: provider.ctlConfPassword,
                                    obscureText: !confirmpasswordVisible,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                    enableSuggestions: false,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter confirm password.';
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: 15),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            width: 2,
                                            color: Colors.blueGrey,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          borderSide: const BorderSide(
                                            width: 2,
                                            color: Colors.blueGrey,
                                          )),
                                      labelText: 'Confirm Password',
                                      hintText: 'Enter Confirm Password.',
                                      suffixIcon: IconButton(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        icon: Icon(
                                          !confirmpasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        color: primaryColor,
                                        iconSize: 18.sp,
                                        onPressed: () => setState(
                                          () => confirmpasswordVisible =
                                              !confirmpasswordVisible,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 12)),
                                  Center(
                                    child: SizedBox(
                                      width: 300,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: secondary,
                                            shape: const StadiumBorder()),
                                        onPressed: () {
                                          final isValid = _forgotformKey
                                              .currentState!
                                              .validate();
              
                                          if (!isValid) {
                                            return;
                                          }
              
                                          provider.forgotPassword(context);
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container();
                      }),
                      const Padding(padding: EdgeInsets.only(top: 6)),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Back to login',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
                        ),
            ),
        )));
  }

  Widget darkRoundedPinPut(ForgotPasswordProvider provider) {
    return Pinput(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter OTP.';
        } else {
          return null;
        }
      },
      controller: provider.textOTPController,

      // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      // listenForMultipleSmsOnAndroid: true,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 20),
      // validator: (value) {},
      onTap: () => FocusScope.of(context).unfocus(),
      // onClipboardFound: (value) {
      //   debugPrint('onClipboardFound: $value');
      //   pinController.setText(value);
      // },
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: (pin) {
        debugPrint('onCompleted: $pin');
        // provider.loginUser(otp: "12345", context: context);
      },
      onChanged: (value) {
        debugPrint('onChanged: $value');
      },
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 22,
            height: 1,
            // color: focusedBorderColor,
          ),
        ],
      ),

      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: blackColor),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: blackColor),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.redAccent),
        ),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 22,
      color: secondary,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: primaryColor, width: 2),
    ),
  );
}
