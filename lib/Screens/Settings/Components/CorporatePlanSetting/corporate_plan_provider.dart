import 'dart:convert';

import 'package:fast_quote/Screens/Settings/Components/CorporatePlanSetting/corporate_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:flutter/material.dart';

class CorporatePlanProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  bool _isLoading = true, _noDataFound = false;
  bool get isLoading => _isLoading;
  bool get noDataFound => _noDataFound;

  final TextEditingController _ctlMobile = TextEditingController();
  TextEditingController get ctlMobile => _ctlMobile;

  List<CorporateModel> _userList = [];
  List<CorporateModel> get userList => _userList;

  String _errorMobile = "";
  String get errorMobile => _errorMobile;

  DateTime currentDate = DateTime.now();
  initData() {
    _isLoading = true;
    _noDataFound = false;
    _userList.clear();
    _ctlMobile.clear();
    _errorMobile = "";
  }

  isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  getAssignedUsers(BuildContext context) async {
    initData();
    var storedModel = await CommonFunctions().getStoredProfileData();
    isLoadingFun(true);
    var result = await settingsRepository.getUserSubscription(context);

    result.fold((error) {
      isLoadingFun(false);
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) {
      //  _userList = data;

      _userList =
          data.where((element) => element.user!.id != storedModel.id).toList();

      isLoadingFun(false);
    });
  }

  Future addUserSubscription(BuildContext context) async {
    isLoadingFun(true);
    var passedData = json.encode({"mobile": _ctlMobile.text});
    var result =
        await settingsRepository.addUserSubscription(context, passedData);

    result.fold((error) {
      isLoadingFun(false);
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) {
      if (data != null) {
        var responseJson = json.decode(data.body);

        if (data.statusCode == 400) {
          responseJson['error'].forEach((k, v) {
            if (k == "mobile") {
              _errorMobile = v[0];
            }
          });
          isLoadingFun(false);
        } else {
          CommonFunctions.showSuccessSnackbar("User Added.");
          _ctlMobile.clear();
          getAssignedUsers(context);
        }
      }
    });
  }

  removeUser(BuildContext context, CorporateModel removedModel) async {
    DateTime sevenDaysAgo =
        removedModel.createdAt!.subtract(const Duration(days: 7));

    var passedData = json.encode({
      "company_id": null,
      "user_id": removedModel.user!.id!,
      "start_date": sevenDaysAgo.toIso8601String(),
      "end_date": removedModel.createdAt!.toIso8601String(),
      "sub_id": "1",
    });
    var result = await settingsRepository.upgradeSubscription(
        context, passedData, removedModel.id!);

    result.fold((error) {
      Navigator.pop(context);
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) {
      Navigator.pop(context);
      getAssignedUsers(context);
    });
  }
}
