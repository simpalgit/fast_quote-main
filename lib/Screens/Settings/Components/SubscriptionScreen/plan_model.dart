import 'dart:convert';

import 'package:flutter/material.dart';

class PlanModal {
  String? title;
  String? subTitle;
  String? currency;
  String? price;
  String? period;
  bool? isAvailable;
  bool? isImportant;
  String? image;
  String? planPriceSubTitle;
  Color? containerColor;
  Color? iconColor;
  bool? isVisible;
  Color? planTitleColor;
  String? priceLinthroughTitle;

  List<PlanModal>? optionList;

  IconData? icon;

  PlanModal(
      {this.title,
      this.subTitle,
      this.currency,
      this.price,
      this.period,
      this.planPriceSubTitle,
      this.isAvailable,
      this.isImportant,
      this.image,
      this.containerColor,
      this.iconColor,
      this.isVisible,
      this.planTitleColor,
      this.optionList,
      this.icon,
      this.priceLinthroughTitle});
}

class GetSubscriptionModel {
  final bool? response;
  final List<SubscriptionModel>? data;

  GetSubscriptionModel({
    this.response,
    this.data,
  });

  factory GetSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      GetSubscriptionModel(
        response: json["response"],
        data: json["data"] == null
            ? []
            : List<SubscriptionModel>.from(
                json["data"]!.map((x) => SubscriptionModel.fromJson(
                      x,
                    ))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SubscriptionModel {
  final int? id;
  final String? title;
  final List? benefits;
  final int? cost;
  final int? offerCost;
  final DateTime? createdAt;
  final dynamic updatedAt;
  bool? isExpanded;
  String? selectedIndex;
  String? initSelectedIndex;
  // final String? startDate;
  // final String? endDate;

  SubscriptionModel(
      {this.id,
      this.title,
      // this.startDate,
      // this.endDate,
      this.benefits,
      this.cost,
      this.offerCost,
      this.createdAt,
      this.updatedAt,
      this.isExpanded,
      this.initSelectedIndex,
      this.selectedIndex});

  set selIndex(int index) {
    selectedIndex = index.toString();
  }

  factory SubscriptionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    List<String> benefitList = [];

    benefitList = json["benefits"].toString().split("|");

    return SubscriptionModel(
        id: json["id"],
        title: json["title"],
        // startDate: startDate,
        // endDate: endDate,
        benefits: benefitList,
        cost: json["cost"],
        offerCost: json["offer_cost"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        isExpanded: false,
        initSelectedIndex: "0",
        selectedIndex: "0");
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        // "start_date": startDate,
        // "end_date": endDate,

        "benefits": benefits,
        "cost": cost,
        "offer_cost": offerCost,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
      };
}

class InitPaymentModel {
  final bool? success;
  final String? code;
  final String? message;
  final InitPaymentData? data;

  InitPaymentModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory InitPaymentModel.fromJson(Map<String, dynamic> json) =>
      InitPaymentModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : InitPaymentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class InitPaymentData {
  final String? merchantId;
  final String? merchantTransactionId;
  final InstrumentResponse? instrumentResponse;

  InitPaymentData({
    this.merchantId,
    this.merchantTransactionId,
    this.instrumentResponse,
  });

  factory InitPaymentData.fromJson(Map<String, dynamic> json) =>
      InitPaymentData(
        merchantId: json["merchantId"],
        merchantTransactionId: json["merchantTransactionId"],
        instrumentResponse: json["instrumentResponse"] == null
            ? null
            : InstrumentResponse.fromJson(json["instrumentResponse"]),
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "merchantTransactionId": merchantTransactionId,
        "instrumentResponse": instrumentResponse?.toJson(),
      };
}

class InstrumentResponse {
  final String? type;
  final RedirectInfo? redirectInfo;

  InstrumentResponse({
    this.type,
    this.redirectInfo,
  });

  factory InstrumentResponse.fromJson(Map<String, dynamic> json) =>
      InstrumentResponse(
        type: json["type"],
        redirectInfo: json["redirectInfo"] == null
            ? null
            : RedirectInfo.fromJson(json["redirectInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "redirectInfo": redirectInfo?.toJson(),
      };
}

class RedirectInfo {
  final String? url;
  final String? method;

  RedirectInfo({
    this.url,
    this.method,
  });

  factory RedirectInfo.fromJson(Map<String, dynamic> json) => RedirectInfo(
        url: json["url"],
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "method": method,
      };
}

class CheckPaymentModel {
  final bool? success;
  final String? code;
  final String? message;
  final SuccessData? data;

  CheckPaymentModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory CheckPaymentModel.fromJson(Map<String, dynamic> json) =>
      CheckPaymentModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : json["code"] == "PAYMENT_PENDING" ||
                    json["code"] == "PAYMENT_SUCCESS"
                ? SuccessData.fromSuccessJson(json["data"])
                : SuccessData.fromFailedJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class SuccessData {
  final String? merchantId;
  final String? merchantTransactionId;
  final String? transactionId;
  final int? amount;
  final String? state;
  final String? responseCode;
  final String? responseCodeDescription;
  final String? paymentInstrument;

  SuccessData({
    this.merchantId,
    this.merchantTransactionId,
    this.transactionId,
    this.amount,
    this.state,
    this.responseCode,
    this.responseCodeDescription,
    this.paymentInstrument,
  });

  factory SuccessData.fromSuccessJson(Map<String, dynamic> jsons) =>
      SuccessData(
        merchantId: jsons["merchantId"],
        merchantTransactionId: jsons["merchantTransactionId"],
        transactionId: jsons["transactionId"] ?? "",
        amount: jsons["amount"],
        state: jsons["state"],
        responseCode: jsons["responseCode"] ?? "",
        responseCodeDescription: "",
        paymentInstrument: json.encode(jsons["paymentInstrument"]),
      );

  factory SuccessData.fromFailedJson(Map<String, dynamic> json) => SuccessData(
      merchantId: json["merchantId"],
      merchantTransactionId: json["merchantTransactionId"],
      transactionId: json["transactionId"] ?? "",
      amount: json["amount"],
      state: json["state"],
      responseCode: json["responseCode"] ?? "",
      responseCodeDescription: json["responseCodeDescription"],
      paymentInstrument: json["paymentInstrument"] ?? "");

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "merchantTransactionId": merchantTransactionId,
        "transactionId": transactionId,
        "amount": amount,
        "state": state,
        "responseCode": responseCode,
        "paymentInstrument": paymentInstrument,
      };
}
