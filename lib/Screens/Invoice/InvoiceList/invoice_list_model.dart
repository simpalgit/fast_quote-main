import 'dart:convert' as jsons;

import 'package:fast_quote/Utils/remote_urls.dart';

class InvoiceResponseModel {
  final bool? response;
  final List<InvoiceListModel>? data;
  final String? folder;

  InvoiceResponseModel({
    this.response,
    this.data,
    this.folder,
  });

  factory InvoiceResponseModel.fromJson(Map<String, dynamic> json) =>
      InvoiceResponseModel(
        response: json["response"],
        data: json["data"] == null
            ? []
            : List<InvoiceListModel>.from(
                json["data"]!.map((x) => InvoiceListModel.fromJson(x))),
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

class InvoiceListModel {
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

  InvoiceListModel({
    this.id,
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
  });

  factory InvoiceListModel.fromJson(Map<String, dynamic> json) {
    var decodeData = jsons.jsonDecode(json["data"]);
    var decodeCustData = jsons.jsonDecode(decodeData['customerData']);

    var pdfUrl = "${ReomteUrl.invoiceImagePath}/${json["invoice_pdf"]}";

    return InvoiceListModel(
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
        status: json["status"]);
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
