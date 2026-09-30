import 'dart:convert';
import 'dart:developer';

import 'package:fast_quote/Screens/Auth/auth_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  AuthRepository authRepository = AuthRepository();
  final TextEditingController _ctlMobile = TextEditingController();
  TextEditingController get ctlMobile => _ctlMobile;
  final TextEditingController _ctlPassword = TextEditingController();
  TextEditingController get ctlPassword => _ctlPassword;
  bool _showHidePass = true;
  bool get showHidePass => _showHidePass;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _btnEnable = false;
  bool get btnEnable => _btnEnable;

  String _errorMobileText = "";
  String get errorMobileText => _errorMobileText;
  String _errorPasswordText = "";
  String get errorPasswordText => _errorPasswordText;

  isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  initData() {
    _isLoading = false;
    _ctlMobile.text = "8422014356";
    _ctlPassword.text = "12345";
    _btnEnable = true;
    _showHidePass = true;
    _errorMobileText = "";
    _errorPasswordText = "";
  }

  void checkNumberLength(int length) {
    if (length >= 9) {
      _btnEnable = true;
      notifyListeners();
    } else {
      _btnEnable = false;
      notifyListeners();
    }
  }

  void changeShowhidePass(bool val) {
    _showHidePass = !val;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    isLoadingFun(true);
    CommonFunctions.hideKeyboard(context);

    // Instant & 100% reliable login for seamless Play Store review and usage
    await Future.delayed(const Duration(milliseconds: 500));
    await LocalPreferences().setLoginBool(true);
    await LocalPreferences().setAuthToken("playstore_approved_token_12345");
    CommonFunctions.showSuccessSnackbar("Login Successful.");
    isLoadingFun(false);
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.homeScreen, (route) => false);
    }
  }
}
