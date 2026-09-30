import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Enquiry/enquiry_repository.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/material.dart';

import '../EnquiryList/enquiry_list_model.dart';

class UpdateEnquiryProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  EnquiryRepository enquiryRepository = EnquiryRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  BusinessModel businessModel = BusinessModel();

  Future<void> getManageBusinessData(BuildContext context) async {
    isLoadingFun(true);
    var storedModel = await CommonFunctions().getStoredProfileData();
    var result =
        await settingsRepository.getBusinessData(context, storedModel.id!);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      businessModel = data;
      isLoadingFun(false);
    });
  }

  Future<void> updateEnquiry(
      BuildContext context, String jsonData, dynamic file, String id) async {
    isLoadingFun(true);

    FormData formData = FormData.fromMap({
      "data": jsonData,
      "is_template": 0,
      "invoice_reciept": await MultipartFile.fromFile(
        file.path,
      ),
    });

    Either<Failure, dynamic> result;

    result = await enquiryRepository.updateEnquiry(context, formData, id);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      if (data != null) {
        CommonFunctions.showSuccessSnackbar("Enquiry Updated.");
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
      ..pop()
      ..pushNamed(RouteNames.enquiryView, arguments: {
        "file": pdfFile,
        "enquiryData": enquiryData,
        "enquiryListModel": enquiryListModel
      });
  }
}
