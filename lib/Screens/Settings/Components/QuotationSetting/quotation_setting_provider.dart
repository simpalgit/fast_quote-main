import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fast_quote/Screens/Settings/Components/Profile/profile_provider.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuotationSettingsProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  final TextEditingController _ctlNumberPrefix = TextEditingController();
  TextEditingController get ctlNumberPrefix => _ctlNumberPrefix;

  final TextEditingController _ctlSerialNumber = TextEditingController();
  TextEditingController get ctlSerialNumber => _ctlSerialNumber;

  final TextEditingController _ctlDiscountDisplay = TextEditingController();
  TextEditingController get ctlDiscountDisplay => _ctlDiscountDisplay;

  final TextEditingController _ctlTaxDisplay = TextEditingController();
  TextEditingController get ctlTaxDisplay => _ctlTaxDisplay;

  final TextEditingController _ctlProductDisplay = TextEditingController();
  TextEditingController get ctlProductDisplay => _ctlProductDisplay;

  final TextEditingController _ctlTopMessage = TextEditingController();
  TextEditingController get ctlTopMessage => _ctlTopMessage;

  final TextEditingController _ctlBottomMessage = TextEditingController();
  TextEditingController get ctlBottomMessage => _ctlBottomMessage;

  final TextEditingController _ctlPaymentInstruction = TextEditingController();
  TextEditingController get ctlPaymentInstruction => _ctlPaymentInstruction;

  setDiscountDisplay(String text) {
    _ctlDiscountDisplay.text = text;
    notifyListeners();
  }

  setTaxDisplay(String text) {
    _ctlTaxDisplay.text = text;
    notifyListeners();
  }

  setProductDisplayType(String text) {
    _ctlProductDisplay.text = text;
    notifyListeners();
  }

  setBankInfoDisplay(String text) {
    _ctlPaymentInstruction.text = text;
    notifyListeners();
  }

  String _id = "";
  String get id => _id;
  String _errorPrefix = "";
  String get errorPrefix => _errorPrefix;

  void initData() {
    _id = "";
    _errorPrefix = "";
    _ctlNumberPrefix.clear();
    _ctlSerialNumber.clear();
    _ctlDiscountDisplay.clear();
    _ctlTaxDisplay.clear();
    _errorPrefix = "";
    _ctlProductDisplay.clear();
    _ctlTopMessage.clear();
    _ctlBottomMessage.clear();
    _ctlPaymentInstruction.clear();
    notifyListeners();
  }

  Future<void> getQuotationSettingsData(BuildContext context) async {
    CommonFunctions.showProgressBar(context);
    var storedModel = await CommonFunctions().getStoredProfileData();
    initData();
    var result = await settingsRepository.getQuoteSettingsData(
      context,
      storedModel.id!,
    );

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);

        Navigator.pop(context);
      },
      (data) {
        if (data.id != null) {
          _id = data.id!;
        } else {
          _id = "";
        }

        _ctlNumberPrefix.text = data.prefix ?? "";
        ctlSerialNumber.text = data.serialNo ?? "";
        ctlDiscountDisplay.text = data.discount ?? '';
        _ctlTaxDisplay.text = data.tax ?? '';
        _ctlProductDisplay.text = data.product ?? '';
        _ctlTopMessage.text = data.topMessage ?? '';
        _ctlBottomMessage.text = data.bottomMsg ?? '';
        _ctlPaymentInstruction.text = data.bankDetails ?? '';

        notifyListeners();
        Navigator.pop(context);
      },
    );
  }

  Future<void> uploadUpdateQuotationSettingsData(BuildContext context) async {
    CommonFunctions.showProgressBar(context);

    var jsonBody = json.encode({
      "prefix": _ctlNumberPrefix.text.trim(),
      "serial_no": ctlSerialNumber.text.trim(),
      "discount": ctlDiscountDisplay.text.trim(),
      "tax": _ctlTaxDisplay.text.trim(),
      "product": _ctlProductDisplay.text.trim(),
      "top_message": _ctlTopMessage.text.trim(),
      "bottom_msg": _ctlBottomMessage.text.trim(),
      "bank_details": _ctlPaymentInstruction.text.trim(),
    });

    Either<Failure, dynamic> result;

    if (_id == "") {
      result = await settingsRepository.postQuoteSettingsData(
        context,
        jsonBody,
      );
    } else {
      result = await settingsRepository.putQuoteSettingsData(
        context,
        jsonBody,
        _id,
      );
    }

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);

        Navigator.pop(context);
      },
      (data) {
        _errorPrefix = "";

        if (data != null) {
          var responseJson = json.decode(data.body);

          if (data.statusCode == 400) {
            responseJson['error'].forEach((k, v) {
              if (k == "prefix") {
                _errorPrefix = v[0];
              }
            });
          } else {
            CommonFunctions.showSuccessSnackbar("Settings Saved.");
            final provider = Provider.of<ProfileProvider>(
              context,
              listen: false,
            );
            provider.getProfile(context).then((value) {});
          }
        } else {}
        notifyListeners();
        Navigator.pop(context);
      },
    );
  }
}
