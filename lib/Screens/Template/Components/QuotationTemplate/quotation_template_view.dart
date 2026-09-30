import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Quotation/QuotationList/quotation_list_model.dart';
import 'package:fast_quote/Screens/Quotation/quotation_repository.dart';
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

class QuotationTemplateViewPage extends StatefulWidget {
  final File? file;
  final String quotationData;
  final bool isSavedAsTemplate;
  final QuotationListModel quotationListModel;

  const QuotationTemplateViewPage(
      {Key? key,
      this.file,
      required this.quotationData,
      required this.quotationListModel,
      required this.isSavedAsTemplate})
      : super(key: key);

  @override
  QuotationTemplateViewPageState createState() =>
      QuotationTemplateViewPageState();
}

class QuotationTemplateViewPageState extends State<QuotationTemplateViewPage> {
  Dio dio = Dio();

  QuotationRepository quotationRepository = QuotationRepository();

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
                          removeTemplate(context, widget.quotationListModel);
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
      BuildContext context, QuotationListModel invoiceListModel) async {
    CommonFunctions.showProgressBar(context);

    FormData formData = FormData.fromMap({
      "is_template": 0,
    });

    dynamic result;

    result = await quotationRepository.updateQuotation(
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
            heading: 'Quotation',
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
                              ..pushNamed(RouteNames.createQuotation,
                                  arguments: {
                                    "quotationData": widget.quotationData,
                                    "quotationNo": "",
                                    "from": "Template",
                                    "enqId": ""
                                  });
                          },
                          h: 28,
                          w: 28,
                        ),
                      ),
                      Expanded(
                        child: PdfBottomHelper(
                          assetName: "assets/images/document_share.svg",
                          name: 'Share\nQuotation',
                          h: 28,
                          w: 28,
                          onTap: () {
                            // CommonFunctions.showShareDialogue(
                            //   context: context,
                            //   generalClick: () {
                            //     Navigator.pop(context);
                            //     Share.shareXFiles([XFile(widget.file!.path)],
                            //         text: 'Quotation');
                            //   },
                            //   unSavedButonClick: () {
                            //     Navigator.pop(context);
                            //     CommonFunctions.showWarningSnackbar(
                            //         context, "Comming Soon..");
                            //   },
                            // );
                            Share.shareXFiles([XFile(widget.file!.path)],
                                text: 'Quotation');
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
