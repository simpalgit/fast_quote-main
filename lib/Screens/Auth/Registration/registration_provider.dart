import 'dart:convert';

import 'package:fast_quote/Screens/Auth/auth_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:flutter/material.dart';

import '../../../Utils/route_names.dart';

class RegistrationProvider with ChangeNotifier {
  AuthRepository authRepository = AuthRepository();
  final TextEditingController _ctlMobile = TextEditingController();
  TextEditingController get ctlMobile => _ctlMobile;

  final TextEditingController _ctlUserName = TextEditingController();
  TextEditingController get ctlUserName => _ctlUserName;

  final TextEditingController _ctlEmail = TextEditingController();
  TextEditingController get ctlEmail => _ctlEmail;
  final TextEditingController _ctlPassword = TextEditingController();
  TextEditingController get ctlPassword => _ctlPassword;

  final TextEditingController _ctlConfPassword = TextEditingController();
  TextEditingController get ctlConfPassword => _ctlConfPassword;
  bool _showHidePass = true;
  bool get showHidePass => _showHidePass;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorUserNameText = '';
  String get errorUserNameText => _errorUserNameText;

  String _errorMobileText = '';
  String get errorMobileText => _errorMobileText;

  String _errorEmailText = '';
  String get errorEmailText => _errorEmailText;

  String _errorPasswordText = '';
  String get errorPasswordText => _errorPasswordText;

  String _errorType = '';
  String get errorType => _errorType;

  bool _showOtp = false;
  bool get showOtp => _showOtp;

  String _mobileNo = "";
  String get mobileNn => _mobileNo;

  bool _otpLoading = false;
  bool get otpLoading => _otpLoading;

  bool _readOnly = false;
  bool get readOnly => _readOnly;

  bool _otpVerified = false;
  bool get otpVerified => _otpVerified;

  bool _showHideConfPassPass = true;
  bool get showHideConfPassPass => _showHideConfPassPass;
  final TextEditingController _textOTPController = TextEditingController();
  TextEditingController get textOTPController => _textOTPController;

  iniData() {
    _otpVerified = false;
    _readOnly = false;
    _mobileNo = "";
    _errorUserNameText = "";
    _errorMobileText = "";
    _errorPasswordText = "";
    _errorType = "";
    _errorEmailText = "";
    _otpLoading = false;
    _otpVerified = false;
    _showHideConfPassPass = true;
    _mobileNo = "";
    _showOtp = false;
    _isLoading = false;
    _showHidePass = true;
    _ctlMobile.clear();
    _ctlUserName.clear();
    _ctlEmail.clear();
    _ctlPassword.clear();
    _ctlConfPassword.clear();
    textOTPController.clear();

    notifyListeners();
  }

  void changeShowhidePass(bool val) {
    _showHidePass = !val;
    notifyListeners();
  }

  void changeShowhideConfPass(bool val) {
    _showHideConfPassPass = !val;
    notifyListeners();
  }

  otpLoadingFun(bool val) {
    _otpLoading = val;
    notifyListeners();
  }

  loadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void onChangedFun(String mobile, BuildContext context) async {
    if (mobile.length == 10) {
      _mobileNo = mobile;
      getOtp(context);
    } else {
      _errorMobileText = "";
      _showOtp = false;
      notifyListeners();
    }
  }

  Future<void> registerUser(BuildContext context, String userType) async {
    loadingFun(true);
    CommonFunctions.hideKeyboard(context);
    if (_ctlPassword.text != _ctlConfPassword.text) {
      CommonFunctions.showErrorSnackbar(context, "Password does not match.");
      loadingFun(false);
    } else {
      var jsonBody = json.encode({
        "name": _ctlUserName.text.trim(),
        "phone": _ctlMobile.text.trim(),
        "password": _ctlPassword.text.trim(),
        "type": "User",
        "otp": _textOTPController.text,
        "email": _ctlEmail.text.trim(),
      });
      var result = await authRepository.registerUser(jsonBody, context);

      result.fold((error) {
        CommonFunctions.showErrorSnackbar(context, error.message);

        loadingFun(false);
      }, (data) {
        _errorUserNameText = "";
        _errorMobileText = "";
        _errorPasswordText = "";
        _errorType = "";
        _errorEmailText = "";
        if (data != null) {
          var responseJson = json.decode(data.body);

          if (data.statusCode == 400) {
            responseJson['error'].forEach((k, v) {
              if (k == "name") {
                _errorUserNameText = v[0];
              }
              if (k == "phone") {
                _errorMobileText = v[0];
              }
              if (k == "password") {
                _errorPasswordText = v[0];
              }
              if (k == "type") {
                _errorType = v[0];
              }
              if (k == "email") {
                _errorEmailText = v[0];
              }
            });
          } else {
            if (responseJson['response'] == true) {
              CommonFunctions.showSuccessSnackbar("Login with new credentials");
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteNames.loginScreen, (route) => false);
            } else {
              CommonFunctions.showErrorSnackbar(context, responseJson['msg']);
            }
          }
        }

        loadingFun(false);
      });
    }
  }

  Future<void> getOtp(BuildContext context) async {
    otpLoadingFun(true);
    final result =
        await authRepository.sendOtp(mobile: _ctlMobile.text, context: context);

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
        otpLoadingFun(false);
      },
      (data) {
        _errorMobileText = "";

        if (data != null) {
          var responseJson = json.decode(data.body);

          if (data.statusCode == 400) {
            if (responseJson['response'] == false) {
              responseJson['error'].forEach((k, v) {
                if (k == "phone") {
                  _errorMobileText = v[0];
                }
              });
            }
          } else if (data.statusCode == 200) {
            _showOtp = true;
            CommonFunctions.showSuccessSnackbar("Otp sent Successfully");
          }
        }

        otpLoadingFun(false);
      },
    );
  }
}
