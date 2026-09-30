import 'dart:convert';

import 'package:fast_quote/Screens/Auth/other_charges_model.dart';
import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Enquiry/CreateEnquiry/enquiry_model.dart';
import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Quotation/quotation_pdf.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuotationHelper {
  List<dynamic> getConvertToQuotationData(
      {required BuildContext context,
      required String enquiryData,
      required String discountStatus,
      required String taxStatus,
      required String quoteNum}) {
    CustomerModel customerModel = CustomerModel();
    List<ProductModel> productList = [];
    List<OtherchargesModel> otherChargeList = [];
    List<TermsModel> termsList = [];
    String enqDate = "", enqNumber = "";
    bool roundOffAmt = false;

    var enquiryModel = EnquiryModel.fromJson(json.decode(enquiryData));

    customerModel =
        CustomerModel.fromJson(json.decode(enquiryModel.customerData));

    productList = json
        .decode(enquiryModel.productData)
        .map<ProductModel>((e) => ProductModel.fromJson(e))
        .toList();

    if (discountStatus == "No Discount" && taxStatus == "No Tax") {
      for (var element in productList) {
        element.discNoDiscTaxNoTaxEnqToQuote = true;
      }
    } else if (discountStatus == "No Discount" && taxStatus == "Per item") {
      for (var element in productList) {
        element.discNoDiscTaxPerItemEnqToQuote = true;
      }
    } else if (discountStatus == "No Discount" && taxStatus == "On Total") {
      for (var element in productList) {
        element.discNoDisctaxOnTotalEnqToQuote = true;
      }
    } else if (discountStatus == "Per item" && taxStatus == "No Tax") {
      for (var element in productList) {
        element.discPerItemTaxNoTaxEnqToQuote = context;
      }
    } else if (discountStatus == "Per item" && taxStatus == "Per item") {
      for (var element in productList) {
        element.discPerItemTaxPerItemEnqToQuote = context;
      }
    } else if (discountStatus == "Per item" && taxStatus == "On Total") {
      for (var element in productList) {
        element.discPerItemTaxOnTotalEnqToQuote = context;
      }
    } else if (discountStatus == "On Total" && taxStatus == "No Tax") {
      for (var element in productList) {
        element.discOnTotalTaxNoTaxEnqToQuote = context;
      }
    } else if (discountStatus == "On Total" && taxStatus == "Per item") {
      for (var element in productList) {
        element.discOnTotalTaxPerItemEnqToQuote = context;
      }
    } else if (discountStatus == "On Total" && taxStatus == "On Total") {
      for (var element in productList) {
        element.discOnTotalTaxOnTotalEnqToQuote = context;
      }
    }

    if (enquiryModel.otherChargesData != "[]") {
      otherChargeList = json
          .decode(enquiryModel.otherChargesData)
          .map<OtherchargesModel>((e) => OtherchargesModel.fromJson(e))
          .toList();
    } else {
      otherChargeList = [];
    }

    enqDate = enquiryModel.enquiryDate;
    enqNumber = quoteNum;
    roundOffAmt = enquiryModel.roundOffAmt;

    return [
      customerModel,
      productList,
      otherChargeList,
      termsList,
      enqDate,
      enqNumber,
      roundOffAmt,
    ];
  }

  List<dynamic> getDataFromQuotation(
      {required BuildContext context,
      required String enquiryData,
      required String discountStatus,
      required String taxStatus,
      required String quoteNum,
      required bool addedDiscount,
      required bool isPercentage,
      required String from}) {
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

    termsList = json
        .decode(quotationModel.termsConditionData!)
        .map<TermsModel>((e) => TermsModel.fromJson(e))
        .toList();

    enqDate = quotationModel.quotationDate!;

    if (from == "Template") {
      enqNumber = quoteNum;
    } else {
      enqNumber = quotationModel.quotationNo!;
    }

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

  //For Adding Customer
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
        arguments: {"from": "true", "fromPage": "Quotation", "action": action});
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
        RouteNames.addProductQuotation,
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
        .pushNamed(RouteNames.quotationTermsScreen, arguments: {
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
      required String taxStatus,
      required String discountStatus,
      required String ctlTotalTax,
      required String ctlDisc,
      required bool isPercentage,
      required double discAmt,
      required String totalApplyTax,
      required double appliedTotalTaxAmt}) async {
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
      appliedTotalTaxAmt
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
  Future<dynamic> createQuotation({
    required CustomerModel customerModel,
    required BuildContext context,
    required List<ProductModel> productList,
    required List<TermsModel> termsList,
    required List<OtherchargesModel> otherChargeList,
    required bool roundOffAmt,
    required double totalAmtDue,
    required DateTime selectedDate,
    required String quoteNumber,
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

      var otherChargeListString =
          json.encode(otherChargeList.map((e) => e.toJson()).toList());

      var termsListString =
          json.encode(termsList.map((e) => e.toJson()).toList());

      QuotationModel quotationModel = QuotationModel(
          customerData: customerModelString,
          quotationDate: DateFormat('yyyy-MM-dd').format(selectedDate),
          quotationNo: quoteNumber,
          otherChargesData: otherChargeListString,
          productData: productListString,
          termsConditionData: termsListString,
          totalTax: totalTax.toString(),
          amtDue: totalAmtDue.toString(),
          roundOffAmt: roundOffAmt,
          roundOftotalAmtDue: roundOffAmt ? roundOftotalAmtDue.toString() : "0",
          isTotalDiscountAdded: addedDiscount,
          totalDiscountType: isPercentage ? "Percentage" : "FlatAmt",
          totalDiscountPercentage: isPercentage ? ctlDisc : "0",
          totalDiscountedAmount: discAmt.toStringAsFixed(2),
          totalTaxPercentage: totalApplyTax);

      var quotationData = json.encode(quotationModel.toJson());

      final pdfFile = await QuotationPDF().generate(
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
          quoteNumber,
          roundOffAmt ? rouoffValue : "0");

      return [quotationData, pdfFile];
    }
  }

  // Update Quotation
  Future<dynamic> updateQuotation({
    required String discountStatus,
    required String taxStatus,
    required CustomerModel customerModel,
    required BuildContext context,
    required List<ProductModel> productList,
    required List<TermsModel> termsList,
    required List<OtherchargesModel> otherChargeList,
    required bool roundOffAmt,
    required double totalAmtDue,
    required DateTime selectedDate,
    required String quoteNumber,
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

      var termsListString =
          json.encode(termsList.map((e) => e.toJson()).toList());

      QuotationModel quotationModel = QuotationModel(
          customerData: customerModelString,
          quotationDate: DateFormat('yyyy-MM-dd').format(selectedDate),
          quotationNo: quoteNumber,
          otherChargesData: otherChargeListString,
          productData: productListString,
          termsConditionData: termsListString,
          totalTax: totalTax.toString(),
          amtDue: totalAmtDue.toString(),
          roundOffAmt: roundOffAmt,
          roundOftotalAmtDue: roundOffAmt ? roundOftotalAmtDue.toString() : "0",
          isTotalDiscountAdded: addedDiscount,
          totalDiscountType: isPercentage ? "Percentage" : "FlatAmt",
          totalDiscountPercentage: isPercentage ? ctlDisc : "0",
          totalDiscountedAmount: discAmt.toStringAsFixed(2),
          totalTaxPercentage: totalApplyTax);

      var quotationData = json.encode(quotationModel.toJson());

      final pdfFile = await QuotationPDF().generate(
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
          quoteNumber,
          roundOffAmt ? rouoffValue : "0");

      return [quotationData, pdfFile];
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
    QuotationModel? quotationModel,
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
}
