import 'dart:convert' as jsons;

import 'package:fast_quote/Utils/remote_urls.dart';

class EnquiryResponseModel {
  final bool? response;
  final List<EnquiryListModel>? data;
  final String? folder;

  EnquiryResponseModel({
    this.response,
    this.data,
    this.folder,
  });

  factory EnquiryResponseModel.fromJson(Map<String, dynamic> json) =>
      EnquiryResponseModel(
        response: json["response"],
        data: json["data"] == null
            ? []
            : List<EnquiryListModel>.from(
                json["data"]!.map((x) => EnquiryListModel.fromJson(x))),
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

class EnquiryListModel {
  final int? id;
  final int? userId;
  final dynamic invoicePdf;

  final String? data;
  final String? isTemplate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? enquiryNum;
  final String? enquiryDate;
  final String? amtDue;
  final String? customerName;
  final String? companyName;

  EnquiryListModel({
    this.id,
    this.userId,
    this.invoicePdf,
    this.data,
    this.isTemplate,
    this.createdAt,
    this.updatedAt,
    this.enquiryNum,
    this.enquiryDate,
    this.amtDue,
    this.customerName,
    this.companyName,
  });

  factory EnquiryListModel.fromJson(Map<String, dynamic> json) {
    var decodeData = jsons.jsonDecode(json["data"]);
    var decodeCustData = jsons.jsonDecode(decodeData['customerData']);

    var pdfUrl = "${ReomteUrl.enquiryImagePath}/${json["invoice_pdf"]}";

    return EnquiryListModel(
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
      enquiryNum: decodeData['enquiryNo'] ?? '',
      enquiryDate: decodeData['enquiryDate'] ?? '',
      amtDue: decodeData['amtDue'] ?? '',
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
