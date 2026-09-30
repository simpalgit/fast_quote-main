import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Invoice/InvoiceList/invoice_list_model.dart';
import 'package:fast_quote/Screens/Invoice/invoice_repository.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/cupertino.dart';

class CreateInvoiceProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  InvoiceRepository invoiceRepository = InvoiceRepository();
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

  String _invoiceNum = "";
  String get invoiceNum => _invoiceNum;

  initData() {
    _isLoading = true;
    _enquiryLength = 0;
    _invoiceLength = 0;
    _quotationLength = 0;
    _challanLength = 0;
    _invoiceNum = "";
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

  Future<void> getInvoiceSettingsData(BuildContext context) async {
    var storedModel = await CommonFunctions().getStoredProfileData();

    var result = await settingsRepository.getInvoiceSettingsData(
        context, storedModel.id!);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      _invoiceNum = "${data.prefix} ${_invoiceLength.toString()}";
      _quoteInvSettingModel = data;
      isLoadingFun(false);
    });
  }

  Future<void> uploadInvoice(BuildContext context, String jsonData,
      dynamic file, String status, String id) async {
    isLoadingFun(true);

    FormData formData = FormData.fromMap({
      "enquiry_id": id,
      "data": jsonData,
      "is_template": 0,
      "invoice_reciept": await MultipartFile.fromFile(
        file.path,
      ),
      "status": status
    });

    var result = await invoiceRepository.addInvoice(context, formData);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
    }, (data) {
      if (data != null) {
        if (data.statusCode == 400) {
          var response = data.data["response"];
          if (response == false) {
            CommonFunctions.showErrorSnackbar(context,
                "Invoice is already generated against this Quotation,");
          }

          isLoadingFun(false);
        } else {
          CommonFunctions.showSuccessSnackbar("Invoice Saved.");
          var resp = data.data;

          InvoiceListModel modelData = InvoiceListModel.fromJson(resp['data']);
          isLoadingFun(false);

          redirect(file, context, jsonData, modelData);
        }
      }
      notifyListeners();
    });
  }

  void redirect(final pdfFile, BuildContext context, String invoiceData,
      InvoiceListModel invoiceListModel) {
    Navigator.of(context)
      ..pop()
      ..pushNamed(RouteNames.invoicePFDViewerPage, arguments: {
        "file": pdfFile,
        "invoiceData": invoiceData,
        "isSavedAsTemplate": false,
        "invoiceListModel": invoiceListModel
      });
  }
}
