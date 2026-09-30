import 'dart:convert';

import 'package:fast_quote/Screens/Auth/other_charges_model.dart';
import 'package:fast_quote/Screens/Challan/challan_pdf.dart';
import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Enquiry/CreateEnquiry/enquiry_model.dart';
import 'package:fast_quote/Screens/Invoice/PaidInfoList/paid_info_provider.dart';
import 'package:fast_quote/Screens/Invoice/invoice_pdf.dart';
import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceHelper {
  List<dynamic> convertDataFromQuotation(
      {required BuildContext context,
      required String enquiryData,
      required String discountStatus,
      required String taxStatus,
      required String quoteNum,
      required bool addedDiscount,
      required bool isPercentage}) {
    CustomerModel customerModel = CustomerModel();
    List<ProductModel> productList = [];
    List<OtherchargesModel> otherChargeList = [];
    List<TermsModel> termsList = [];
    String enqDate = "", enqNumber = "";
    bool roundOffAmt = false;
    String totalTaxPercentage = "", totalDiscount = "";

    var quotationModel = QuotationModel.fromJson(json.decode(enquiryData));

    customerModel =
        CustomerModel.fromJson(json.decode(quotationModel.customerData!));

    productList = json
        .decode(quotationModel.productData!)
        .map<ProductModel>((e) => ProductModel.fromJson(e))
        .toList();

    var returnedData = clearRestValueThanCurrentCondition(
        context: context,
        discountStatus: discountStatus,
        taxStatus: taxStatus,
        productList: productList,
        quotationModel: quotationModel,
        isPercentage: false,
        addedDiscount: false,
        from: "Create");

    productList = returnedData[0];
    addedDiscount = returnedData[1];
    isPercentage = returnedData[2];
    totalDiscount = returnedData[3];
    totalTaxPercentage = returnedData[4];

    if (quotationModel.otherChargesData != "[]") {
      otherChargeList = json
          .decode(quotationModel.otherChargesData!)
          .map<OtherchargesModel>((e) => OtherchargesModel.fromJson(e))
          .toList();
    } else {
      otherChargeList = [];
    }

    enqDate = quotationModel.quotationDate!;
    enqNumber = quotationModel.quotationNo!;
    roundOffAmt = quotationModel.roundOffAmt!;

    return [
      customerModel,
      productList,
      otherChargeList,
      termsList,
      enqDate,
      enqNumber,
      roundOffAmt,
      totalTaxPercentage,
      totalDiscount,
      isPercentage,
      addedDiscount
    ];
  }

  List<dynamic> convertDataFromInvoice(
      {required BuildContext context,
      required String enquiryData,
      required String discountStatus,
      required String taxStatus,
      required String invoiceNum,
      required bool addedDiscount,
      required bool isPercentage,
      required String from}) {
    CustomerModel customerModel = CustomerModel();
    List<ProductModel> productList = [];
    List<OtherchargesModel> otherChargeList = [];
    List<TermsModel> termsList = [];
    List<PaidInfoModel> paidInfoList = [];
    String enqDate = "", enqNumber = "";
    bool roundOffAmt = false;
    String totalTaxPercentage = "",
        totalDiscount = "",
        dueDate = "",
        poNumber = "";

    var invoiceModel = InvoiceModel.fromJson(json.decode(enquiryData));

    customerModel =
        CustomerModel.fromJson(json.decode(invoiceModel.customerData!));

    productList = json
        .decode(invoiceModel.productData!)
        .map<ProductModel>((e) => ProductModel.fromJson(e))
        .toList();

    var returnedData = clearRestValueThanCurrentCondition(
        context: context,
        discountStatus: discountStatus,
        taxStatus: taxStatus,
        productList: productList,
        quotationModel: invoiceModel,
        isPercentage: false,
        addedDiscount: false,
        from: "Create");

    paidInfoList = json
        .decode(invoiceModel.paidInfoListData!)
        .map<PaidInfoModel>((e) => PaidInfoModel.fromJson(e))
        .toList();

    productList = returnedData[0];
    addedDiscount = returnedData[1];
    isPercentage = returnedData[2];
    totalDiscount = returnedData[3];
    totalTaxPercentage = returnedData[4];

    if (invoiceModel.otherChargesData != "[]") {
      otherChargeList = json
          .decode(invoiceModel.otherChargesData!)
          .map<OtherchargesModel>((e) => OtherchargesModel.fromJson(e))
          .toList();
    } else {
      otherChargeList = [];
    }

    termsList = json
        .decode(invoiceModel.termsConditionData!)
        .map<TermsModel>((e) => TermsModel.fromJson(e))
        .toList();

    enqDate = invoiceModel.invoiceDate!;
    if (from == "Template") {
      enqNumber = invoiceNum;
    } else {
      enqNumber = invoiceModel.invoiceNo!;
    }

    roundOffAmt = invoiceModel.roundOffAmt!;
    dueDate = invoiceModel.dueDate!;
    poNumber = invoiceModel.poNumber!;

    return [
      customerModel,
      productList,
      otherChargeList,
      termsList,
      enqDate,
      enqNumber,
      roundOffAmt,
      totalTaxPercentage,
      totalDiscount,
      isPercentage,
      addedDiscount,
      dueDate,
      poNumber,
      paidInfoList
    ];
  }

  Future<CustomerModel> addCustomer(BuildContext context) async {
    CustomerModel customerModel = CustomerModel();
    var data = await Navigator.of(context)
        .pushNamed(RouteNames.customerScreen, arguments: {"from": "true"});
    if (!context.mounted) return customerModel;

    if (data != null) {
      return customerModel = data as CustomerModel;
    } else {
      return customerModel;
    }
  }

  // Check Whether Product is present in list
  bool findProduct(String id, List<ProductModel> productList) {
    for (var i in productList) {
      if (id == i.id) {
        return true;
      }
    }
    return false;
  }

  //For Adding Product
  Future<List<ProductModel>> addProduct(BuildContext context,
      List<ProductModel> productList, String action) async {
    var data = await Navigator.of(context).pushNamed(RouteNames.productScreen,
        arguments: {"from": "true", "fromPage": "Invoice", "action": action});
    if (!context.mounted) return productList;

    if (data != null) {
      var product = data as ProductModel;
      if (findProduct(product.id!, productList)) {
        int indexOfBob =
            productList.indexWhere((person) => person.id == product.id);
        productList[indexOfBob] = product;
        return productList;
      } else {
        productList.add(product);
        return productList;
      }
    } else {
      return productList;
    }
  }

  //For Editing Product
  Future<List<ProductModel>> editProduct(
      BuildContext context,
      List<ProductModel> productList,
      ProductModel productModel,
      String action) async {
    var data = await Navigator.of(context).pushNamed(
        RouteNames.addProductInvoice,
        arguments: {"model": productModel, "action": action});
    if (!context.mounted) return productList;

    if (data != null) {
      var product = data as ProductModel;
      if (findProduct(product.id!, productList)) {
        int indexOfBob =
            productList.indexWhere((person) => person.id == product.id);
        productList[indexOfBob] = product;
        return productList;
      } else {
        return productList;
      }
    } else {
      return productList;
    }
  }

  //For Adding Terms
  Future<List<TermsModel>> addTerms(
      BuildContext context, List<TermsModel> termsList) async {
    var data = await Navigator.of(context)
        .pushNamed(RouteNames.invoiceTermsScreen, arguments: {
      "fromAddTerm": true,
      "context": context,
      "selectedTerms": termsList
    });
    if (!context.mounted) return termsList;

    if (data != null) {
      return termsList = data as List<TermsModel>;
    } else {
      return termsList;
    }
  }

  //For Paid Info
  Future<List<PaidInfoModel>> addPaidInfo(
      BuildContext context, List<PaidInfoModel> paidInfoList) async {
    var data = await Navigator.of(context).pushNamed(
      RouteNames.paidInfoListScreen,
    );
    if (!context.mounted) return paidInfoList;

    if (data != null) {
      return paidInfoList = data as List<PaidInfoModel>;
    } else {
      return paidInfoList;
    }
  }

  Future<List> calculationFunction(
      {required BuildContext context,
      required int roundOftotalAmtDue,
      required double totalAmtDue,
      required double totalTax,
      required double subTotal,
      required double subTotalTax,
      required double subTotalDiscount,
      required List<OtherchargesModel> otherChargeList,
      required List<ProductModel> productList,
      required List<PaidInfoModel> paidInfoList,
      required String taxStatus,
      required String discountStatus,
      required String ctlTotalTax,
      required String ctlDisc,
      required bool isPercentage,
      required double discAmt,
      required String totalApplyTax,
      required double appliedTotalTaxAmt,
      required double total,
      required double paidInfoAmt,
      required int roundOftotal}) async {
    roundOftotalAmtDue = totalAmtDue.toInt();
    totalTax = 0.0;
    totalAmtDue = 0.0;
    subTotal = 0.0;
    subTotalTax = 0.0;
    subTotalDiscount = 0.0;

    if (productList.isNotEmpty) {
      for (var element in productList) {
        totalTax += double.parse(element.productAppliedGST!);
        subTotalTax += double.parse(element.productAppliedGST!);
        totalAmtDue += double.parse(element.productTaxAmount!);

        subTotal += double.parse(element.productTaxAmount!);
        if (element.discountAmt!.isEmpty) {
          subTotalDiscount += double.parse("0");
        } else {
          subTotalDiscount += double.parse(element.discountAmt!);
        }
      }
    }

    if (taxStatus == "On Total" || discountStatus == "On Total") {
      List listOfData = await taxOnTotaldiscOntotal(
          context: context,
          taxStatus: taxStatus,
          discountStatus: discountStatus,
          ctlTotalTax: ctlTotalTax,
          isPercentage: isPercentage,
          ctlDisc: ctlDisc,
          discAmt: discAmt,
          appliedTotalTaxAmt: appliedTotalTaxAmt,
          otherChargeList: otherChargeList,
          totalTax: totalTax,
          totalAmtDue: totalAmtDue,
          totalApplyTax: totalApplyTax);

      ctlTotalTax = listOfData[0];
      isPercentage = listOfData[1];
      ctlDisc = listOfData[2];
      discAmt = listOfData[3];
      appliedTotalTaxAmt = listOfData[4];
      otherChargeList = listOfData[5];
      totalTax = listOfData[6];
      totalAmtDue = listOfData[7];
      totalApplyTax = listOfData[8];
    }

    if (discountStatus != "On Total") {
      if (otherChargeList.isNotEmpty) {
        for (var element in otherChargeList) {
          totalAmtDue += double.parse(element.amount!);
          if (element.isTaxable!) {
            totalTax += double.parse(element.taxAmt!);
            totalAmtDue += double.parse(element.taxAmt!);
          } else {
            totalTax += 0.0;
          }
        }
      }
    }

    if (paidInfoList.isNotEmpty) {
      paidInfoAmt = 0.0;
      for (var element in paidInfoList) {
        paidInfoAmt += element.amount!;
      }
      total = totalAmtDue;
      totalAmtDue = totalAmtDue - paidInfoAmt;
    }

    roundOftotalAmtDue = totalAmtDue.toInt();
    roundOftotal = total.toInt();

    roundOftotalAmtDue = totalAmtDue.toInt();

    return [
      roundOftotalAmtDue,
      totalAmtDue,
      totalTax,
      subTotal,
      subTotalTax,
      subTotalDiscount,
      otherChargeList,
      ctlTotalTax,
      ctlDisc,
      isPercentage,
      discAmt,
      totalApplyTax,
      appliedTotalTaxAmt,
      total,
      paidInfoAmt,
      roundOftotal
    ];
  }

  Future<List> taxOnTotaldiscOntotal(
      {required BuildContext context,
      required String taxStatus,
      required String discountStatus,
      required String ctlTotalTax,
      required bool isPercentage,
      required String ctlDisc,
      required double discAmt,
      required double appliedTotalTaxAmt,
      required List<OtherchargesModel> otherChargeList,
      required double totalTax,
      required double totalAmtDue,
      required String totalApplyTax}) async {
    if (taxStatus == "On Total" && discountStatus == "On Total") {
      if (ctlTotalTax.isEmpty) {
        ctlTotalTax = "0";
      }
      if (ctlDisc.isEmpty) {
        ctlDisc = "0";
      }

      if (isPercentage) {
        if (ctlDisc == "0") {
          discAmt = 0.0;
        } else {
          discAmt = CommonFunctions.discountOnPercentageFunction(
              context, ctlDisc, totalAmtDue);
        }

        totalAmtDue = totalAmtDue - discAmt;
      } else {
        if (ctlDisc != "0") {
          discAmt = double.parse(ctlDisc);
          totalAmtDue = CommonFunctions.discountOnFlatFunction(
              context, ctlDisc, totalAmtDue);
        } else {
          discAmt = 0.0;
          totalAmtDue = totalAmtDue - discAmt;
        }
      }

      var tax =
          await CommonFunctions.getAmountForTax(totalApplyTax, totalAmtDue);
      appliedTotalTaxAmt = tax[1];
      totalTax += tax[1];
      totalAmtDue += tax[1];

      if (otherChargeList.isNotEmpty) {
        for (var element in otherChargeList) {
          totalAmtDue += double.parse(element.amount!);
          if (element.isTaxable!) {
            totalTax += double.parse(element.taxAmt!);
            totalAmtDue += double.parse(element.taxAmt!);
          } else {
            totalTax += 0.0;
          }
        }
      }
      return [
        ctlTotalTax,
        isPercentage,
        ctlDisc,
        discAmt,
        appliedTotalTaxAmt,
        otherChargeList,
        totalTax,
        totalAmtDue,
        totalApplyTax
      ];
    }
    if (taxStatus == "On Total") {
      if (ctlTotalTax.isEmpty) {
        ctlTotalTax = "0";
      }

      var tax =
          await CommonFunctions.getAmountForTax(totalApplyTax, totalAmtDue);
      appliedTotalTaxAmt = tax[1];
      totalTax += tax[1];
      totalAmtDue += tax[1];
      return [
        ctlTotalTax,
        isPercentage,
        ctlDisc,
        discAmt,
        appliedTotalTaxAmt,
        otherChargeList,
        totalTax,
        totalAmtDue,
        totalApplyTax
      ];
    } else if (discountStatus == "On Total") {
      if (otherChargeList.isNotEmpty) {
        for (var element in otherChargeList) {
          totalAmtDue += double.parse(element.amount!);

          if (element.isTaxable!) {
            totalTax += double.parse(element.taxAmt!);
            totalAmtDue += double.parse(element.taxAmt!);
          } else {
            totalTax += 0.0;
          }
        }
      }

      if (ctlDisc.isEmpty) {
        ctlDisc = "0";
      }

      if (isPercentage) {
        if (ctlDisc == "0") {
          discAmt = 0.0;
        } else {
          discAmt = CommonFunctions.discountOnPercentageFunction(
              context, ctlDisc, totalAmtDue);
        }

        totalAmtDue = totalAmtDue - discAmt;
      } else {
        if (ctlDisc != "0") {
          discAmt = double.parse(ctlDisc);
          totalAmtDue = CommonFunctions.discountOnFlatFunction(
              context, ctlDisc, totalAmtDue);
        } else {
          discAmt = 0.0;
          totalAmtDue = totalAmtDue - discAmt;
        }
      }
      return [
        ctlTotalTax,
        isPercentage,
        ctlDisc,
        discAmt,
        appliedTotalTaxAmt,
        otherChargeList,
        totalTax,
        totalAmtDue,
        totalApplyTax
      ];
    }
    return [
      ctlTotalTax,
      isPercentage,
      ctlDisc,
      discAmt,
      appliedTotalTaxAmt,
      otherChargeList,
      totalTax,
      totalAmtDue,
      totalApplyTax
    ];
  }

  // Create Quotation
  Future<dynamic> createInvoice({
    required CustomerModel customerModel,
    required BuildContext context,
    required List<ProductModel> productList,
    required List<TermsModel> termsList,
    required List<OtherchargesModel> otherChargeList,
    required List<PaidInfoModel> paidInfoList,
    required bool roundOffAmt,
    required double totalAmtDue,
    required DateTime selectedDate,
    required String invoiceNumber,
    required int roundOftotalAmtDue,
    required double totalTax,
    required BusinessModel businessModel,
    required QuoteInvSettingModel quoteInvSettingModel,
    required double subTotal,
    required double subTotalTax,
    required bool addedDiscount,
    required bool isPercentage,
    required String ctlDisc,
    required double discAmt,
    required double subTotalDiscount,
    required double appliedTotalTaxAmt,
    required String totalApplyTax,
    required Map<String, dynamic> quoteInvSettingJson,
    required Map<String, dynamic> businessJson,
    required String dueDate,
    required String ctlPoNumber,
    required double paidInfoAmt,
    required double total,
  }) async {
    String rouoffValue = "0";
    if (customerModel.companyName == null) {
      CommonFunctions.showErrorSnackbar(context, "Add Customer");
      return null;
    } else if (productList.isEmpty) {
      CommonFunctions.showErrorSnackbar(context, "Add Product");
      return null;
    } else if (termsList.isEmpty) {
      CommonFunctions.showErrorSnackbar(context, "Add Terms & Conditions");
      return null;
    } else {
      if (roundOffAmt) {
        rouoffValue = (totalAmtDue - totalAmtDue.toInt()).toStringAsFixed(2);
      }

      var customerModelString = json.encode(customerModel.toJson());

      var productListString =
          json.encode(productList.map((e) => e.toJson()).toList());

      var paidInfoListString =
          json.encode(paidInfoList.map((e) => e.toJson()).toList());

      var otherChargeListString =
          json.encode(otherChargeList.map((e) => e.toJson()).toList());

      var termsListString =
          json.encode(termsList.map((e) => e.toJson()).toList());

      var quoteInvSettingString = json.encode(quoteInvSettingJson);

      var businessString = json.encode(businessJson);

      InvoiceModel invoiceModel = InvoiceModel(
          customerData: customerModelString,
          invoiceDate: DateFormat('yyyy-MM-dd').format(selectedDate),
          invoiceNo: invoiceNumber,
          otherChargesData: otherChargeListString,
          productData: productListString,
          termsConditionData: termsListString,
          totalTax: totalTax.toString(),
          amtDue: totalAmtDue.toString(),
          roundOffAmt: roundOffAmt,
          roundOftotalAmtDue: roundOftotalAmtDue.toString(),
          isTotalDiscountAdded: addedDiscount,
          totalDiscountType: isPercentage ? "Percentage" : "FlatAmt",
          totalDiscountPercentage: isPercentage ? ctlDisc : "0",
          totalDiscountedAmount: discAmt.toStringAsFixed(2),
          totalTaxPercentage: totalApplyTax,
          dueDate: dueDate,
          poNumber: ctlPoNumber,
          paidInfoListData: paidInfoListString,
          quoteInvSettingData: quoteInvSettingString,
          businessData: businessString);

      var invoiceData = json.encode(invoiceModel.toJson());

      final pdfFile = await InvoicePDF().generate(
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
          invoiceNumber,
          dueDate,
          ctlPoNumber,
          DateFormat('yyyy-MM-dd').format(selectedDate),
          roundOffAmt ? rouoffValue : "0");

      return [invoiceData, pdfFile];
    }
  }

  // Update Invoice
  Future<dynamic> updateInvoice({
    required CustomerModel customerModel,
    required BuildContext context,
    required List<ProductModel> productList,
    required List<TermsModel> termsList,
    required List<OtherchargesModel> otherChargeList,
    required List<PaidInfoModel> paidInfoList,
    required bool roundOffAmt,
    required double totalAmtDue,
    required DateTime selectedDate,
    required String invoiceNumber,
    required int roundOftotalAmtDue,
    required double totalTax,
    required BusinessModel businessModel,
    required QuoteInvSettingModel quoteInvSettingModel,
    required double subTotal,
    required double subTotalTax,
    required bool addedDiscount,
    required bool isPercentage,
    required String ctlDisc,
    required double discAmt,
    required double subTotalDiscount,
    required double appliedTotalTaxAmt,
    required String totalApplyTax,
    required String discountStatus,
    required String taxStatus,
    required Map<String, dynamic> quoteInvSettingJson,
    required Map<String, dynamic> businessJson,
    required String dueDate,
    required String ctlPoNumber,
    required double paidInfoAmt,
    required double total,
  }) async {
    String rouoffValue = "0";
    if (customerModel.companyName == null) {
      CommonFunctions.showErrorSnackbar(context, "Add Customer");
      return null;
    } else if (productList.isEmpty) {
      CommonFunctions.showErrorSnackbar(context, "Add Product");
      return null;
    } else if (termsList.isEmpty) {
      CommonFunctions.showErrorSnackbar(context, "Add Terms & Conditions");
      return null;
    } else {
      if (roundOffAmt) {
        rouoffValue = (totalAmtDue - totalAmtDue.toInt()).toStringAsFixed(2);
      }

      var customerModelString = json.encode(customerModel.toJson());

      var returnedData = clearRestValueThanCurrentCondition(
          context: context,
          discountStatus: discountStatus,
          taxStatus: taxStatus,
          productList: productList,
          from: "Update",
          addedDiscount: addedDiscount,
          isPercentage: isPercentage);

      productList = returnedData[0];
      addedDiscount = returnedData[1];
      isPercentage = returnedData[2];

      var productListString =
          json.encode(productList.map((e) => e.toJson()).toList());

      var otherChargeListString =
          json.encode(otherChargeList.map((e) => e.toJson()).toList());

      var paidInfoListString =
          json.encode(paidInfoList.map((e) => e.toJson()).toList());

      var termsListString =
          json.encode(termsList.map((e) => e.toJson()).toList());

      var quoteInvSettingString = json.encode(quoteInvSettingJson);

      var businessString = json.encode(businessJson);

      final invoiceModel = InvoiceModel(
          customerData: customerModelString,
          invoiceDate: DateFormat('yyyy-MM-dd').format(selectedDate),
          invoiceNo: invoiceNumber,
          otherChargesData: otherChargeListString,
          productData: productListString,
          termsConditionData: termsListString,
          totalTax: totalTax.toString(),
          amtDue: totalAmtDue.toString(),
          roundOffAmt: roundOffAmt,
          roundOftotalAmtDue: roundOftotalAmtDue.toString(),
          isTotalDiscountAdded: addedDiscount,
          totalDiscountType: isPercentage ? "Percentage" : "FlatAmt",
          totalDiscountPercentage: isPercentage ? ctlDisc : "0",
          totalDiscountedAmount: discAmt.toStringAsFixed(2),
          totalTaxPercentage: totalApplyTax,
          dueDate: dueDate,
          poNumber: ctlPoNumber,
          paidInfoListData: paidInfoListString,
          quoteInvSettingData: quoteInvSettingString,
          businessData: businessString);
      var invoiceData = json.encode(invoiceModel.toJson());

      final pdfFile = await InvoicePDF().generate(
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
          invoiceNumber,
          dueDate,
          ctlPoNumber,
          DateFormat('yyyy-MM-dd').format(selectedDate),
          roundOffAmt ? rouoffValue : "0");

      return [invoiceData, pdfFile];
    }
  }

  List clearRestValueThanCurrentCondition({
    required BuildContext context,
    required String discountStatus,
    required String taxStatus,
    required String from,
    required List<ProductModel> productList,
    required bool addedDiscount,
    required bool isPercentage,
    dynamic quotationModel,
  }) {
    String totalTaxPercentage = "", totalDiscount = "";

    if (discountStatus == "No Discount" && taxStatus == "No Tax") {
      for (var element in productList) {
        element.discNoDiscTaxNoTaxQuotation = true;
      }

      if (from == "Create") {
        addedDiscount = quotationModel!.isTotalDiscountAdded!;

        isPercentage =
            quotationModel.totalDiscountType == "Percentage" ? true : false;
      }

      totalTaxPercentage = "0";
      totalDiscount = "0";
    } else if (discountStatus == "No Discount" && taxStatus == "Per item") {
      for (var element in productList) {
        element.discNoDiscTaxPerItemQuotation = true;
      }
      if (from == "Create") {
        addedDiscount = quotationModel!.isTotalDiscountAdded!;

        isPercentage =
            quotationModel.totalDiscountType == "Percentage" ? true : false;
      }
      totalTaxPercentage = "0";
      totalDiscount = "0";
    } else if (discountStatus == "No Discount" && taxStatus == "On Total") {
      for (var element in productList) {
        element.discNoDisctaxOnTotalQuotation = true;
      }
      if (from == "Create") {
        addedDiscount = quotationModel!.isTotalDiscountAdded!;

        isPercentage =
            quotationModel.totalDiscountType == "Percentage" ? true : false;
        totalTaxPercentage = quotationModel.totalTaxPercentage!;
      } else {
        totalTaxPercentage = "0";
      }

      totalDiscount = "0";
    } else if (discountStatus == "Per item" && taxStatus == "No Tax") {
      for (var element in productList) {
        element.discPerItemTaxNoTaxQuotation = context;
      }
      if (from == "Create") {
        addedDiscount = quotationModel!.isTotalDiscountAdded!;

        isPercentage =
            quotationModel.totalDiscountType == "Percentage" ? true : false;
      }
      totalTaxPercentage = "0";
      totalDiscount = "0";
    } else if (discountStatus == "Per item" && taxStatus == "Per item") {
      for (var element in productList) {
        element.discPerItemTaxPerItemQuotation = context;
      }
      if (from == "Create") {
        addedDiscount = quotationModel!.isTotalDiscountAdded!;

        isPercentage =
            quotationModel.totalDiscountType == "Percentage" ? true : false;
      }
      totalTaxPercentage = "0";
      totalDiscount = "0";
    } else if (discountStatus == "Per item" && taxStatus == "On Total") {
      for (var element in productList) {
        element.discPerItemTaxOnTotalQuotation = context;
      }
      if (from == "Create") {
        addedDiscount = quotationModel!.isTotalDiscountAdded!;

        isPercentage =
            quotationModel.totalDiscountType == "Percentage" ? true : false;
        totalTaxPercentage = quotationModel.totalTaxPercentage!;
      } else {
        totalTaxPercentage = "0";
      }
      totalDiscount = "0";
    } else if (discountStatus == "On Total" && taxStatus == "No Tax") {
      for (var element in productList) {
        element.discOnTotalTaxNoTaxQuotation = context;
      }

      if (from == "Create") {
        addedDiscount = quotationModel!.isTotalDiscountAdded!;

        isPercentage =
            quotationModel.totalDiscountType == "Percentage" ? true : false;
        totalDiscount = quotationModel.totalDiscountType == "Percentage"
            ? quotationModel.totalDiscountPercentage!
            : quotationModel.totalDiscountedAmount!;
      } else {
        totalDiscount = "0";
      }

      totalTaxPercentage = "0";
    } else if (discountStatus == "On Total" && taxStatus == "Per item") {
      for (var element in productList) {
        element.discOnTotalTaxPerItemQuotation = context;
      }

      if (from == "Create") {
        addedDiscount = quotationModel!.isTotalDiscountAdded!;

        isPercentage =
            quotationModel.totalDiscountType == "Percentage" ? true : false;
        totalDiscount = quotationModel.totalDiscountType == "Percentage"
            ? quotationModel.totalDiscountPercentage!
            : quotationModel.totalDiscountedAmount!;
      } else {
        totalDiscount = "0";
      }
      totalTaxPercentage = "0";
    } else if (discountStatus == "On Total" && taxStatus == "On Total") {
      for (var element in productList) {
        element.discOnTotalTaxOnTotalQuotation = context;
      }

      if (from == "Create") {
        addedDiscount = quotationModel!.isTotalDiscountAdded!;

        isPercentage =
            quotationModel.totalDiscountType == "Percentage" ? true : false;
        totalDiscount = quotationModel.totalDiscountType == "Percentage"
            ? quotationModel.totalDiscountPercentage!
            : quotationModel.totalDiscountedAmount!;
        totalTaxPercentage = quotationModel.totalTaxPercentage!;
      } else {
        totalDiscount = "0";
        totalTaxPercentage = "0";
      }
    }
    return [
      productList,
      addedDiscount,
      isPercentage,
      totalDiscount,
      totalTaxPercentage
    ];
  }

  Future<dynamic> generateChallan({
    required BuildContext context,
    required String invoiceData,
    required String challanLength,
  }) async {
    var invoiceModel = InvoiceModel.fromJson(json.decode(invoiceData));
    CustomerModel customerModel = CustomerModel();
    List<ProductModel> productList = [];
    List<OtherchargesModel> otherChargeList = [];
    List<TermsModel> termsList = [];
    List<PaidInfoModel> paidInfoList = [];
    String invoiceDate = "", invoiceNumber = "";
    bool roundOffAmt = false;
    double subTotalTax = 0.0;
    String totalApplyTax = "",
        ctlTotalTax = "",
        ctlDisc = "",
        dueDate = "",
        ctlPoNumber = "";
    double totalTax = 0.0, subTotal = 0.0;
    double subTotalDiscount = 0.0;
    double appliedTotalTaxAmt = 0.0;
    double paidInfoAmt = 0.0;
    double total = 0.0;
    double discAmt = 0.0;
    int roundOftotal = 0;
    String rouoffValue = "0";
    bool addedDiscount = false, isPercentage = false;
    QuoteInvSettingModel quoteInvSettingModel = QuoteInvSettingModel.fromJson(
        json.decode(invoiceModel.quoteInvSettingData!));

    BusinessModel businessModel = BusinessModel.fromConverChallanJson(
        json.decode(invoiceModel.businessData!));

    String discountStatus = quoteInvSettingModel.discount!;
    String taxStatus = quoteInvSettingModel.tax!;
    var listOfData = InvoiceHelper().convertDataFromInvoice(
        context: context,
        enquiryData: invoiceData,
        discountStatus: discountStatus,
        taxStatus: taxStatus,
        invoiceNum: "invoiceNum",
        addedDiscount: addedDiscount,
        isPercentage: isPercentage,
        from: "Invoice");

    customerModel = listOfData[0];

    productList = listOfData[1];
    otherChargeList = listOfData[2];

    termsList = listOfData[3];
    invoiceDate = listOfData[4];
    invoiceNumber = listOfData[5];
    roundOffAmt = listOfData[6];

    totalApplyTax = listOfData[7].toString();
    ctlTotalTax = listOfData[7].toString();

    ctlDisc = listOfData[8].toString();

    isPercentage = listOfData[9];
    addedDiscount = listOfData[10];
    dueDate = listOfData[11];
    ctlPoNumber = listOfData[12];
    paidInfoList = listOfData[13];
    totalApplyTax = invoiceModel.totalTaxPercentage!;
    ctlTotalTax = invoiceModel.totalTaxPercentage!;

    roundOffAmt = invoiceModel.roundOffAmt!;
    double totalAmtDue = double.parse(invoiceModel.amtDue!);
    int roundOftotalAmtDue = totalAmtDue.toInt();

    roundOftotalAmtDue = totalAmtDue.toInt();
    totalAmtDue = 0.0;
    roundOffAmt = invoiceModel.roundOffAmt!;
    totalAmtDue = double.parse(invoiceModel.amtDue!);
    roundOftotalAmtDue = totalAmtDue.toInt();

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
        roundOftotal: roundOftotal);

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

    if (roundOffAmt) {
      rouoffValue = (totalAmtDue - totalAmtDue.toInt()).toStringAsFixed(2);
    }

    var customerModelString = json.encode(customerModel.toJson());

    var productListString =
        json.encode(productList.map((e) => e.toJson()).toList());

    var paidInfoListString =
        json.encode(paidInfoList.map((e) => e.toJson()).toList());

    var otherChargeListString =
        json.encode(otherChargeList.map((e) => e.toJson()).toList());

    var termsListString =
        json.encode(termsList.map((e) => e.toJson()).toList());

    var quoteInvSettingString = json.encode(quoteInvSettingModel.toJson());

    var businessString = json.encode(businessModel.toJson());

    InvoiceModel updateinvoiceModel = InvoiceModel(
      customerData: customerModelString,
      invoiceDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      invoiceNo: "Challan-$challanLength",
      otherChargesData: otherChargeListString,
      productData: productListString,
      termsConditionData: termsListString,
      totalTax: totalTax.toString(),
      amtDue: totalAmtDue.toString(),
      roundOffAmt: roundOffAmt,
      roundOftotalAmtDue: roundOftotalAmtDue.toString(),
      isTotalDiscountAdded: addedDiscount,
      totalDiscountType: isPercentage ? "Percentage" : "FlatAmt",
      totalDiscountPercentage: isPercentage ? ctlDisc : "0",
      totalDiscountedAmount: discAmt.toStringAsFixed(2),
      totalTaxPercentage: totalApplyTax,
      dueDate: DateTime.now().toIso8601String(),
      poNumber: "2023-11-09",
      paidInfoListData: paidInfoListString,
      quoteInvSettingData: quoteInvSettingString,
      businessData: businessString,
    );

    var updateinvoiceData = json.encode(updateinvoiceModel.toJson());

    final pdfFile = await ChallanPDF().generate(
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
        "Challan-$challanLength",
        roundOffAmt ? rouoffValue : "0");

    return [updateinvoiceData, pdfFile];
  }
}
