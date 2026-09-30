import 'dart:convert';

import 'package:fast_quote/Utils/common_functions.dart';
import 'package:flutter/cupertino.dart';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  final String? id;
  final String? productName;
  final String? productPrice;
  final String? productQuantity;
  String? productTotal;
  final String? productUnit;
  String? productGST;
  String? productAppliedGST;
  String? productTaxAmount;
  final String? productDescription;
  final String? productHSNnumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool? isDiscount;
  String? discountType;
  String? discountPercentage;
  String? discountAmt;

  ProductModel(
      {this.id,
      this.productName,
      this.productPrice,
      this.productQuantity,
      this.productTotal,
      this.productUnit,
      this.productGST,
      this.productAppliedGST,
      this.productTaxAmount,
      this.productDescription,
      this.productHSNnumber,
      this.createdAt,
      this.updatedAt,
      this.isDiscount,
      this.discountType,
      this.discountPercentage,
      this.discountAmt});

  set clearTaxDiscValue(bool val) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"].toString(),
        productName: json["name"] ?? "",
        productPrice: json["price"] ?? "",
        productUnit: json["unit"] ?? "",
        productGST: json["gst"] ?? "",
        productQuantity: json["productQuantity"] ?? "",
        productTotal: json["productTotal"] ?? "",
        productAppliedGST: json["productAppliedGST"] ?? "",
        productTaxAmount: json["productTaxAmount"] ?? "",
        productDescription: json["description"] ?? "",
        productHSNnumber: json["hsn_number"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isDiscount: json['isDiscount'] ?? false,
        discountType: json['discountType'] ?? "Percentage",
        discountPercentage: json['discountPercentage'] ?? "0",
        discountAmt: json['discountAmt'] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": productName,
        "price": productPrice,
        "productQuantity": productQuantity,
        "productTotal": productTotal,
        "productAppliedGST": productAppliedGST,
        "productTaxAmount": productTaxAmount,
        "unit": productUnit,
        "gst": productGST,
        "description": productDescription,
        "hsn_number": productHSNnumber,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "isDiscount": isDiscount,
        "discountType": discountType,
        "discountPercentage": discountPercentage,
        "discountAmt": discountAmt,
      };

//----------------------------------------------------------------------
  // EnquiryToQuotation

  set discNoDiscTaxNoTaxEnqToQuote(bool val) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  set discNoDiscTaxPerItemEnqToQuote(bool val) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    var amount = CommonFunctions.getAmountForTax(
        productGST!, double.parse(productTotal!));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

  set discNoDisctaxOnTotalEnqToQuote(bool val) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  set discPerItemTaxNoTaxEnqToQuote(BuildContext context) {
    isDiscount = false;
    discountType = "Percentage";
    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  set discPerItemTaxPerItemEnqToQuote(BuildContext context) {
    discountType = "Percentage";
    discountPercentage = "0";
    discountAmt = "0.00";
    productTaxAmount = CommonFunctions.discountOnPercentage(
            context, discountPercentage!, double.parse(productTotal!))
        .toString();

    var subAmount =
        (double.parse(productTotal!) - double.parse(productTaxAmount!))
            .toString();
    var amount = CommonFunctions.getAmountForTax(
        productGST!,
        subAmount == "0" || subAmount == "0.0"
            ? double.parse(productTotal!)
            : double.parse(subAmount));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

  set discPerItemTaxOnTotalEnqToQuote(BuildContext context) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  set discOnTotalTaxNoTaxEnqToQuote(BuildContext context) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  set discOnTotalTaxPerItemEnqToQuote(BuildContext context) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    var amount = CommonFunctions.getAmountForTax(
        productGST!, double.parse(productTotal!));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

  set discOnTotalTaxOnTotalEnqToQuote(BuildContext context) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  // --------------------------------------------------------------------------------------------------------------
  // QuotationToQuotation
  set discNoDiscTaxNoTaxQuotation(bool val) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  set discNoDiscTaxPerItemQuotation(bool val) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    var amount = CommonFunctions.getAmountForTax(
        productGST!, double.parse(productTotal!));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

  set discNoDisctaxOnTotalQuotation(bool val) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  set discPerItemTaxNoTaxQuotation(BuildContext context) {
    productGST = "0";
    productAppliedGST = "0";

    if (discountType == "Percentage") {
      productTaxAmount = CommonFunctions.discountOnPercentageFunction(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    } else {
      productTaxAmount = CommonFunctions.discountOnFlatFunction(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    }
  }

  set discPerItemTaxPerItemQuotation(BuildContext context) {
    if (discountType == "Percentage") {
      productTaxAmount = CommonFunctions.discountOnPercentageFunction(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    } else {
      productTaxAmount = CommonFunctions.discountOnFlatFunction(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    }

    var subAmount =
        (double.parse(productTotal!) - double.parse(productTaxAmount!))
            .toString();

    var amount = CommonFunctions.getAmountForTax(
        productGST!,
        subAmount == "0" || subAmount == "0.0"
            ? double.parse(productTotal!)
            : double.parse(subAmount));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

  set discPerItemTaxOnTotalQuotation(BuildContext context) {
    productGST = "0";
    productAppliedGST = "0";

    if (discountType == "Percentage") {
      productTaxAmount = CommonFunctions.discountOnPercentageFunction(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    } else {
      productTaxAmount = CommonFunctions.discountOnFlatFunction(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    }
  }

  set discOnTotalTaxNoTaxQuotation(BuildContext context) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  set discOnTotalTaxPerItemQuotation(BuildContext context) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    var amount = CommonFunctions.getAmountForTax(
        productGST!, double.parse(productTotal!));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

  set discOnTotalTaxOnTotalQuotation(BuildContext context) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";

    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }

  // --------------------------------------------------------------------------------------------------------------

  set discPerItemNoTaxOrTaxOnTotal(BuildContext context) {
    discountType = "Percentage";
    discountPercentage = "0";
    discountAmt = "0.00";
    productTaxAmount = CommonFunctions.discountOnPercentageFunction(
            context, discountPercentage!, double.parse(productTotal!))
        .toString();
  }

  set discTaxPerItem(BuildContext context) {
    discountType = "Percentage";
    discountPercentage = "0";
    discountAmt = "0.00";
    productTaxAmount = CommonFunctions.discountOnPercentage(
            context, discountPercentage!, double.parse(productTotal!))
        .toString();

    var subAmount =
        (double.parse(productTotal!) - double.parse(productTaxAmount!))
            .toString();
    var amount =
        CommonFunctions.getAmountForTax(productGST!, double.parse(subAmount));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

//----------------------------------------------------------------------

  // QuotationSaveAsTemplate

  set discPerItemNoTax(BuildContext context) {
    isDiscount = false;
    productGST = "0";
    productAppliedGST = "0";
    if (discountType == "Percentage") {
      productTaxAmount = CommonFunctions.discountOnPercentageFunction(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    } else {
      productTaxAmount = CommonFunctions.discountOnFlatFunction(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    }
  }

  set quotationDiscTaxPerItem(BuildContext context) {
    if (discountType == "Percentage") {
      productTaxAmount = CommonFunctions.discountOnPercentage(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    } else {
      productTaxAmount = CommonFunctions.discountOnFlatFunction(
              context, discountAmt!, double.parse(productTotal!))
          .toString();
    }

    var subAmount =
        (double.parse(productTotal!) - double.parse(productTaxAmount!))
            .toString();
    var amount =
        CommonFunctions.getAmountForTax(productGST!, double.parse(subAmount));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

  //----------------------------------------------------------------------
  set clearDiscValue(bool val) {
    isDiscount = false;
    discountType = "Percentage";
    discountAmt = "0";
    discountPercentage = "0";
  }

  set minusDisc(BuildContext context) {
    // productTaxAmount =
    //     (double.parse(productTotal!) - double.parse(discountAmt!)).toString();

    if (discountType == "Percentage") {
      productTaxAmount = CommonFunctions.discountOnPercentageFunction(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    } else {
      productTaxAmount = CommonFunctions.discountOnFlatFunction(
              context, discountAmt!, double.parse(productTotal!))
          .toString();
    }
  }

  set minusTax(bool val) {
    var amount = CommonFunctions.getAmountForTax(
        productGST!, double.parse(productTotal!));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

  set minusDiscTax(BuildContext context) {
    if (discountType == "Percentage") {
      productTaxAmount = CommonFunctions.discountOnPercentage(
              context, discountPercentage!, double.parse(productTotal!))
          .toString();
    } else {
      productTaxAmount = CommonFunctions.discountOnFlatFunction(
              context, discountAmt!, double.parse(productTotal!))
          .toString();
    }

    var subAmount =
        (double.parse(productTotal!) - double.parse(productTaxAmount!))
            .toString();
    var amount =
        CommonFunctions.getAmountForTax(productGST!, double.parse(subAmount));
    productTaxAmount = amount[0].toString();
    productAppliedGST = amount[1].toString();
  }

  set clearTaxValue(bool val) {
    isDiscount = false;
    productGST = "0";
    productAppliedGST = "0";
    productTaxAmount = productTotal;
  }
}
