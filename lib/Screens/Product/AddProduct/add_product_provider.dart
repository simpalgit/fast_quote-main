import 'dart:convert';

import 'package:fast_quote/Screens/Product/product_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:flutter/material.dart';

class AddProductProvider with ChangeNotifier {
  ProductRepository productRepository = ProductRepository();
  final TextEditingController _ctlProductName = TextEditingController();
  TextEditingController get ctlProductName => _ctlProductName;

  final TextEditingController _ctlPrice = TextEditingController();
  TextEditingController get ctlPrice => _ctlPrice;

  final TextEditingController _ctlUnit = TextEditingController();
  TextEditingController get ctlUnit => _ctlUnit;

  final TextEditingController _ctlGST = TextEditingController();
  TextEditingController get ctlGST => _ctlGST;

  final TextEditingController _ctlDescription = TextEditingController();
  TextEditingController get ctlDescription => _ctlDescription;

  final TextEditingController _ctlHSN = TextEditingController();
  TextEditingController get ctlHSN => _ctlHSN;

  String _taxHintValue = "";
  String get taxHintValue => _taxHintValue;

  String _productHSNValue = "";
  String get productHSNValue => _productHSNValue;

  void initData() async {
    _taxHintValue = await LocalPreferences().getTaxLabel() ?? "";
    _productHSNValue = await LocalPreferences().getProductHSNLabel() ?? "";
    _ctlProductName.clear();
    _ctlPrice.clear();
    _ctlUnit.clear();
    _ctlGST.clear();
    _ctlDescription.clear();
    _ctlHSN.clear();
    _errorProductName = "";
    _errorPrice = "";
    _errorUnit = "";

    notifyListeners();
  }

  String _errorProductName = "", _errorPrice = "", _errorUnit = "";
  String get errorProductName => _errorProductName;
  String get errorPrice => _errorPrice;
  String get errorUnit => _errorUnit;

  addProduct(BuildContext context) async {
    CommonFunctions.showProgressBar(context);
    var storedModel = await CommonFunctions().getStoredProfileData();
    var passedData = json.encode({
      "name": _ctlProductName.text.trim(),
      "price": _ctlPrice.text.trim(),
      "unit": _ctlUnit.text.trim(),
      "gst": _ctlGST.text.trim(),
      "description": _ctlDescription.text.trim(),
      "hsn_number": _ctlHSN.text.trim(),
      "user_id": storedModel.id,
    });
    var result = await productRepository.addProduct(context, passedData);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      Navigator.pop(context);
    }, (data) {
      _errorProductName = "";
      _errorPrice = "";
      _errorUnit = "";

      if (data != null) {
        var responseJson = json.decode(data.body);

        if (data.statusCode == 400) {
          responseJson['error'].forEach((k, v) {
            if (k == "name") {
              _errorProductName = v[0];
            }
            if (k == "price") {
              _errorPrice = v[0];
            }
            if (k == "unit") {
              _errorUnit = v[0];
            }
          });
        } else {
          Navigator.pop(context);
          CommonFunctions.showSuccessSnackbar("Product Added.");
        }
      }
      notifyListeners();
      Navigator.pop(context);
    });
  }
}
