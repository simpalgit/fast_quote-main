import 'dart:convert' as jsons;

import 'package:fast_quote/Utils/remote_urls.dart';

class ChallanResponseModel {
  final bool? response;
  final List<ChallanListModel>? data;
  final String? folder;

  ChallanResponseModel({
    this.response,
    this.data,
    this.folder,
  });

  factory ChallanResponseModel.fromJson(Map<String, dynamic> json) =>
      ChallanResponseModel(
        response: json["response"],
        data: json["data"] == null
            ? []
            : List<ChallanListModel>.from(
                json["data"]!.map((x) => ChallanListModel.fromJson(x))),
        folder: json["folder"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "folder": folder,
      };
}

class ChallanListModel {
  final int? id;
  final int? userId;
  final dynamic invoicePdf;
  final String? data;
  final String? isTemplate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? invoiceNum;
  final String? invoiceDate;
  final String? invoiceTotal;
  final String? customerName;
  final String? companyName;
  final String? status;
  final String? customerPhone;
  final String? customerAddress;
  final String? topMessage;
  final String? bottomMessage;
  final String? shippingAddress;

  ChallanListModel(
      {this.id,
      this.userId,
      this.invoicePdf,
      this.data,
      this.isTemplate,
      this.createdAt,
      this.updatedAt,
      this.invoiceNum,
      this.invoiceDate,
      this.invoiceTotal,
      this.customerName,
      this.companyName,
      this.status,
      this.bottomMessage,
      this.customerAddress,
      this.customerPhone,
      this.topMessage,
      this.shippingAddress});

  factory ChallanListModel.fromJson(Map<String, dynamic> json) {
    var decodeData = jsons.jsonDecode(json["data"]);
    var decodeCustData = jsons.jsonDecode(decodeData['customerData']);

    var decodeQuoteInv = jsons.jsonDecode(decodeData['quoteInvSettingData']);

    print(decodeQuoteInv);

    var pdfUrl = "${ReomteUrl.challanImagePath}/${json["invoice_pdf"]}";

    return ChallanListModel(
      id: json["id"],
      userId: json["user_id"],
      invoicePdf: pdfUrl,
      data: json["data"],
      isTemplate: json["is_template"].toString(),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      invoiceNum: decodeData['invoiceNo'] ?? '',
      invoiceDate: decodeData['invoiceDate'] ?? '',
      invoiceTotal: decodeData['amtDue'] ?? '',
      customerName: decodeCustData['name'] ?? '',
      companyName: decodeCustData['company'] ?? '',
      status: json["status"],
      bottomMessage: decodeQuoteInv['bottom_msg'] ?? "",
      topMessage: decodeQuoteInv['top_message'] ?? "",
      shippingAddress: decodeCustData['shipping_address'] ?? "",
      customerAddress: decodeCustData['address_one'] ?? "",
      customerPhone: decodeCustData['mobile'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "invoice_pdf": invoicePdf,
        "data": data,
        "is_template": isTemplate,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
