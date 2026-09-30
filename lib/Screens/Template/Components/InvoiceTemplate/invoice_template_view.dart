import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Invoice/InvoiceList/invoice_list_model.dart';
import 'package:fast_quote/Screens/Invoice/invoice_repository.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';

import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceTemplateViewPage extends StatefulWidget {
  final File? file;
  final String invoiceData;
  final bool isSavedAsTemplate;
  final InvoiceListModel invoiceListModel;

  const InvoiceTemplateViewPage({
    Key? key,
    this.file,
    required this.invoiceData,
    required this.invoiceListModel,
    required this.isSavedAsTemplate,
  }) : super(key: key);

  @override
  InvoiceTemplateViewPageState createState() => InvoiceTemplateViewPageState();
}

class InvoiceTemplateViewPageState extends State<InvoiceTemplateViewPage> {
  Dio dio = Dio();
  File? pdfFile;

  InvoiceRepository invoiceRepository = InvoiceRepository();

  void showAlertDialouge() {
    showDialog(
        barrierColor: Colors.white.withOpacity(0.1),
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(12)),

              title: const Text(
                'Are you sure you want to delete Template ??',
                textAlign: TextAlign.center,
              ),
              // content: const Text('FilerBackDrop'),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: secondary),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No')),
                    SizedBox(
                      width: 30.w,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: secondary),
                        onPressed: () {
                          removeTemplate(context, widget.invoiceListModel);
                        },
                        child: const Text('Yes'))
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> removeTemplate(
      BuildContext context, InvoiceListModel invoiceListModel) async {
    CommonFunctions.showProgressBar(context);

    FormData formData = FormData.fromMap({
      "is_template": 0,
    });

    dynamic result;

    result = await invoiceRepository.updateInvoice(
        context, formData, invoiceListModel.id.toString());

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);

      Navigator.pop(context);
    }, (data) {
      if (data != null) {
        Navigator.pop(context);
        CommonFunctions.showSuccessSnackbar("Removed from Template");
        Navigator.of(context)
          ..pop()
          ..pop();
      }
    });
  }

  // deleteInvoice(BuildContext context, var invoiceModel) async {
  //   CommonFunctions.showProgressBar(context);

  //   var result = await invoiceRepository.deleteInvoice(
  //       context, invoiceModel.id!.toString());

  //   result.fold((error) {
  //     Navigator.pop(context);
  //     CommonFunctions.showErrorSnackbar(context, error.message);
  //   }, (data) {
  //     Navigator.of(context)
  //       ..pop()
  //       ..pop()
  //       ..pop();
  //     CommonFunctions.showSuccessSnackbar("Invoice deleted.");
  //   });
  // }

  Future<void> updateInvoice(BuildContext context, String jsonData,
      dynamic file, String status, String id) async {
    CommonFunctions.showProgressBar(context);

    FormData formData = FormData.fromMap({
      "data": jsonData,
      "is_template": 0,
      "invoice_reciept": await MultipartFile.fromFile(
        file.path,
      ),
      "status": status
    });

    var result = await invoiceRepository.updateInvoice(context, formData, id);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);

      Navigator.of(context)
        ..pop()
        ..pop();
    }, (data) {
      Navigator.of(context)
        ..pop()
        ..pop();
      if (data != null) {
        CommonFunctions.showSuccessSnackbar("Invoice Update.");
      }
    });
  }

  SettingsRepository settingsRepository = SettingsRepository();

  int challanLength = 0;

  Future getHomeData(BuildContext context) async {
    var result = await settingsRepository.getHomeData(context);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);

      Navigator.pop(context);
    }, (data) {
      challanLength = data.challanNumber!;
    });
  }

  Future<void> uploadChallan(
    BuildContext context,
    String jsonData,
    dynamic file,
  ) async {
    CommonFunctions.showProgressBar(context);

    FormData formData = FormData.fromMap({
      "data": jsonData,
      "invoice_reciept": await MultipartFile.fromFile(
        file.path,
      ),
    });

    var result = await invoiceRepository.addChallan(context, formData);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);

      Navigator.pop(context);
    }, (data) {
      if (data != null) {
        Navigator.pop(context);
        CommonFunctions.showSuccessSnackbar("Converted to Challan.");
        getHomeData(context);

        // InvoiceListModel modelData = InvoiceListModel.fromJson(resp['data']);
      }
    });
  }

  @override
  void initState() {
    getHomeData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: commonAppBar(
            onPressed: () {
              Navigator.of(context).pop();
            },
            elv: 3,
            context: context,
            heading: 'Invoice',
            widgetList: [
              IconButton(
                  onPressed: () {
                    showAlertDialouge();
                  },
                  icon: Icon(
                    CupertinoIcons.delete_solid,
                    color: secondary,
                  ))
            ]),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: PDFView(
                  filePath: widget.file!.path,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                margin: EdgeInsets.zero,
                color: bgColor,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: secondary))),
                  child: Row(
                    children: [
                      Expanded(
                        child: PdfBottomHelper(
                          assetName: "assets/images/document_duplicate.svg",
                          name: 'Use \nTemplate',
                          onTap: () {
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                              ..pushNamed(RouteNames.createInvoice, arguments: {
                                "invoiceData": widget.invoiceData,
                                "invoiceNo": "",
                                "from": "Template",
                              });
                          },
                          h: 28,
                          w: 28,
                        ),
                      ),
                      // Expanded(
                      //   child: PdfBottomHelper(
                      //     assetName: "assets/images/status.svg",
                      //     name: 'Invoice\nStatus',
                      //     h: 28,
                      //     w: 28,
                      //     onTap: () {
                      //       showModalBottomSheet(
                      //         context: context,
                      //         shape: const RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.only(
                      //           topLeft: Radius.circular(25),
                      //           topRight: Radius.circular(25),
                      //         )),
                      //         builder: (context) {
                      //           return Padding(
                      //             padding: const EdgeInsets.all(20.0),
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 Text(
                      //                   'Invoice Status',
                      //                   style: TextStyle(
                      //                       fontWeight: FontWeight.w500,
                      //                       fontSize: 15.sp),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 5.h,
                      //                 ),
                      //                 ListTile(
                      //                   title: const Text('Paid'),
                      //                   onTap: () {
                      //                     updateInvoice(
                      //                         context,
                      //                         widget.invoiceData,
                      //                         widget.file,
                      //                         "Paid",
                      //                         widget.invoiceListModel.id
                      //                             .toString());
                      //                   },
                      //                 ),
                      //                 ListTile(
                      //                   title: const Text('Unpaid'),
                      //                   onTap: () {
                      //                     updateInvoice(
                      //                         context,
                      //                         widget.invoiceData,
                      //                         widget.file,
                      //                         "Unpaid",
                      //                         widget.invoiceListModel.id
                      //                             .toString());
                      //                   },
                      //                 )
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                      // Expanded(
                      //   child: PdfBottomHelper(
                      //     assetName: "assets/images/document_convert.svg",
                      //     name: 'Convert to\nChallan',
                      //     h: 28,
                      //     w: 28,
                      //     onTap: () async {
                      //       // uploadInvoice(
                      //       //   context,
                      //       //   widget.invoiceData,
                      //       //   widget.file,
                      //       // );

                      //       double totalTax = 0.0;
                      //       int roundOftotal = 0;
                      //       double subTotal = 0.0;
                      //       double subTotalTax = 0.0;
                      //       double subTotalDiscount = 0.0;
                      //       double discAmt = 0.0;
                      //       double appliedTotalTaxAmt = 0.0;
                      //       double paidInfoAmt = 0.0;
                      //       double total = 0.0;

                      //       bool addedDiscount = false, isPercentage = false;

                      //       var invoiceModel = InvoiceModel.fromJson(
                      //           json.decode(widget.invoiceData));

                      //       QuoteInvSettingModel quoteInvSettingModel =
                      //           QuoteInvSettingModel.fromJson(json
                      //               .decode(invoiceModel.quoteInvSettingData!));

                      //       BusinessModel businessModel =
                      //           BusinessModel.fromConverChallanJson(
                      //               json.decode(invoiceModel.businessData!));

                      //       String discountStatus =
                      //           quoteInvSettingModel.discount!;
                      //       String taxStatus = quoteInvSettingModel.tax!;

                      //       CustomerModel customerModel =
                      //           CustomerModel.fromJson(
                      //               json.decode(invoiceModel.customerData!));

                      //       List<ProductModel> productList = json
                      //           .decode(invoiceModel.productData!)
                      //           .map<ProductModel>(
                      //               (e) => ProductModel.fromJson(e))
                      //           .toList();

                      //       List<TermsModel> termsList = json
                      //           .decode(invoiceModel.termsConditionData!)
                      //           .map<TermsModel>((e) => TermsModel.fromJson(e))
                      //           .toList();

                      //       String ctlDisc = "";
                      //       if (discountStatus == "On Total") {
                      //         addedDiscount =
                      //             invoiceModel.isTotalDiscountAdded!;
                      //         isPercentage =
                      //             invoiceModel.totalDiscountType == "Percentage"
                      //                 ? true
                      //                 : false;

                      //         ctlDisc =
                      //             invoiceModel.totalDiscountType == "Percentage"
                      //                 ? invoiceModel.totalDiscountPercentage!
                      //                 : invoiceModel.totalDiscountedAmount!;
                      //       } else {
                      //         addedDiscount = false;
                      //         isPercentage = false;
                      //         ctlDisc = "";
                      //         discAmt = 0.0;
                      //       }
                      //       List<OtherchargesModel> otherChargeList = [];
                      //       if (invoiceModel.otherChargesData != "[]") {
                      //         otherChargeList = json
                      //             .decode(invoiceModel.otherChargesData!)
                      //             .map<OtherchargesModel>(
                      //                 (e) => OtherchargesModel.fromJson(e))
                      //             .toList();
                      //       }

                      //       List<PaidInfoModel> paidInfoList = json
                      //           .decode(invoiceModel.paidInfoListData!)
                      //           .map<PaidInfoModel>(
                      //               (e) => PaidInfoModel.fromJson(e))
                      //           .toList();

                      //       String totalApplyTax =
                      //           invoiceModel.totalTaxPercentage!;
                      //       String ctlTotalTax =
                      //           invoiceModel.totalTaxPercentage!;

                      //       bool roundOffAmt = invoiceModel.roundOffAmt!;
                      //       double totalAmtDue =
                      //           double.parse(invoiceModel.amtDue!);
                      //       int roundOftotalAmtDue = totalAmtDue.toInt();

                      //       roundOftotalAmtDue = totalAmtDue.toInt();
                      //       totalAmtDue = 0.0;

                      //       if (productList.isNotEmpty) {
                      //         for (var element in productList) {
                      //           totalTax +=
                      //               double.parse(element.productAppliedGST!);
                      //           subTotalTax +=
                      //               double.parse(element.productAppliedGST!);
                      //           totalAmtDue +=
                      //               double.parse(element.productTaxAmount!);

                      //           subTotal +=
                      //               double.parse(element.productPrice!) *
                      //                   double.parse(element.productQuantity!);
                      //           if (element.discountAmt!.isEmpty) {
                      //             subTotalDiscount += double.parse("0");
                      //           } else {
                      //             subTotalDiscount +=
                      //                 double.parse(element.discountAmt!);
                      //           }
                      //         }
                      //       }

                      //       if (taxStatus == "On Total" &&
                      //           discountStatus == "On Total") {
                      //         if (ctlTotalTax.isEmpty) {
                      //           ctlTotalTax = "0";
                      //         }
                      //         if (ctlDisc.isEmpty) {
                      //           ctlDisc = "0";
                      //         }

                      //         if (isPercentage) {
                      //           discAmt = CommonFunctions
                      //               .discountOnPercentageFunction(
                      //                   context, ctlDisc, totalAmtDue);

                      //           totalAmtDue = totalAmtDue - discAmt;
                      //         } else {
                      //           discAmt =
                      //               CommonFunctions.discountOnFlatFunction(
                      //                   context, ctlDisc, totalAmtDue);
                      //         }
                      //         var tax = await CommonFunctions.getAmountForTax(
                      //             totalApplyTax, totalAmtDue);
                      //         appliedTotalTaxAmt = tax[1];
                      //         totalTax += tax[1];
                      //         totalAmtDue += tax[1];
                      //       } else {
                      //         if (taxStatus == "On Total") {
                      //           if (ctlTotalTax.isEmpty) {
                      //             ctlTotalTax = "0";
                      //           }

                      //           var tax = await CommonFunctions.getAmountForTax(
                      //               totalApplyTax, totalAmtDue);
                      //           appliedTotalTaxAmt = tax[1];
                      //           totalTax += tax[1];
                      //           totalAmtDue += tax[1];
                      //         } else if (discountStatus == "On Total") {
                      //           if (otherChargeList.isNotEmpty) {
                      //             for (var element in otherChargeList) {
                      //               totalAmtDue +=
                      //                   double.parse(element.amount!);

                      //               if (element.isTaxable!) {
                      //                 totalTax += double.parse(element.taxAmt!);
                      //                 totalAmtDue +=
                      //                     double.parse(element.taxAmt!);
                      //               } else {
                      //                 totalTax += 0.0;
                      //               }
                      //             }
                      //           }

                      //           if (ctlDisc.isEmpty) {
                      //             ctlDisc = "0";
                      //           }

                      //           if (isPercentage) {
                      //             discAmt = CommonFunctions
                      //                 .discountOnPercentageFunction(
                      //                     context, ctlDisc, totalAmtDue);
                      //           } else {
                      //             discAmt =
                      //                 CommonFunctions.discountOnFlatFunction(
                      //                     context, ctlDisc, totalAmtDue);
                      //           }
                      //           totalAmtDue = totalAmtDue - discAmt;
                      //         }
                      //       }

                      //       if (discountStatus != "On Total") {
                      //         if (otherChargeList.isNotEmpty) {
                      //           for (var element in otherChargeList) {
                      //             totalAmtDue += double.parse(element.amount!);
                      //             if (element.isTaxable!) {
                      //               totalTax += double.parse(element.taxAmt!);
                      //               totalAmtDue +=
                      //                   double.parse(element.taxAmt!);
                      //             } else {
                      //               totalTax += 0.0;
                      //             }
                      //           }
                      //         }
                      //       }

                      //       if (paidInfoList.isNotEmpty) {
                      //         paidInfoAmt = 0.0;
                      //         for (var element in paidInfoList) {
                      //           paidInfoAmt += element.amount!;
                      //         }
                      //         total = totalAmtDue;
                      //         totalAmtDue = totalAmtDue - paidInfoAmt;
                      //       }

                      //       roundOftotalAmtDue = totalAmtDue.toInt();
                      //       roundOftotal = total.toInt();

                      //       var customerModelString =
                      //           json.encode(customerModel.toJson());
                      //       String productListString;

                      //       if (discountStatus == "No Discount" &&
                      //           taxStatus == "No Tax") {
                      //         for (var element in productList) {
                      //           element.clearTaxDiscValue = true;
                      //         }
                      //         addedDiscount = false;
                      //         isPercentage = false;
                      //         discAmt = 0;
                      //         totalApplyTax = "0";
                      //         productListString = json.encode(
                      //             productList.map((e) => e.toJson()).toList());
                      //       } else if (discountStatus == "Per item" &&
                      //           taxStatus == "Per item") {
                      //         productListString = json.encode(
                      //             productList.map((e) => e.toJson()).toList());
                      //         addedDiscount = false;
                      //         isPercentage = false;
                      //         discAmt = 0;
                      //         totalApplyTax = "0";
                      //       } else if (discountStatus == "Per item" &&
                      //           (taxStatus == "No Tax" ||
                      //               taxStatus == "On Total")) {
                      //         for (var element in productList) {
                      //           element.clearTaxValue = true;
                      //         }
                      //         if (taxStatus == "No Tax") {
                      //           addedDiscount = false;
                      //           isPercentage = false;
                      //           discAmt = 0;
                      //           totalApplyTax = "0";
                      //         } else {
                      //           addedDiscount = false;
                      //           isPercentage = false;
                      //           discAmt = 0;
                      //         }
                      //         productListString = json.encode(
                      //             productList.map((e) => e.toJson()).toList());
                      //       } else if (taxStatus == "Per item" &&
                      //           (discountStatus == "No Discount" ||
                      //               discountStatus == "On Total")) {
                      //         for (var element in productList) {
                      //           element.clearDiscValue = true;
                      //         }
                      //         if (discountStatus == "No Discount") {
                      //           addedDiscount = false;
                      //           isPercentage = false;
                      //           discAmt = 0;
                      //           totalApplyTax = "0";
                      //         } else {
                      //           totalApplyTax = "0";
                      //         }
                      //         productListString = json.encode(
                      //             productList.map((e) => e.toJson()).toList());
                      //       } else if (discountStatus == "On Total" &&
                      //           (taxStatus == "On Total" ||
                      //               taxStatus == "No Tax")) {
                      //         for (var element in productList) {
                      //           element.clearTaxDiscValue = true;
                      //         }
                      //         if (taxStatus == "No Tax") {
                      //           addedDiscount = false;
                      //           isPercentage = false;
                      //           discAmt = 0;
                      //           totalApplyTax = "0";
                      //         } else {
                      //           addedDiscount = false;
                      //           isPercentage = false;
                      //           discAmt = 0;
                      //         }

                      //         productListString = json.encode(
                      //             productList.map((e) => e.toJson()).toList());
                      //       } else if (taxStatus == "On Total" &&
                      //           (discountStatus == "No Discount" ||
                      //               discountStatus == "On Total")) {
                      //         for (var element in productList) {
                      //           element.clearTaxDiscValue = true;
                      //         }
                      //         if (discountStatus == "No Discount") {
                      //           addedDiscount = false;
                      //           isPercentage = false;
                      //           discAmt = 0;
                      //           totalApplyTax = "0";
                      //         } else {
                      //           totalApplyTax = "0";
                      //         }
                      //         productListString = json.encode(
                      //             productList.map((e) => e.toJson()).toList());
                      //       } else {
                      //         productListString = json.encode(
                      //             productList.map((e) => e.toJson()).toList());
                      //       }

                      //       var otherChargeListString = json.encode(
                      //           otherChargeList
                      //               .map((e) => e.toJson())
                      //               .toList());

                      //       var paidInfoListString = json.encode(
                      //           paidInfoList.map((e) => e.toJson()).toList());

                      //       var termsListString = json.encode(
                      //           termsList.map((e) => e.toJson()).toList());

                      //       var quoteInvSettingString =
                      //           json.encode(quoteInvSettingModel.toJson());

                      //       var businessString =
                      //           json.encode(businessModel.toJson());

                      //       InvoiceModel updateinvoiceModel = InvoiceModel(
                      //         customerData: customerModelString,
                      //         invoiceDate: DateFormat('yyyy-MM-dd')
                      //             .format(DateTime.now()),
                      //         invoiceNo: "Challan-$challanLength",
                      //         otherChargesData: otherChargeListString,
                      //         productData: productListString,
                      //         termsConditionData: termsListString,
                      //         totalTax: totalTax.toString(),
                      //         amtDue: totalAmtDue.toString(),
                      //         roundOffAmt: roundOffAmt,
                      //         roundOftotalAmtDue: roundOftotalAmtDue.toString(),
                      //         isTotalDiscountAdded: addedDiscount,
                      //         totalDiscountType:
                      //             isPercentage ? "Percentage" : "FlatAmt",
                      //         totalDiscountPercentage:
                      //             isPercentage ? ctlDisc : "0",
                      //         totalDiscountedAmount: discAmt.toStringAsFixed(2),
                      //         totalTaxPercentage: totalApplyTax,
                      //         dueDate: DateTime.now().toIso8601String(),
                      //         poNumber: "2023-11-09",
                      //         paidInfoListData: paidInfoListString,
                      //         quoteInvSettingData: quoteInvSettingString,
                      //         businessData: businessString,
                      //       );

                      //       var updateinvoiceData =
                      //           json.encode(updateinvoiceModel.toJson());

                      //       pdfFile = await ChallanPDF().generate(
                      //           customerModel,
                      //           productList,
                      //           termsList,
                      //           otherChargeList,
                      //           businessModel,
                      //           roundOffAmt
                      //               ? roundOftotalAmtDue.toStringAsFixed(2)
                      //               : totalAmtDue.toStringAsFixed(2),
                      //           subTotalTax.toStringAsFixed(2),
                      //           subTotal.toStringAsFixed(2),
                      //           quoteInvSettingModel,
                      //           subTotalDiscount.toStringAsFixed(2),
                      //           [totalApplyTax, appliedTotalTaxAmt],
                      //           isPercentage
                      //               ? [ctlDisc, discAmt.toStringAsFixed(2)]
                      //               : ["0", ctlDisc],
                      //           paidInfoList.isEmpty,
                      //           [paidInfoAmt, total],
                      //           "Challan-$challanLength");

                      //       uploadChallan(
                      //         context,
                      //         updateinvoiceData,
                      //         pdfFile,
                      //       );
                      //     },
                      //   ),
                      // ),

                      Expanded(
                        child: PdfBottomHelper(
                          assetName: "assets/images/document_share.svg",
                          name: 'Share\nInvoice',
                          h: 28,
                          w: 28,
                          onTap: () {
                            // CommonFunctions.showShareDialogue(
                            //   context: context,
                            //   generalClick: () {
                            //     Navigator.pop(context);
                            //     Share.shareXFiles([XFile(widget.file!.path)],
                            //         text: 'Invoice');
                            //   },
                            //   unSavedButonClick: () {
                            //     Navigator.pop(context);
                            //     CommonFunctions.showWarningSnackbar(
                            //         context, "Comming Soon..");
                            //   },
                            // );
                            Share.shareXFiles([XFile(widget.file!.path)],
                                text: 'Invoice');
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfBottomHelper extends StatelessWidget {
  final double? h, w;
  final String name, assetName;
  final VoidCallback onTap;
  const PdfBottomHelper(
      {super.key,
      this.h,
      this.w,
      required this.name,
      required this.onTap,
      required this.assetName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 5.h),
          child: Column(children: [
            SvgPicture.asset(
              assetName,
              height: h,
              width: w,
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.5.sp),
            )
          ]),
        ));
  }
}
