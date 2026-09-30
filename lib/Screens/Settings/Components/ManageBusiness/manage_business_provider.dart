import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Customer/customer_repository.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ManageBusinessProvider with ChangeNotifier {
  BaseApiService apiService = NetworkAPIService();
  CustomerRepository customerRepository = CustomerRepository();
  SettingsRepository settingsRepository = SettingsRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final TextEditingController _ctlBusinessName = TextEditingController();
  TextEditingController get ctlBusinessName => _ctlBusinessName;

  final TextEditingController _ctlContactName = TextEditingController();
  TextEditingController get ctlContactName => _ctlContactName;

  final TextEditingController _ctlEmail = TextEditingController();
  TextEditingController get ctlEmail => _ctlEmail;

  final TextEditingController _ctlMobile = TextEditingController();
  TextEditingController get ctlMobile => _ctlMobile;

  final TextEditingController _ctlAddressOne = TextEditingController();
  TextEditingController get ctlAddressOne => _ctlAddressOne;

  final TextEditingController _ctlAddressTwo = TextEditingController();
  TextEditingController get ctlAddressTwo => _ctlAddressTwo;

  final TextEditingController _ctlAddressThree = TextEditingController();
  TextEditingController get ctlAddressThree => _ctlAddressThree;

  final TextEditingController _ctlOtherInfo = TextEditingController();
  TextEditingController get ctlOtherInfo => _ctlOtherInfo;

  final TextEditingController _ctlStateName = TextEditingController();
  TextEditingController get ctlStateName => _ctlStateName;

  final TextEditingController _ctlBusinessLabel = TextEditingController();
  TextEditingController get ctlBusinessLabel => _ctlBusinessLabel;

  final TextEditingController _ctlBusinessNumber = TextEditingController();
  TextEditingController get ctlBusinessNumber => _ctlBusinessNumber;

  final TextEditingController _ctlBusinessCategory = TextEditingController();
  TextEditingController get ctlBusinessCategory => _ctlBusinessCategory;

  final TextEditingController _ctlBankDetail = TextEditingController();
  TextEditingController get ctlBankDetail => _ctlBankDetail;

  List<StateModel> _stateList = [];
  List<StateModel> get stateList => _stateList;

  String _errorBusinessName = "";
  String get errorBusinessName => _errorBusinessName;

  String _errorContactName = "";
  String get errorContactName => _errorContactName;

  String _errorEmail = "";
  String get errorEmail => _errorEmail;

  String _errorPhone = "";
  String get errorPhone => _errorPhone;

  String _errorState = "";
  String get errorState => _errorState;

  String _stateId = "";
  String get stateId => _stateId;

  String _errorSignature = "";
  String get errorSignature => _errorSignature;
  String _errorLogo = "";
  String get errorLogo => _errorLogo;

  isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  String _id = "";
  String get id => _id;

  String _businessLogo = "";
  String get businessLogo => _businessLogo;

  String _businessSignature = "";
  String get businessSignature => _businessSignature;

  void initData() {
    _isLoading = true;
    _stateList.clear();
    _ctlBusinessName.clear();
    _ctlContactName.clear();
    _ctlStateName.clear();
    _ctlEmail.clear();
    _ctlMobile.clear();
    _ctlAddressOne.clear();
    _ctlAddressTwo.clear();
    _ctlAddressThree.clear();
    _ctlOtherInfo.clear();
    _ctlBusinessLabel.clear();
    _ctlBusinessNumber.clear();
    _ctlBusinessCategory.clear();
    _ctlBankDetail.clear();
    _errorBusinessName = "";
    _errorState = "";
    _errorContactName = "";
    _errorEmail = "";
    _errorPhone = "";
    _stateId = "";
    _errorSignature = "";
    _errorLogo = "";
    _id = "";
    _businessLogo = "";
    _businessSignature = "";
  }

  Future getStates(BuildContext context) async {
    isLoadingFun(true);
    initData();
    CommonFunctions.showProgressBar(context);

    var result = await customerRepository.getStateList(context);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }, (data) {
      _stateList = data;
      getManageBusinessData(context);
    });
  }

  String getStateNameById(String id) {
    if (id.isNotEmpty) {
      var model =
          _stateList.firstWhere((element) => element.id.toString() == id);
      return model.name;
    } else {
      return "";
    }
  }

  stateOnClick(StateModel model, BuildContext context) {
    ctlStateName.clear();
    _stateId = model.id.toString();
    _ctlStateName.text = model.name;

    if (context.mounted) {
      Navigator.pop(context);
    }
    notifyListeners();
  }

  Future<void> getManageBusinessData(BuildContext context) async {
    var storedModel = await CommonFunctions().getStoredProfileData();
    var result =
        await settingsRepository.getBusinessData(context, storedModel.id!);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }, (data) {
      if (data.id != null) {
        _id = data.id!;
      } else {
        _id = "";
      }

      _ctlBusinessName.text = data.name ?? "";
      _ctlContactName.text = data.contact ?? "";
      _ctlEmail.text = data.email ?? '';
      _ctlMobile.text = data.phone ?? '';
      _ctlAddressOne.text = data.addressOne ?? '';
      _ctlAddressTwo.text = data.addressTwo ?? '';
      _ctlAddressThree.text = data.addressThree ?? '';
      _ctlOtherInfo.text = data.otherInfo ?? '';
      _ctlBusinessLabel.text = data.label ?? '';
      _ctlBusinessNumber.text = data.businessNo ?? '';
      _stateId = data.stateId ?? '';
      _ctlStateName.text = getStateNameById(data.stateId ?? '');
      _ctlBankDetail.text = data.bankDetails ?? '';
      _businessLogo = data.logo ?? '';
      _businessSignature = data.signature ?? '';

      // evictImage(businessLogo, "businessLogo");
      // evictImage(businessSignature, "businessSignature");

      isLoadingFun(false);
      if (context.mounted) {
        Navigator.pop(context);
      }
    });
  }

  // void evictImage(String url, String key) async {
  //   await CachedNetworkImage.evictFromCache(url);

  //   // DefaultCacheManager().removeFile(
  //   //   url,
  //   // );
  // }

  Future<void> uploadBusinessData(
    BuildContext context,
    CroppedFile? businessLogo,
    dynamic businessSignature,
  ) async {
    CommonFunctions.showProgressBar(context);
    FormData formData;
    if (businessLogo == null && businessSignature == null) {
      formData = FormData.fromMap({
        "name": _ctlBusinessName.text,
        "contact": _ctlContactName.text,
        "email": _ctlEmail.text,
        "phone": _ctlMobile.text,
        "address_one": _ctlAddressOne.text,
        "address_two": _ctlAddressTwo.text,
        "address_three": _ctlAddressThree.text,
        "other_info": _ctlOtherInfo.text,
        "label": _ctlBusinessLabel.text,
        "business_no": _ctlBusinessNumber.text,
        "state_id": _stateId,
        "bank_details": _ctlBankDetail.text
      });
    } else if (businessLogo != null && businessSignature == null) {
      formData = FormData.fromMap({
        "name": _ctlBusinessName.text,
        "contact": _ctlContactName.text,
        "email": _ctlEmail.text,
        "phone": _ctlMobile.text,
        "address_one": _ctlAddressOne.text,
        "address_two": _ctlAddressTwo.text,
        "address_three": _ctlAddressThree.text,
        "other_info": _ctlOtherInfo.text,
        "label": _ctlBusinessLabel.text,
        "business_no": _ctlBusinessNumber.text,
        "state_id": _stateId,
        "bank_details": _ctlBankDetail.text,
        "business_logo": await MultipartFile.fromFile(
          businessLogo.path,
        ),
      });
    } else if (businessLogo == null && businessSignature != null) {
      formData = FormData.fromMap({
        "name": _ctlBusinessName.text,
        "contact": _ctlContactName.text,
        "email": _ctlEmail.text,
        "phone": _ctlMobile.text,
        "address_one": _ctlAddressOne.text,
        "address_two": _ctlAddressTwo.text,
        "address_three": _ctlAddressThree.text,
        "other_info": _ctlOtherInfo.text,
        "label": _ctlBusinessLabel.text,
        "business_no": _ctlBusinessNumber.text,
        "state_id": _stateId,
        "bank_details": _ctlBankDetail.text,
        "business_signature": await MultipartFile.fromFile(
          businessSignature.path,
        ),
      });
    } else {
      formData = FormData.fromMap({
        "name": _ctlBusinessName.text.trim(),
        "contact": _ctlContactName.text.trim(),
        "email": _ctlEmail.text.trim(),
        "phone": _ctlMobile.text.trim(),
        "address_one": _ctlAddressOne.text.trim(),
        "address_two": _ctlAddressTwo.text.trim(),
        "address_three": _ctlAddressThree.text.trim(),
        "other_info": _ctlOtherInfo.text.trim(),
        "label": _ctlBusinessLabel.text.trim(),
        "business_no": _ctlBusinessNumber.text.trim(),
        "state_id": _stateId,
        "bank_details": _ctlBankDetail.text.trim(),
        "business_signature": await MultipartFile.fromFile(
          businessSignature!.path,
        ),
        "business_logo": await MultipartFile.fromFile(
          businessLogo!.path,
        ),
      });
    }

    Either<Failure, dynamic> result;
    if (_id == "") {
      result = await settingsRepository.postBusiness(context, formData);
    } else {
      result = await settingsRepository.putBusiness(context, formData, _id);
    }

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }, (data) {
      _errorBusinessName = "";
      _errorContactName = "";
      _errorEmail = "";
      _errorPhone = "";
      _stateId = "";
      _errorSignature = "";
      _errorLogo = "";

      if (data != null) {
        if (data.statusCode == 400) {
          data.data['error'].forEach((k, v) {
            if (k == "name") {
              _errorBusinessName = v[0];
            }
            if (k == "contact") {
              _errorContactName = v[0];
            }
            if (k == "email") {
              _errorEmail = v[0];
            }
            if (k == "phone") {
              _errorPhone = v[0];
            }
            if (k == "state_id") {
              _errorState = v[0];
            }
            if (k == "business_signature") {
              _errorSignature = v[0];
            }
            if (k == "business_logo") {
              _errorLogo = v[0];
            }
          });
          if (context.mounted) {
            Navigator.pop(context);
          }
        } else {
          CommonFunctions.showSuccessSnackbar("Business Saved.");

          getProfile(context).then((value) {
            isLoadingFun(false);
            Navigator.of(context)
              ..pop()
              ..pop();
          });
        }
      }
      notifyListeners();
    });
  }

  // Future<void> uploadBusinessData(
  //   BuildContext context,
  //   dynamic businessLogo,
  //   dynamic businessSignature,
  // ) async {
  //   CommonFunctions.showProgressBar(context);
  //   try {
  //     String storedToken = await LocalPreferences().getAuthToken() ?? "";
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(
  //           "https://showcase.webvisionsoftech.in/fastquote/api/business/$_id"),
  //     );

  //     request.fields['name'] = _ctlBusinessName.text.trim();
  //     request.fields['contact'] = _ctlContactName.text.trim();
  //     request.fields['email'] = _ctlEmail.text.trim();
  //     request.fields['phone'] = _ctlMobile.text.trim();
  //     request.fields['address_one'] = _ctlAddressOne.text.trim();
  //     request.fields['address_two'] = _ctlAddressTwo.text.trim();
  //     request.fields['address_three'] = _ctlAddressThree.text.trim();
  //     request.fields['other_info'] = _ctlOtherInfo.text.trim();
  //     request.fields['label'] = _ctlBusinessLabel.text.trim();
  //     request.fields['business_no'] = _ctlBusinessNumber.text.trim();
  //     request.fields['state_id'] = _stateId;
  //     request.fields['bank_details'] = _ctlBankDetail.text.trim();

  //     if (businessLogo != null) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //           'business_logo', businessLogo!.path));
  //     }
  //     if (businessSignature != null) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //           'business_signature', businessSignature.path));
  //     }

  //     request.headers['Authorization'] = "Bearer $storedToken";
  //     request.headers['Content-Type'] = 'application/json';
  //     request.headers['Accept'] = 'application/json';

  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //        CommonFunctions.showSuccessSnackbar( "Business Saved.");

  //       getProfile(context).then((value) {
  //         isLoadingFun(false);
  //         Navigator.of(context)
  //           ..pop()
  //           ..pop();
  //       });
  //     } else if (response.statusCode == 400) {
  //       var responseData = await response.stream.toBytes();
  //       var responseString = String.fromCharCodes(responseData);
  //       var data = jsonDecode(responseString);
  //       data.data['error'].forEach((k, v) {
  //         if (k == "name") {
  //           _errorBusinessName = v[0];
  //         }
  //         if (k == "contact") {
  //           _errorContactName = v[0];
  //         }
  //         if (k == "email") {
  //           _errorEmail = v[0];
  //         }
  //         if (k == "phone") {
  //           _errorPhone = v[0];
  //         }
  //         if (k == "state_id") {
  //           _errorState = v[0];
  //         }
  //         if (k == "business_signature") {
  //           _errorSignature = v[0];
  //         }
  //         if (k == "business_logo") {
  //           _errorLogo = v[0];
  //         }
  //       });
  //       if (context.mounted) {
  //         Navigator.pop(context);
  //       }
  //     } else {
  //       print('Image upload failed with status ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     log(error.toString());
  //   }
  // }

  Future getProfile(BuildContext context) async {
    var result = await settingsRepository.getProfileData(context);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) {
      String profileData = jsonEncode(data.profile!);

      LocalPreferences().setProfileData(profileData);
      LocalPreferences().setBusinessFill(data.business!);
      LocalPreferences().setQuotationFill(data.quatation!);
      LocalPreferences().setInvoiceFill(data.invoice!);
    });
  }
}
