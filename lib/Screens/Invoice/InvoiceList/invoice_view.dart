import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Invoice/invoice_helper.dart';
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

import 'invoice_list_model.dart';

class InvoiceViewPage extends StatefulWidget {
  final File? file;
  final String invoiceData;
  final bool isSavedAsTemplate;
  final InvoiceListModel invoiceListModel;

  const InvoiceViewPage({
    Key? key,
    this.file,
    required this.invoiceData,
    required this.invoiceListModel,
    required this.isSavedAsTemplate,
  }) : super(key: key);

  @override
  InvoiceViewPageState createState() => InvoiceViewPageState();
}

class InvoiceViewPageState extends State<InvoiceViewPage> {
  Dio dio = Dio();
  File? pdfFile;

  bool isLoading = true;
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
                'Are you sure you want to delete Invoice ??',
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
                          deleteInvoice(context, widget.invoiceListModel);
                        },
                        child: const Text('Yes'))
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> saveAsTemplate(
      BuildContext context, InvoiceListModel invoiceListModel) async {
    CommonFunctions.showProgressBar(context);

    FormData formData = FormData.fromMap({
      "is_template": 1,
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
        CommonFunctions.showSuccessSnackbar("Saved as Template");
        // Navigator.of(context)
        //   ..pop()
        //   ..pop();
        // Navigator.pushNamed(context, RouteNames.createInvoice, arguments: {
        //   "invoiceData": widget.invoiceData,
        //   "invoiceNo": "",
        //   "from": "Invoice",
        // });
      }
    });
  }

  deleteInvoice(BuildContext context, var invoiceModel) async {
    CommonFunctions.showProgressBar(context);

    var result = await invoiceRepository.deleteInvoice(
        context, invoiceModel.id!.toString());

    result.fold((error) {
      Navigator.pop(context);
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) {
      Navigator.of(context)
        ..pop()
        ..pop()
        ..pop();
      CommonFunctions.showSuccessSnackbar("Invoice deleted.");
    });
  }

  Future<void> updateInvoice(BuildContext context, String jsonData,
      dynamic file, String status, String id) async {
    CommonFunctions.showProgressBar(context);

    FormData formData = FormData.fromMap({
      "data": jsonData,
      "is_template": 0,
      "invoice_reciept": await MultipartFile.fromFile(
        file.path,
      ),
      "status": status,
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
    setState(() {
      isLoading = true;
    });
    var result = await settingsRepository.getHomeData(context);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);

      setState(() {
        isLoading = false;
      });
    }, (data) {
      challanLength = data.challanNumber!;
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> uploadChallan(
      BuildContext context, String jsonData, dynamic file, String id) async {
    FormData formData = FormData.fromMap({
      "enquiry_id": id,
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
        if (data.statusCode == 400) {
          var response = data.data["response"];
          Navigator.pop(context);
          if (response == false) {
            CommonFunctions.showErrorSnackbar(
                context, "Challan is already generated against this Invoice,");
          }
        } else {
          Navigator.pop(context);
          CommonFunctions.showSuccessSnackbar("Converted to Challan.");
          // getHomeData(context);
          Navigator.of(context)
            ..pop()
            ..pop()
            ..pushNamed(
              RouteNames.challanList,
            );
        }
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Container(
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
                                assetName:
                                    "assets/images/document_duplicate.svg",
                                name: 'Save as\nTemplate',
                                onTap: () {
                                  saveAsTemplate(
                                      context, widget.invoiceListModel);
                                },
                                h: 28,
                                w: 28,
                              ),
                            ),
                            Expanded(
                              child: PdfBottomHelper(
                                assetName: "assets/images/document_edit.svg",
                                name: 'Edit\nInvoice',
                                h: 28,
                                w: 28,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteNames.updateInvoicePdf,
                                      arguments: {
                                        "invoiceData": widget.invoiceData,
                                        "invoiceNo": "",
                                        "invoiceListModel":
                                            widget.invoiceListModel,
                                      });
                                },
                              ),
                            ),
                            Expanded(
                              child: PdfBottomHelper(
                                assetName: "assets/images/status.svg",
                                name: 'Invoice\nStatus',
                                h: 28,
                                w: 28,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    )),
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Invoice Status',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.sp),
                                            ),
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            ListTile(
                                              title: const Text('Paid'),
                                              onTap: () {
                                                updateInvoice(
                                                    context,
                                                    widget.invoiceData,
                                                    widget.file,
                                                    "Paid",
                                                    widget.invoiceListModel.id
                                                        .toString());
                                              },
                                            ),
                                            ListTile(
                                              title: const Text('Unpaid'),
                                              onTap: () {
                                                updateInvoice(
                                                    context,
                                                    widget.invoiceData,
                                                    widget.file,
                                                    "Unpaid",
                                                    widget.invoiceListModel.id
                                                        .toString());
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: PdfBottomHelper(
                                assetName: "assets/images/document_convert.svg",
                                name: 'Convert to\nChallan',
                                h: 28,
                                w: 28,
                                onTap: () async {
                                  CommonFunctions.showProgressBar(context);
                                  dynamic returnedData = await InvoiceHelper()
                                      .generateChallan(
                                          context: context,
                                          invoiceData: widget.invoiceData,
                                          challanLength:
                                              challanLength.toString());
                                  if (returnedData != null) {
                                    uploadChallan(
                                        context,
                                        returnedData[0],
                                        returnedData[1],
                                        widget.invoiceListModel.id.toString());
                                  } else {}
                                },
                              ),
                            ),
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
