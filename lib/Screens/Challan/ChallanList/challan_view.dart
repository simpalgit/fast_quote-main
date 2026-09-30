import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Challan/challan_repository.dart';

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

import 'challan_list_model.dart';

class ChallanViewPage extends StatefulWidget {
  final File? file;
  final String invoiceData;
  final bool isSavedAsTemplate;
  final ChallanListModel challanListModel;

  const ChallanViewPage(
      {Key? key,
      this.file,
      required this.invoiceData,
      required this.challanListModel,
      required this.isSavedAsTemplate})
      : super(key: key);

  @override
  ChallanViewPageState createState() => ChallanViewPageState();
}

class ChallanViewPageState extends State<ChallanViewPage> {
  Dio dio = Dio();

  ChallanRepository challanRepository = ChallanRepository();

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
                'Are you sure you want to delete Challan ??',
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
                          deletechallan(context, widget.challanListModel);
                        },
                        child: const Text('Yes'))
                  ],
                ),
              ],
            ),
          );
        });
  }

  deletechallan(BuildContext context, var invoiceModel) async {
    CommonFunctions.showProgressBar(context);

    var result = await challanRepository.deleteChallan(
        context, invoiceModel.id!.toString());

    result.fold((error) {
      Navigator.pop(context);
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) {
      CommonFunctions.showSuccessSnackbar("Challan deleted.");
      Navigator.of(context)
        ..pop()
        ..pop()
        ..pop();
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
            heading: 'Challan',
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
                          assetName: "assets/images/document_edit.svg",
                          name: 'Edit\nChallan',
                          h: 28,
                          w: 28,
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteNames.updateChallanScreen,
                                arguments: {
                                  "challanListModel": widget.challanListModel,
                                  "data": widget.invoiceData,
                                });
                          },
                        ),
                      ),
                      Expanded(
                        child: PdfBottomHelper(
                          assetName: "assets/images/document_share.svg",
                          name: 'Share\nChallan',
                          h: 28,
                          w: 28,
                          onTap: () {
                            Share.shareXFiles([XFile(widget.file!.path)],
                                text: 'Challan');
                            // CommonFunctions.showShareDialogue(
                            //   context: context,
                            //   generalClick: () {
                            //     Navigator.pop(context);
                            //     Share.shareXFiles([XFile(widget.file!.path)],
                            //         text: 'Challan');
                            //   },
                            //   unSavedButonClick: () async {
                            //     Navigator.pop(context);

                            //     CommonFunctions.showWarningSnackbar(
                            //         context, "Comming Soon..");
                            //   },
                            // );
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
