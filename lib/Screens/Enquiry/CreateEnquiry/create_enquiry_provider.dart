import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Enquiry/EnquiryList/enquiry_list_model.dart';
import 'package:fast_quote/Screens/Enquiry/enquiry_repository.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/material.dart';

class CreateEnquiryProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  EnquiryRepository enquiryRepository = EnquiryRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  int _enquiryNum = 0;
  int get enquiryNum => _enquiryNum;

  String _enqNum = "";
  String get enqNum => _enqNum;

  initData() {
    _isLoading = true;
    _enquiryNum = 0;

    _enqNum = "";
  }

  BusinessModel businessModel = BusinessModel();

  Future<void> getManageBusinessData(BuildContext context) async {
    initData();
    isLoadingFun(true);
    var storedModel = await CommonFunctions().getStoredProfileData();
    var result =
        await settingsRepository.getBusinessData(context, storedModel.id!);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      businessModel = data;
    });
  }

  Future getHomeData(BuildContext context) async {
    var result = await settingsRepository.getHomeData(context);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      _enquiryNum = data.enquiryNumber!;

      _enqNum = "Enq-${_enquiryNum.toString()}";

      isLoadingFun(false);
    });
  }

  Future<void> uploadEnquiry(
      BuildContext context, String jsonData, dynamic file) async {
    isLoadingFun(true);
    FormData formData = FormData.fromMap({
      "data": jsonData,
      "is_template": 0,
      "invoice_reciept": await MultipartFile.fromFile(
        file.path,
      ),
    });

    var result = await enquiryRepository.addEnquiry(context, formData);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      if (data != null) {
        CommonFunctions.showSuccessSnackbar("Enquiry Saved.");
        var resp = data.data;

        EnquiryListModel modelData = EnquiryListModel.fromJson(resp['data']);
        isLoadingFun(false);

        redirect(file, context, jsonData, modelData);
      }
      notifyListeners();
    });
  }

  void redirect(final pdfFile, BuildContext context, String enquiryData,
      EnquiryListModel enquiryListModel) {
    Navigator.of(context)
      ..pop()
      ..pushNamed(RouteNames.enquiryPFDViewerPage, arguments: {
        "file": pdfFile,
        "enquiryData": enquiryData,
        "enquiryListModel": enquiryListModel
      });
  }
}
