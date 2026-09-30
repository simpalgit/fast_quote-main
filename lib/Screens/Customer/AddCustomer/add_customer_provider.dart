import 'dart:convert';

import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Customer/customer_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:flutter/material.dart';

class AddCustomerProvider with ChangeNotifier {
  CustomerRepository customerRepository = CustomerRepository();
  final TextEditingController _ctlCustomer = TextEditingController();
  TextEditingController get ctlCustomer => _ctlCustomer;

  final TextEditingController _ctlCompanyName = TextEditingController();
  TextEditingController get ctlCompanyName => _ctlCompanyName;

  final TextEditingController _ctlEmail = TextEditingController();
  TextEditingController get ctlEmail => _ctlEmail;

  final TextEditingController _ctlMobile = TextEditingController();
  TextEditingController get ctlMobile => _ctlMobile;

  final TextEditingController _ctlAddressOne = TextEditingController();
  TextEditingController get ctlAddressOne => _ctlAddressOne;

  final TextEditingController _ctlAddressTwo = TextEditingController();
  TextEditingController get ctlAddressTwo => _ctlAddressTwo;

  final TextEditingController _ctlOtherInfo = TextEditingController();
  TextEditingController get ctlOtherInfo => _ctlOtherInfo;

  final TextEditingController _ctlGstInNumber = TextEditingController();
  TextEditingController get ctlGstInNumber => _ctlGstInNumber;

  final TextEditingController _ctlState = TextEditingController();
  TextEditingController get ctlState => _ctlState;

  final TextEditingController _ctlShippingAddress = TextEditingController();
  TextEditingController get ctlShippingAddress => _ctlShippingAddress;

  final TextEditingController _ctlStateName = TextEditingController();
  TextEditingController get ctlStateName => _ctlStateName;

  List<StateModel> _stateList = [];
  List<StateModel> get stateList => _stateList;

  String _stateId = "";
  String get stateId => _stateId;

  String _errorCustomerName = "",
      _errorCompanyName = "",
      _errorMobile = "",
      _errorAddOne = "",
      _errorState = "";
  String get errorCustomerName => _errorCustomerName;
  String get errorCompanyName => _errorCompanyName;
  String get errorMobile => _errorMobile;
  String get errorAddOne => _errorAddOne;
  String get errorState => _errorState;

  void initData() {
    _ctlCustomer.clear();
    _ctlCompanyName.clear();
    _ctlEmail.clear();
    _ctlMobile.clear();
    _ctlAddressOne.clear();
    _ctlGstInNumber.clear();
    _ctlAddressTwo.clear();
    _ctlOtherInfo.clear();
    _ctlState.clear();
    ctlStateName.clear();
    _ctlShippingAddress.clear();
    _stateId = "";
    _stateList.clear();
    _errorCustomerName = "";
    _errorCompanyName = "";
    _errorMobile = "";
    _errorAddOne = "";
    _errorState = "";
  }

  getStates(BuildContext context) async {
    CommonFunctions.showProgressBar(context);
    initData();

    var result = await customerRepository.getStateList(context);

    result.fold(
      (error) {
        Navigator.pop(context);
      },
      (data) {
        Navigator.pop(context);
        _stateList = data;

        var maharashtraModel = _stateList.firstWhere(
          (element) => element.id == 20,
        );

        _stateId = maharashtraModel.id.toString();
        _ctlState.text = maharashtraModel.name;
        ctlStateName.clear();
        notifyListeners();
      },
    );
  }

  stateOnClick(StateModel model, BuildContext context) {
    _stateId = model.id.toString();
    _ctlState.text = model.name;
    _ctlStateName.clear();

    Navigator.pop(context);
    notifyListeners();
  }

  addCustomer(BuildContext context) async {
    CommonFunctions.showProgressBar(context);
    var passedData = json.encode({
      "name": _ctlCustomer.text.trim(),
      "company": _ctlCompanyName.text.trim(),
      "mobile": _ctlMobile.text.trim(),
      "address_one": _ctlAddressOne.text.trim(),
      "address_two": _ctlAddressTwo.text.trim(),
      "state_id": stateId,
      "email": _ctlEmail.text.trim(),
      "other_info": _ctlOtherInfo.text.trim(),
      "gstin": _ctlGstInNumber.text.trim(),
      "shipping_address": _ctlShippingAddress.text.trim(),
    });
    var result = await customerRepository.addCustomer(context, passedData);

    result.fold(
      (error) {
        Navigator.pop(context);
        CommonFunctions.showErrorSnackbar(context, error.message);
      },
      (data) {
        _errorCustomerName = "";
        _errorCompanyName = "";
        _errorMobile = "";
        _errorAddOne = "";
        _errorState = "";
        if (data != null) {
          var responseJson = json.decode(data.body);

          if (data.statusCode == 400) {
            responseJson['error'].forEach((k, v) {
              if (k == "name") {
                _errorCustomerName = v[0];
              }
              if (k == "company") {
                _errorCompanyName = v[0];
              }
              if (k == "mobile") {
                _errorMobile = v[0];
              }

              if (k == "address_one") {
                _errorAddOne = v[0];
              }
              if (k == "state_id") {
                _errorState = v[0];
              }
            });
          } else {
            Navigator.pop(context);
            CommonFunctions.showSuccessSnackbar("Customer Added.");
          }
        }
        notifyListeners();
        Navigator.pop(context);
      },
    );
  }
}
