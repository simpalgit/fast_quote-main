import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:flutter/material.dart';

class ChangePassProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  bool _showHidePass = true, _showHideRePass = true;
  bool get showHidePass => _showHidePass;
  bool get showHideRePass => _showHideRePass;

  final TextEditingController _ctlPassword = TextEditingController();
  TextEditingController get ctlPassword => _ctlPassword;
  final TextEditingController _ctlRePassword = TextEditingController();
  TextEditingController get ctlRePassword => _ctlRePassword;

  void initData() {
    _ctlPassword.clear();
    _ctlRePassword.clear();
    _showHidePass = true;
    _showHideRePass = true;
  }

  void changeShowhidePass(bool val) {
    _showHidePass = !val;
    notifyListeners();
  }

  void changeShowhideRePass(bool val) {
    _showHideRePass = !val;
    notifyListeners();
  }

  bool _isBtnLoading = false;
  bool get isBtnLoading => _isBtnLoading;

  void btnLoading(bool val) {
    _isBtnLoading = val;
    notifyListeners();
  }

  changePassword(BuildContext context) async {
    if (_ctlPassword.text == _ctlRePassword.text) {
      btnLoading(true);
      CommonFunctions.hideKeyboard(context);
      FormData formData = FormData.fromMap(
          {"password": _ctlPassword.text.trim(), "type": "User"});

      var result = await settingsRepository.updateProfile(context, formData);

      result.fold((error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
      }, (data) {
        if (data.statusCode == 400) {
          btnLoading(false);
          CommonFunctions.showErrorSnackbar(context, "Something went wrong..");
        } else {
          btnLoading(false);
          CommonFunctions.showSuccessSnackbar(
              "Password Changed Successfully..");
        }
      });
    } else {
      CommonFunctions.showErrorSnackbar(context, "Password not matching.");
    }
  }
}
