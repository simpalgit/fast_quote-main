import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Quotation/QuotationList/quotation_list_model.dart';
import 'package:fast_quote/Screens/Quotation/quotation_repository.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/material.dart';

class UpdateQuotationProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  QuotationRepository quotationRepository = QuotationRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  int _enquiryLength = 0,
      _invoiceLength = 0,
      _quotationLength = 0,
      _challanLength = 0;
  int get enquiryLength => _enquiryLength;
  int get invoiceLength => _invoiceLength;
  int get quotationLength => _quotationLength;
  int get challanLength => _challanLength;

  String _quoteNum = "";
  String get quoteNum => _quoteNum;

  initData() {
    _isLoading = true;
    _enquiryLength = 0;
    _invoiceLength = 0;
    _quotationLength = 0;
    _challanLength = 0;
    _quoteNum = "";
  }

  BusinessModel businessModel = BusinessModel();
  QuoteInvSettingModel quoteInvSettingModel = QuoteInvSettingModel();
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
    });
  }

  Future getHomeData(BuildContext context) async {
    var result = await settingsRepository.getHomeData(context);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      _enquiryLength = data.enquiryNumber!;
      _invoiceLength = data.invoiceNumber!;
      _quotationLength = data.quotationNumber!;
      _challanLength = data.challanNumber!;
    });
  }

  Future<void> getQuotationSettingsData(BuildContext context) async {
    var storedModel = await CommonFunctions().getStoredProfileData();

    var result =
        await settingsRepository.getQuoteSettingsData(context, storedModel.id!);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      _quoteNum = "${data.prefix} ${_quotationLength.toString()}";
      quoteInvSettingModel = data;
      isLoadingFun(false);
    });
  }

  Future<void> updateQuotation(
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

    result = await quotationRepository.updateQuotation(context, formData, id);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      if (data != null) {
        CommonFunctions.showSuccessSnackbar("Quotation Updated.");
        var resp = data.data;

        QuotationListModel modelData =
            QuotationListModel.fromJson(resp['data']);
        isLoadingFun(false);

        redirect(file, context, jsonData, modelData);
      }
      notifyListeners();
    });
  }

  void redirect(final pdfFile, BuildContext context, String enquiryData,
      QuotationListModel enquiryListModel) {
    Navigator.of(context)
      ..pop()
      ..pop()
      ..pushNamed(RouteNames.quotationViewPage, arguments: {
        "file": pdfFile,
        "quotationData": enquiryData,
        "isSavedAsTemplate": false,
        "quotationListModel": enquiryListModel
      });
  }
}
