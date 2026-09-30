class EnquiryModel {
  final String enquiryNo;
  final String enquiryDate;
  final String customerData;
  final String productData;
  final String otherChargesData;
  final String termsConditionData;
  final String? settingDiscountType;
  final String? settingTaxType;
  final bool roundOffAmt;
  final String roundOftotalAmtDue;
  final String totalTax;
  final String? amtDue;
  final bool? isTotalDiscountAdded;
  final String? totalDiscountType;
  final String? totalDiscountPercentage;
  final String? totalDiscountedAmount;
  final String? totalTaxPercentage;

  EnquiryModel(
      {required this.customerData,
      required this.enquiryDate,
      required this.enquiryNo,
      required this.otherChargesData,
      required this.productData,
      required this.termsConditionData,
      required this.roundOffAmt,
      required this.amtDue,
      required this.totalTax,
      required this.roundOftotalAmtDue,
      this.isTotalDiscountAdded,
      this.totalDiscountType,
      this.totalDiscountPercentage,
      this.totalDiscountedAmount,
      this.totalTaxPercentage,
      this.settingDiscountType,
      this.settingTaxType});

  factory EnquiryModel.fromJson(Map<String, dynamic> json) => EnquiryModel(
        customerData: json['customerData'],
        enquiryDate: json['enquiryDate'],
        enquiryNo: json['enquiryNo'],
        otherChargesData: json['otherChargesData'],
        productData: json['productData'],
        termsConditionData: json['termsConditionData'],
        settingDiscountType: json['settingDiscountType'],
        settingTaxType: json['settingTaxType'],
        totalTax: json['totalTax'],
        amtDue: json['amtDue'],
        roundOffAmt: json['roundOffAmt'],
        roundOftotalAmtDue: json['roundOftotalAmtDue'],
        isTotalDiscountAdded: false,
        totalDiscountType: "Percentage",
        totalDiscountPercentage: "0",
        totalDiscountedAmount: "0",
        totalTaxPercentage: "0",
      );

  Map<String, dynamic> toJson() => {
        "enquiryNo": enquiryNo,
        "enquiryDate": enquiryDate,
        "customerData": customerData,
        "productData": productData,
        "otherChargesData": otherChargesData,
        "termsConditionData": termsConditionData,
        "settingDiscountType": settingDiscountType,
        "settingTaxType": settingTaxType,
        "totalTax": totalTax,
        "amtDue": amtDue,
        "roundOffAmt": roundOffAmt,
        "roundOftotalAmtDue": roundOftotalAmtDue,
        "isTotalDiscountAdded": isTotalDiscountAdded,
        "totalDiscountType": totalDiscountType,
        "totalDiscountPercentage": totalDiscountPercentage,
        "totalDiscountedAmount": totalDiscountedAmount,
        "totalTaxPercentage": totalTaxPercentage,
      };
}

class QuotationModel {
  final String? quotationNo;
  final String? quotationDate;
  final String? customerData;
  final String? productData;
  final String? otherChargesData;
  final String? termsConditionData;
  final String? settingDiscountType;
  final String? settingTaxType;
  final bool? roundOffAmt;
  final String? roundOftotalAmtDue;
  final String? totalTax;

  final String? amtDue;
  final bool? isTotalDiscountAdded;
  final String? totalDiscountType;
  final String? totalDiscountPercentage;
  final String? totalDiscountedAmount;
  final String? totalTaxPercentage;

  QuotationModel(
      {this.customerData,
      this.quotationDate,
      this.quotationNo,
      this.otherChargesData,
      this.productData,
      this.termsConditionData,
      this.settingDiscountType,
      this.settingTaxType,
      this.totalTax,
      this.amtDue,
      this.roundOffAmt,
      this.roundOftotalAmtDue,
      this.isTotalDiscountAdded = false,
      this.totalDiscountType,
      this.totalDiscountPercentage,
      this.totalDiscountedAmount,
      this.totalTaxPercentage});

  factory QuotationModel.fromJson(Map<String, dynamic> json) => QuotationModel(
        customerData: json['customerData'],
        quotationDate: json['quotationDate'],
        quotationNo: json['quotationNo'],
        otherChargesData: json['otherChargesData'],
        productData: json['productData'],
        termsConditionData: json['termsConditionData'],
        settingDiscountType: json['settingDiscountType'],
        settingTaxType: json['settingTaxType'],
        totalTax: json['totalTax'],
        amtDue: json['amtDue'],
        roundOffAmt: json['roundOffAmt'],
        roundOftotalAmtDue: json['roundOftotalAmtDue'],
        isTotalDiscountAdded: json['isTotalDiscountAdded'],
        totalDiscountType: json['totalDiscountType'],
        totalDiscountPercentage: json['totalDiscountPercentage'],
        totalDiscountedAmount: json['totalDiscountedAmount'],
        totalTaxPercentage: json['totalTaxPercentage'],
      );

  Map<String, dynamic> toJson() => {
        "quotationNo": quotationNo,
        "quotationDate": quotationDate,
        "customerData": customerData,
        "productData": productData,
        "otherChargesData": otherChargesData,
        "termsConditionData": termsConditionData,
        "settingDiscountType": settingDiscountType,
        "settingTaxType": settingTaxType,
        "totalTax": totalTax,
        "amtDue": amtDue,
        "roundOffAmt": roundOffAmt,
        "roundOftotalAmtDue": roundOftotalAmtDue,
        "isTotalDiscountAdded": isTotalDiscountAdded,
        "totalDiscountType": totalDiscountType,
        "totalDiscountPercentage": totalDiscountPercentage,
        "totalDiscountedAmount": totalDiscountedAmount,
        "totalTaxPercentage": totalTaxPercentage,
      };
}

class InvoiceModel {
  final String? invoiceNo;
  final String? invoiceDate;
  String? customerData;
  final String? productData;
  final String? otherChargesData;
  final String? termsConditionData;
  final String? settingDiscountType;
  final String? settingTaxType;
  final bool? roundOffAmt;
  final String? roundOftotalAmtDue;
  final String? totalTax;
  final String? amtDue;
  final bool? isTotalDiscountAdded;
  final String? totalDiscountType;
  final String? totalDiscountPercentage;
  final String? totalDiscountedAmount;
  final String? totalTaxPercentage;
  final String? dueDate;
  final String? poNumber;
  final String? paidInfoListData;
  String? quoteInvSettingData;
  final String? businessData;

  set newCustomerData(String data) {
    customerData = data;
  }

  set newSettingData(String data) {
    quoteInvSettingData = data;
  }

  InvoiceModel({
    this.customerData,
    this.invoiceDate,
    this.invoiceNo,
    this.otherChargesData,
    this.productData,
    this.termsConditionData,
    this.settingDiscountType,
    this.settingTaxType,
    this.totalTax,
    this.amtDue,
    this.roundOffAmt,
    this.roundOftotalAmtDue,
    this.isTotalDiscountAdded = false,
    this.totalDiscountType,
    this.totalDiscountPercentage,
    this.totalDiscountedAmount,
    this.totalTaxPercentage,
    this.dueDate,
    this.poNumber,
    this.paidInfoListData,
    this.businessData,
    this.quoteInvSettingData,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        customerData: json['customerData'],
        invoiceDate: json['invoiceDate'],
        invoiceNo: json['invoiceNo'],
        otherChargesData: json['otherChargesData'],
        productData: json['productData'],
        termsConditionData: json['termsConditionData'],
        settingDiscountType: json['settingDiscountType'],
        settingTaxType: json['settingTaxType'],
        totalTax: json['totalTax'],
        amtDue: json['amtDue'],
        roundOffAmt: json['roundOffAmt'],
        roundOftotalAmtDue: json['roundOftotalAmtDue'],
        isTotalDiscountAdded: json['isTotalDiscountAdded'],
        totalDiscountType: json['totalDiscountType'],
        totalDiscountPercentage: json['totalDiscountPercentage'],
        totalDiscountedAmount: json['totalDiscountedAmount'],
        totalTaxPercentage: json['totalTaxPercentage'],
        dueDate: json['dueDate'],
        poNumber: json['poNumber'],
        paidInfoListData: json['paidInfoListData'],
        quoteInvSettingData: json['quoteInvSettingData'],
        businessData: json['businessData'],
      );

  Map<String, dynamic> toJson() => {
        "invoiceNo": invoiceNo,
        "invoiceDate": invoiceDate,
        "customerData": customerData,
        "productData": productData,
        "otherChargesData": otherChargesData,
        "termsConditionData": termsConditionData,
        "settingDiscountType": settingDiscountType,
        "settingTaxType": settingTaxType,
        "totalTax": totalTax,
        "amtDue": amtDue,
        "roundOffAmt": roundOffAmt,
        "roundOftotalAmtDue": roundOftotalAmtDue,
        "isTotalDiscountAdded": isTotalDiscountAdded,
        "totalDiscountType": totalDiscountType,
        "totalDiscountPercentage": totalDiscountPercentage,
        "totalDiscountedAmount": totalDiscountedAmount,
        "totalTaxPercentage": totalTaxPercentage,
        "dueDate": dueDate,
        "poNumber": poNumber,
        "paidInfoListData": paidInfoListData,
        "quoteInvSettingData": quoteInvSettingData,
        "businessData": businessData,
      };
}
