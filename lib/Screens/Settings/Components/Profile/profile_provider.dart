import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Settings/Components/Profile/profile_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/main.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:nb_utils/nb_utils.dart' as NavigationService;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  final TextEditingController _ctlUserName = TextEditingController();
  TextEditingController get ctlUserName => _ctlUserName;

  final TextEditingController _ctlEmail = TextEditingController();
  TextEditingController get ctlEmail => _ctlEmail;

  final TextEditingController _ctlMobile = TextEditingController();
  TextEditingController get ctlMobile => _ctlMobile;

  final PDFInitiallizationNumber _pdfInitiallizationNumber =
      PDFInitiallizationNumber();

  PDFInitiallizationNumber get pDFInitiallizationNumber =>
      _pdfInitiallizationNumber;

  bool _isBtnLoading = false;
  bool get isBtnLoading => _isBtnLoading;

  void btnLoading(bool val) {
    _isBtnLoading = val;
    notifyListeners();
  }

  bool _isHomeLoading = true;
  bool get isHomeLoading => _isHomeLoading;

  void homeLoading(bool val) {
    _isHomeLoading = val;
    notifyListeners();
  }

  String _userName = "";
  String get userName => _userName;

  String _errorMobileText = "";
  String get errorMobileText => _errorMobileText;
  String _errorEmailText = "";
  String get errorEmailText => _errorEmailText;

  String _profileImage = "";
  String get profileImage => _profileImage;

  String _errorNameText = "";
  String get errorNameText => _errorNameText;

  ProfileModel profileModel = ProfileModel();
  ProfileModel _storedModel = ProfileModel();
  ProfileModel get storedModel => _storedModel;

  bool _status = true;
  bool get status => _status;

  void initData() {
    _errorMobileText = "";
    _errorNameText = "";
    _errorEmailText = "";
    _isBtnLoading = false;
    _isBusinessFill = true;
    _isQuotationFill = true;
    _isInvoiceFill = true;
    _status = true;
    _enquiryLength = 0;
    _invoiceLength = 0;
    _quotationLength = 0;
    _ctlUserName.clear();
    _ctlEmail.clear();
    _ctlMobile.clear();
  }

  getProfileStoredData() async {
    initData();
    _storedModel = await CommonFunctions().getStoredProfileData();
    _userName = _storedModel.name!;

    _ctlUserName.text = _storedModel.name!;
    _ctlEmail.text = _storedModel.email!;
    _ctlMobile.text = _storedModel.phone!;
    _profileImage = _storedModel.image!;

    notifyListeners();
  }

  bool _isBusinessFill = true;
  bool get isBusinessFill => _isBusinessFill;

  bool _isQuotationFill = true;
  bool get isQuotationFill => _isQuotationFill;

  bool _isInvoiceFill = true;
  bool get isInvoiceFill => _isInvoiceFill;

  int _enquiryLength = 0, _invoiceLength = 0, _quotationLength = 0;
  int get enquiryLength => _enquiryLength;
  int get invoiceLength => _invoiceLength;
  int get quotationLength => _quotationLength;

  Future getProfile(BuildContext context) async {
    CommonFunctions.showProgressBar(context);
    var result = await settingsRepository.getProfileData(context);

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
        Navigator.pop(context);
      },
      (data) {
        profileModel = data.profile!;

        _userName = profileModel.name!;
        _profileImage = profileModel.image!;

        _status = profileModel.subscription!.status!;

        String profileData = jsonEncode(data.profile!);

        LocalPreferences().setProfileData(profileData);
        LocalPreferences().setBusinessFill(data.business!);
        LocalPreferences().setQuotationFill(data.quatation!);
        LocalPreferences().setInvoiceFill(data.invoice!);
        LocalPreferences().setSubscriptionId(
          profileModel.subscription!.subId ?? 1,
        );

        _isBusinessFill = data.business!;
        _isQuotationFill = data.quatation!;
        _isInvoiceFill = data.invoice!;
        Navigator.pop(context);
      },
    );
  }

  Future getHomeData(BuildContext context) async {
    homeLoading(true);
    var result = await settingsRepository.getHomeData(context);

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
        homeLoading(false);
        Navigator.pop(context);
      },
      (data) {
        _enquiryLength = data.enquiryLength!;
        _invoiceLength = data.invoiceLength!;
        _quotationLength = data.quotationLength!;

        _showToastOncePerDay();

        homeLoading(false);
      },
    );
  }

  _showToastOncePerDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day}';

    String? lastDate = prefs.getString('lastDate');

    if (lastDate != formattedDate) {
      if (!profileModel.subscription!.status!) {
        int remainingDays = CommonFunctions().calculateRemainingDays(
          DateTime.now(),
          profileModel.subscription!.endDate!,
        );
        if (remainingDays <= 7) {
          ScaffoldMessenger.of(
            NavigationService.navigatorKey.currentContext!,
          ).showSnackBar(
            CommonFunctions.warningSnackBar(
              remainingDays: remainingDays.toString(),
            ),
          );
        }
        _status = profileModel.subscription!.status!;
      } else {
        ScaffoldMessenger.of(
          NavigationService.navigatorKey.currentContext!,
        ).showSnackBar(CommonFunctions.errorSnackBar());

        _status = profileModel.subscription!.status!;
      }

      prefs.setString('lastDate', formattedDate);
    } else {
      _status = profileModel.subscription!.status!;
    }
  }

  updateProfile(BuildContext context) async {
    btnLoading(true);
    CommonFunctions.hideKeyboard(context);
    FormData formData = FormData.fromMap({
      "phone": _ctlMobile.text.trim(),
      "name": _ctlUserName.text.trim(),
      "email": _ctlEmail.text.trim(),
      "type": "User",
    });

    var result = await settingsRepository.updateProfile(context, formData);

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
      },
      (data) {
        if (data.statusCode == 400) {
          data.data.forEach((k, v) {
            if (k == "phone") {
              _errorMobileText = v[0];
            }
            if (k == "name") {
              _errorNameText = v[0];
            }
            if (k == "email") {
              _errorEmailText = v[0];
            }
          });
          btnLoading(false);
        } else {
          btnLoading(false);
          CommonFunctions.showSuccessSnackbar("Profile Updated successfully..");
        }

        getProfile(context);
      },
    );
  }

  Future updateProfileImage(
    BuildContext context,
    CroppedFile? profileImage,
  ) async {
    btnLoading(true);

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(profileImage!.path),
    });

    var result = await settingsRepository.updateProfileImage(context, formData);

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
        btnLoading(false);
      },
      (data) {
        if (data.statusCode == 400) {
          data.data.forEach((k, v) {
            if (k == "image") {
              // _errorMobileText = v[0];
            }
          });
          btnLoading(false);
        } else {
          CommonFunctions.showSuccessSnackbar(
            "Profile Image Updateded successfully..",
          );
        }

        getProfile(context).then((value) {
          btnLoading(false);
        });
      },
    );
  }
}
