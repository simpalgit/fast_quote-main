import 'dart:convert' as jsons;

import 'package:fast_quote/Utils/remote_urls.dart';

class QuotationResponseModel {
  final bool? response;
  final List<QuotationListModel>? data;
  final String? folder;

  QuotationResponseModel({
    this.response,
    this.data,
    this.folder,
  });

  factory QuotationResponseModel.fromJson(Map<String, dynamic> json) =>
      QuotationResponseModel(
        response: json["response"],
        data: json["data"] == null
            ? []
            : List<QuotationListModel>.from(
                json["data"]!.map((x) => QuotationListModel.fromJson(x))),
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

class QuotationListModel {
  final int? id;
  final int? userId;
  final dynamic invoicePdf;

  final String? data;
  final String? isTemplate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? quotationNum;
  final String? quotationDate;
  final String? quotationTotal;
  final String? customerName;
  final String? companyName;

  QuotationListModel({
    this.id,
    this.userId,
    this.invoicePdf,
    this.data,
    this.isTemplate,
    this.createdAt,
    this.updatedAt,
    this.quotationNum,
    this.quotationDate,
    this.quotationTotal,
    this.customerName,
    this.companyName,
  });

  factory QuotationListModel.fromJson(Map<String, dynamic> json) {
    var decodeData = jsons.jsonDecode(json["data"]);
    var decodeCustData = jsons.jsonDecode(decodeData['customerData']);

    var pdfUrl = "${ReomteUrl.quotationImagePath}/${json["invoice_pdf"]}";

    return QuotationListModel(
      id: json["id"] ?? '',
      userId: json["user_id"] ?? '',
      invoicePdf: pdfUrl,
      data: json["data"] ?? '',
      isTemplate: json["is_template"].toString(),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      quotationNum: decodeData['quotationNo'] ?? '',
      quotationDate: decodeData['quotationDate'],
      quotationTotal: decodeData['amtDue'] ?? '',
      customerName: decodeCustData['name'] ?? '',
      companyName: decodeCustData['company'] ?? '',
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
