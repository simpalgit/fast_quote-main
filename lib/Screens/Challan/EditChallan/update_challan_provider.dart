import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Auth/other_charges_model.dart';
import 'package:fast_quote/Screens/Challan/ChallanList/challan_list_model.dart';
import 'package:fast_quote/Screens/Challan/challan_pdf.dart';
import 'package:fast_quote/Screens/Challan/challan_repository.dart';
import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Enquiry/CreateEnquiry/enquiry_model.dart';
import 'package:fast_quote/Screens/Invoice/PaidInfoList/paid_info_provider.dart';
import 'package:fast_quote/Screens/Invoice/invoice_helper.dart';
import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/material.dart';

class UpdateChallanProvider with ChangeNotifier {
  ChallanRepository challanRepository = ChallanRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  File? pdfFile;

  final TextEditingController _ctlPhone = TextEditingController();
  TextEditingController get ctlPhone => _ctlPhone;

  final TextEditingController _ctlAddress = TextEditingController();
  TextEditingController get ctlAddress => _ctlAddress;

  final TextEditingController _ctlTopMessage = TextEditingController();
  TextEditingController get ctlTopMessage => _ctlTopMessage;

  final TextEditingController _ctlBottomMessage = TextEditingController();
  TextEditingController get ctlBottomMessage => _ctlBottomMessage;

  final TextEditingController _ctlDeliveryDate = TextEditingController();
  TextEditingController get ctlDeliveryDate => _ctlDeliveryDate;

  final TextEditingController _ctlShippingAddress = TextEditingController();
  TextEditingController get ctlShippingAddress => _ctlShippingAddress;

  isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  initData(ChallanListModel challanListModel) {
    _ctlPhone.text = challanListModel.customerPhone!;
    _ctlAddress.text = challanListModel.customerAddress!;
    _ctlTopMessage.text = challanListModel.topMessage!;
    _ctlBottomMessage.text = challanListModel.bottomMessage!;
    _ctlDeliveryDate.text = challanListModel.invoiceDate!;
    _ctlShippingAddress.text = challanListModel.shippingAddress!;
  }

  Future updateChallan(
    BuildContext context,
    ChallanListModel challanListModel,
    String challanData,
  ) async {
    CommonFunctions.showProgressBar(context);

    InvoiceModel invoiceModel = InvoiceModel.fromJson(json.decode(challanData));

    CustomerModel customerModel = CustomerModel.fromJson(
      json.decode(invoiceModel.customerData!),
    );

    customerModel.newCustomerMobile = _ctlPhone.text.trim();
    customerModel.newCustomerAddress = _ctlAddress.text.trim();
    customerModel.newShippingAddress = _ctlShippingAddress.text.trim();

    var customerModelString = json.encode(customerModel.toJson());

    invoiceModel.newCustomerData = customerModelString;

    QuoteInvSettingModel quoteInvSettingModel = QuoteInvSettingModel.fromJson(
      json.decode(invoiceModel.quoteInvSettingData!),
    );

    quoteInvSettingModel.setTopMessage = _ctlTopMessage.text.trim();
    quoteInvSettingModel.setBottomMessage = _ctlBottomMessage.text.trim();
    var quoteInv = json.encode(quoteInvSettingModel.toJson());
    invoiceModel.newSettingData = quoteInv;

    double totalTax = 0.0;
    int roundOftotal = 0;
    double subTotal = 0.0;
    double subTotalTax = 0.0;
    double subTotalDiscount = 0.0;
    double discAmt = 0.0;
    double appliedTotalTaxAmt = 0.0;
    double paidInfoAmt = 0.0;
    double total = 0.0;

    bool isPercentage = false;

    BusinessModel businessModel = BusinessModel.fromConverChallanJson(
      json.decode(invoiceModel.businessData!),
    );

    List<ProductModel> productList =
        json
            .decode(invoiceModel.productData!)
            .map<ProductModel>((e) => ProductModel.fromJson(e))
            .toList();

    List<TermsModel> termsList =
        json
            .decode(invoiceModel.termsConditionData!)
            .map<TermsModel>((e) => TermsModel.fromJson(e))
            .toList();

    String discountStatus = quoteInvSettingModel.discount!;
    String taxStatus = quoteInvSettingModel.tax!;

    String ctlDisc = "";

    List<OtherchargesModel> otherChargeList = [];
    if (invoiceModel.otherChargesData != "[]") {
      otherChargeList =
          json
              .decode(invoiceModel.otherChargesData!)
              .map<OtherchargesModel>((e) => OtherchargesModel.fromJson(e))
              .toList();
    }
    List<PaidInfoModel> paidInfoList =
        json
            .decode(invoiceModel.paidInfoListData!)
            .map<PaidInfoModel>((e) => PaidInfoModel.fromJson(e))
            .toList();

    String totalApplyTax = invoiceModel.totalTaxPercentage!;
    String ctlTotalTax = invoiceModel.totalTaxPercentage!;

    bool roundOffAmt = invoiceModel.roundOffAmt!;
    double totalAmtDue = double.parse(invoiceModel.amtDue!);
    int roundOftotalAmtDue = totalAmtDue.toInt();

    var calculatedData = await InvoiceHelper().calculationFunction(
      context: context,
      roundOftotalAmtDue: roundOftotalAmtDue,
      totalAmtDue: totalAmtDue,
      totalTax: totalTax,
      subTotal: subTotal,
      subTotalTax: subTotalTax,
      subTotalDiscount: subTotalDiscount,
      otherChargeList: otherChargeList,
      productList: productList,
      paidInfoList: paidInfoList,
      taxStatus: taxStatus,
      discountStatus: discountStatus,
      ctlTotalTax: ctlTotalTax,
      ctlDisc: ctlDisc,
      isPercentage: isPercentage,
      discAmt: discAmt,
      totalApplyTax: totalApplyTax,
      appliedTotalTaxAmt: appliedTotalTaxAmt,
      total: total,
      paidInfoAmt: paidInfoAmt,
      roundOftotal: roundOftotal,
    );

    roundOftotalAmtDue = calculatedData[0];
    totalAmtDue = calculatedData[1];
    totalTax = calculatedData[2];
    subTotal = calculatedData[3];
    subTotalTax = calculatedData[4];
    subTotalDiscount = calculatedData[5];
    otherChargeList = calculatedData[6];
    ctlTotalTax = calculatedData[7];
    ctlDisc = calculatedData[8];
    isPercentage = calculatedData[9];
    discAmt = calculatedData[10];
    totalApplyTax = calculatedData[11];
    appliedTotalTaxAmt = calculatedData[12];
    total = calculatedData[13];
    paidInfoAmt = calculatedData[14];
    roundOftotal = calculatedData[15];
    String rouoffValue = "0";
    if (roundOffAmt) {
      rouoffValue = (totalAmtDue - totalAmtDue.toInt()).toStringAsFixed(2);
    }

    pdfFile = await ChallanPDF().generate(
      customerModel,
      productList,
      termsList,
      otherChargeList,
      businessModel,
      roundOffAmt
          ? roundOftotalAmtDue.toStringAsFixed(2)
          : totalAmtDue.toStringAsFixed(2),
      subTotalTax.toStringAsFixed(2),
      subTotal.toStringAsFixed(2),
      quoteInvSettingModel,
      subTotalDiscount.toStringAsFixed(2),
      [totalApplyTax, appliedTotalTaxAmt],
      isPercentage ? [ctlDisc, discAmt.toStringAsFixed(2)] : ["0", ctlDisc],
      paidInfoList.isEmpty,
      [paidInfoAmt, total],
      invoiceModel.invoiceNo,
      roundOffAmt ? rouoffValue : "0",
    );

    var updateinvoiceData = json.encode(invoiceModel.toJson());

    FormData formData = FormData.fromMap({
      "data": updateinvoiceData,
      "invoice_reciept": await MultipartFile.fromFile(pdfFile!.path),
    });

    final result = await challanRepository.updateChallan(
      context,
      formData,
      challanListModel.id.toString(),
    );

    result.fold(
      (error) {
        Navigator.pop(context);
        CommonFunctions.showErrorSnackbar(context, error.message);
      },
      (data) {
        Navigator.pop(context);
        CommonFunctions.showSuccessSnackbar("Updated Successfullty");
        var resp = data.data;

        ChallanListModel modelData = ChallanListModel.fromJson(resp['data']);

        redirect(pdfFile, context, updateinvoiceData, modelData);
      },
    );
  }

  void redirect(
    final pdfFile,
    BuildContext context,
    String enquiryData,
    ChallanListModel enquiryListModel,
  ) {
    Navigator.of(context)
      ..pop()
      ..pop()
      ..pushNamed(
        RouteNames.challanViewPage,
        arguments: {
          "file": pdfFile,
          "invoiceData": enquiryData,
          "invoiceListModel": enquiryListModel,
          "isSavedAsTemplate": false,
        },
      );
  }
}
