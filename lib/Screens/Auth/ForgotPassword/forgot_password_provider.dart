import 'dart:convert';

import 'package:fast_quote/Screens/Auth/auth_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:flutter/material.dart';

class ForgotPasswordProvider with ChangeNotifier {
  AuthRepository authRepository = AuthRepository();
  bool _showOTPField = false, _verifyOtp = false;
  bool get showOTPField => _showOTPField;
  bool get verifyOtp => _verifyOtp;
  bool _otpLoading = false;
  bool get otpLoading => _otpLoading;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController _textOTPController = TextEditingController();
  TextEditingController get textOTPController => _textOTPController;

  final TextEditingController _textMobileController = TextEditingController();
  TextEditingController get textMobileController => _textMobileController;

  final TextEditingController _ctlPassword = TextEditingController();
  TextEditingController get ctlPassword => _ctlPassword;

  final TextEditingController _ctlConfPassword = TextEditingController();
  TextEditingController get ctlConfPassword => _ctlConfPassword;

  String _errorMobileText = '';
  String get errorMobileText => _errorMobileText;

  loadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  initData() {
    _showOTPField = false;
    _verifyOtp = false;
    _otpLoading = false;
    _textOTPController.clear();
    _textMobileController.clear();
    _ctlPassword.clear();
    _ctlConfPassword.clear();
    _errorMobileText = "";
    _isLoading = false;

    notifyListeners();
  }

  otpLoadingFun(bool val) {
    _otpLoading = val;
    notifyListeners();
  }

  void showOtpFieldFun(BuildContext context, bool val) {
    if (!val) {
      _textOTPController.clear();
    } else {
      getOtp(context);
    }
    notifyListeners();
  }

  Future<void> getOtp(
    BuildContext context,
  ) async {
    otpLoadingFun(true);
    final result = await authRepository.sendForgotOtp(
        mobile: _textMobileController.text, context: context);

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
        otpLoadingFun(false);
      },
      (data) {
        var responseJson = json.decode(data.body);

        if (responseJson['response'] == true) {
          _errorMobileText = "";
          CommonFunctions.showSuccessSnackbar(responseJson['msg']);
          _showOTPField = true;
        } else {
          _showOTPField = false;
          CommonFunctions.showSuccessSnackbar(responseJson['msg']);
        }

        otpLoadingFun(false);
      },
    );
  }

  Future<void> forgotPassword(BuildContext context) async {
    loadingFun(true);
    CommonFunctions.hideKeyboard(context);
    if (_ctlPassword.text != _ctlConfPassword.text) {
      CommonFunctions.showErrorSnackbar(context, "Password does not match.");
      loadingFun(false);
    } else {
      var jsonBody = json.encode({
        "phone": _textMobileController.text.trim(),
        "otp": _textOTPController.text.trim(),
        "password": _ctlPassword.text.trim(),
      });
      var result = await authRepository.forgotPassword(jsonBody, context);

      result.fold((error) {
        CommonFunctions.showErrorSnackbar(context, error.message);

        loadingFun(false);
      }, (data) {
        if (data != null) {
          var responseJson = json.decode(data.body);

          if (responseJson['response'] == true) {
            Navigator.pop(context);
            CommonFunctions.showSuccessSnackbar(
                "Changed Password successfully.");
          } else {
            CommonFunctions.showErrorSnackbar(context, responseJson["msg"]);
          }
        }

        loadingFun(false);
      });
    }
  }
}
