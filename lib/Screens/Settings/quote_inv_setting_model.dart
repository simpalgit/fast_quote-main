class QuoteInvSettingModel {
  final String? id;
  final String? prefix;
  final String? serialNo;
  final String? discount;
  final String? tax;
  final String? product;
  String? topMessage;
  String? bottomMsg;
  final String? bankDetails;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  set setTopMessage(String message) {
    topMessage = message;
  }

  set setBottomMessage(String message) {
    bottomMsg = message;
  }

  QuoteInvSettingModel({
    this.id,
    this.prefix,
    this.serialNo,
    this.discount,
    this.tax,
    this.product,
    this.topMessage,
    this.bottomMsg,
    this.bankDetails,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory QuoteInvSettingModel.fromJson(Map<String, dynamic> json) =>
      QuoteInvSettingModel(
        id: json["id"].toString(),
        prefix: json["prefix"],
        serialNo: json["serial_no"],
        discount: json["discount"],
        tax: json["tax"],
        product: json["product"],
        topMessage: json["top_message"],
        bottomMsg: json["bottom_msg"],
        bankDetails: json["bank_details"],
        userId: json["user_id"].toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prefix": prefix,
        "serial_no": serialNo,
        "discount": discount,
        "tax": tax,
        "product": product,
        "top_message": topMessage,
        "bottom_msg": bottomMsg,
        "bank_details": bankDetails,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class PDFInitiallizationNumber {
  int? enquiryNumber;
  int? quotationNumber;
  int? invoiceNumber;
  int? challanNumber;
  int? enquiryLength;
  int? quotationLength;
  int? invoiceLength;

  PDFInitiallizationNumber(
      {this.enquiryLength,
      this.quotationLength,
      this.invoiceLength,
      this.challanNumber,
      this.enquiryNumber,
      this.invoiceNumber,
      this.quotationNumber});

  factory PDFInitiallizationNumber.fromJson(Map<String, dynamic> json) {
    int enqNum = 0, quoteNum = 0, invNum = 0, challanNum = 0;
    if (json['data']["enquiries"] == 0) {
      enqNum = 1;
    } else {
      enqNum = json['data']["enquiries"];
    }

    if (json['data']["quotation_mains"] == 0) {
      quoteNum = 1;
    } else {
      quoteNum = json['data']["quotation_mains"];
    }

    if (json['data']["invoice_mains"] == 0) {
      invNum = 1;
    } else {
      invNum = json['data']["invoice_mains"];
    }

    if (json['data']["challans"] == 0) {
      challanNum = 1;
    } else {
      challanNum = json['data']["challans"];
    }

    return PDFInitiallizationNumber(
      enquiryLength: json['enquiry'] ?? 0,
      quotationLength: json['quatation'] ?? 0,
      invoiceLength: json['invoice'] ?? 0,
      enquiryNumber: enqNum,
      quotationNumber: quoteNum,
      invoiceNumber: invNum,
      challanNumber: challanNum,
    );
  }
}
