import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Quotation/QuotationList/quotation_list_model.dart';
import 'package:fast_quote/Screens/Quotation/quotation_repository.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/cupertino.dart';

class CreateQuotationProvider with ChangeNotifier {
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

  BusinessModel _businessModel = BusinessModel();
  BusinessModel get businessModel => _businessModel;
  QuoteInvSettingModel _quoteInvSettingModel = QuoteInvSettingModel();
  QuoteInvSettingModel get quoteInvSettingModel => _quoteInvSettingModel;

  Future<void> getManageBusinessData(BuildContext context) async {
    isLoadingFun(true);

    var storedModel = await CommonFunctions().getStoredProfileData();
    var result =
        await settingsRepository.getBusinessData(context, storedModel.id!);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      _businessModel = data;
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
      _quoteInvSettingModel = data;
      isLoadingFun(false);
    });
  }

  Future<void> uploadQuotation(
      BuildContext context, String jsonData, dynamic file, String enqId) async {
    isLoadingFun(true);

    FormData formData = FormData.fromMap({
      "enquiry_id": enqId,
      "data": jsonData,
      "is_template": 0,
      "invoice_reciept": await MultipartFile.fromFile(
        file.path,
      ),
    });

    var result = await quotationRepository.addQuotation(context, formData);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      if (data != null) {
        if (data.statusCode == 400) {
          var response = data.data["response"];
          if (response == false) {
            CommonFunctions.showErrorSnackbar(context,
                "Quotation is already generated against this Enquiry,");
          }

          isLoadingFun(false);
        } else {
          CommonFunctions.showSuccessSnackbar("Quotation Saved.");
          var resp = data.data;

          QuotationListModel modelData =
              QuotationListModel.fromJson(resp['data']);
          isLoadingFun(false);

          redirect(file, context, jsonData, modelData);
        }
      }
      notifyListeners();
    });
  }

  void redirect(final pdfFile, BuildContext context, String enquiryData,
      QuotationListModel enquiryListModel) {
    Navigator.of(context)
      ..pop()
      ..pushNamed(RouteNames.quotationPFDViewerPage, arguments: {
        "file": pdfFile,
        "quotationData": enquiryData,
        "isSavedAsTemplate": false,
        "quotationListModel": enquiryListModel
      });
  }
}
