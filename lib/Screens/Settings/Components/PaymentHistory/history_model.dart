import 'package:flutter/material.dart';

class HistoryModel {
  final int? id;
  final int? userId;
  final int? subId;
  final String? code;
  final String? merchantTransactionId;
  final String? transactionId;
  final String? amount;
  final String? state;
  final String? responseCode;
  final String? responseCodeDescription;
  final String? paymentDate;
  final String? subscriptionName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Color? cardColor;

  HistoryModel(
      {this.id,
      this.userId,
      this.subId,
      this.code,
      this.merchantTransactionId,
      this.transactionId,
      this.amount,
      this.state,
      this.responseCode,
      this.responseCodeDescription,
      this.subscriptionName,
      this.paymentDate,
      this.createdAt,
      this.updatedAt,
      this.cardColor});

  factory HistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    Color passedColor = Colors.white;
    if (json["state"] == "COMPLETED") {
      passedColor = Colors.green;
    } else if (json["state"] == "FAILED") {
      passedColor = Colors.red;
    } else {
      passedColor = Colors.amber;
    }
    return HistoryModel(
        id: json["id"],
        userId: json["user_id"],
        subId: json["sub_id"],
        code: json["code"],
        merchantTransactionId: json["merchantTransactionId"],
        transactionId: json["transactionId"] ?? "",
        amount: json["amount"],
        state: json["state"],
        responseCode: json["responseCode"] ?? "",
        responseCodeDescription: json["responseCodeDescription"],
        paymentDate: json["paymentDate"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        cardColor: passedColor,
        subscriptionName: json["subscription"]["title"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "sub_id": subId,
        "code": code,
        "merchantTransactionId": merchantTransactionId,
        "transactionId": transactionId,
        "amount": amount,
        "state": state,
        "responseCode": responseCode,
        "responseCodeDescription": responseCodeDescription,
        "paymentDate": paymentDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
