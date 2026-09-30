import 'dart:convert';

import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Auth/other_charges_model.dart';
import '../Customer/customer_model.dart';
import '../Product/product_model.dart';
import '../Terms/terms_model.dart';
import 'CreateEnquiry/enquiry_model.dart';
import 'enquiry_pdf.dart';

class EnquiryHelper {
  List<dynamic> getEnquiryData(
      {required String enquiryData,
      required String from,
      required String enqNum}) {
    CustomerModel customerModel = CustomerModel();
    List<ProductModel> productList = [];
    List<OtherchargesModel> otherChargeList = [];
    List<TermsModel> termsList = [];
    String enqDate = "", enqNumber = "";
    bool roundOffAmt = false;
    double totalAmtDue = 0.0, totalTax = 0.0;
    var enquiryModel = EnquiryModel.fromJson(json.decode(enquiryData));

    customerModel =
        CustomerModel.fromJson(json.decode(enquiryModel.customerData));

    productList = json
        .decode(enquiryModel.productData)
        .map<ProductModel>((e) => ProductModel.fromJson(e))
        .toList();

    if (enquiryModel.otherChargesData != "[]") {
      otherChargeList = json
          .decode(enquiryModel.otherChargesData)
          .map<OtherchargesModel>((e) => OtherchargesModel.fromJson(e))
          .toList();
    } else {
      otherChargeList = [];
    }

    termsList = json
        .decode(enquiryModel.termsConditionData)
        .map<TermsModel>((e) => TermsModel.fromJson(e))
        .toList();

    enqDate = enquiryModel.enquiryDate;
    if (from == "template") {
      enqNumber = enqNum;
    } else {
      enqNumber = enquiryModel.enquiryNo;
    }

    roundOffAmt = enquiryModel.roundOffAmt;
    totalAmtDue = double.parse(enquiryModel.amtDue!);
    totalTax = double.parse(enquiryModel.totalTax);
    return [
      customerModel,
      productList,
      otherChargeList,
      termsList,
      enqDate,
      enqNumber,
      roundOffAmt,
      totalAmtDue,
      totalTax
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
  Future<List<ProductModel>> addProduct(
      BuildContext context, List<ProductModel> productList) async {
    var data = await Navigator.of(context).pushNamed(RouteNames.productScreen,
        arguments: {
          "from": "true",
          "fromPage": "Enquiry",
          "action": "Enquiry"
        });
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
  Future<List<ProductModel>> editProduct(BuildContext context,
      List<ProductModel> productList, ProductModel productModel) async {
    var data = await Navigator.of(context).pushNamed(
        RouteNames.addProductEnquiry,
        arguments: {"model": productModel});
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
        .pushNamed(RouteNames.enquiryTermsScreen, arguments: {
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

  //calculation Function
  List<dynamic> calculationFunction(
      {required int roundOftotalAmtDue,
      required double totalAmtDue,
      required double totalTax,
      required double subTotal,
      required double productTax,
      required List<OtherchargesModel> otherChargeList,
      required List<ProductModel> productList}) {
    roundOftotalAmtDue = totalAmtDue.toInt();
    totalTax = 0.0;
    totalAmtDue = 0.0;
    subTotal = 0.0;
    productTax = 0.0;

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
    if (productList.isNotEmpty) {
      for (var element in productList) {
        totalTax += double.parse(element.productAppliedGST!);
        totalAmtDue += double.parse(element.productTaxAmount!);
        subTotal += double.parse(element.productTaxAmount!);
        productTax += double.parse(element.productAppliedGST!);
      }
    }
    roundOftotalAmtDue = totalAmtDue.toInt();

    return [roundOftotalAmtDue, totalAmtDue, totalTax, subTotal, productTax];
  }

  // Create And Update Enquiry
  Future<dynamic> createEnquiry(
      CustomerModel customerModel,
      BuildContext context,
      List<ProductModel> productList,
      List<TermsModel> termsList,
      List<OtherchargesModel> otherChargeList,
      bool roundOffAmt,
      double totalAmtDue,
      DateTime selectedDate,
      String enqNum,
      int roundOftotalAmtDue,
      double totalTax,
      BusinessModel businessModel,
      double productTax,
      double subTotal) async {
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

      EnquiryModel enquiryModel = EnquiryModel(
          customerData: customerModelString,
          enquiryDate: DateFormat('yyyy-MM-dd').format(selectedDate),
          enquiryNo: enqNum,
          otherChargesData: otherChargeListString,
          productData: productListString,
          termsConditionData: termsListString,
          roundOffAmt: roundOffAmt,
          roundOftotalAmtDue: roundOffAmt ? roundOftotalAmtDue.toString() : "0",
          amtDue: totalAmtDue.toString(),
          totalTax: totalTax.toString(),
          isTotalDiscountAdded: false,
          totalDiscountType: "Percentage",
          totalDiscountPercentage: "0",
          totalDiscountedAmount: "0.0",
          totalTaxPercentage: "0",
          settingDiscountType: "",
          settingTaxType: "");

      var enquiryData = json.encode(enquiryModel.toJson());

      final pdfFile = await EnquiryPDF().generate(
          customerModel,
          productList,
          termsList,
          otherChargeList,
          businessModel,
          roundOffAmt
              ? roundOftotalAmtDue.toStringAsFixed(2)
              : totalAmtDue.toStringAsFixed(2),
          productTax.toString(),
          subTotal.toString(),
          enqNum,
          roundOffAmt ? rouoffValue : "0");

      return [enquiryData, pdfFile];
    }
  }
}
