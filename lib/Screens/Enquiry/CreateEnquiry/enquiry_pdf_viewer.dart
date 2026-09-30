import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fast_quote/Screens/Enquiry/EnquiryList/enquiry_list_model.dart';
import 'package:fast_quote/Screens/Enquiry/enquiry_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/common_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class EnquiryPFDViewerPage extends StatefulWidget {
  final File? file;
  final String enquiryData;
  final EnquiryListModel enquiryListModel;

  const EnquiryPFDViewerPage(
      {Key? key,
      this.file,
      required this.enquiryData,
      required this.enquiryListModel})
      : super(key: key);

  @override
  EnquiryPFDViewerPageState createState() => EnquiryPFDViewerPageState();
}

class EnquiryPFDViewerPageState extends State<EnquiryPFDViewerPage> {
  Dio dio = Dio();

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
                'Are you sure you want to delete Enquiry ??',
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
                          deleteEnquiry(context, widget.enquiryListModel);
                        },
                        child: const Text('Yes'))
                  ],
                ),
              ],
            ),
          );
        });
  }

  EnquiryRepository enquiryRepository = EnquiryRepository();
  deleteEnquiry(BuildContext context, var enquiryModel) async {
    CommonFunctions.showProgressBar(context);

    var result = await enquiryRepository.deleteEnquiry(
        context, enquiryModel.id!.toString());

    result.fold((error) {
      Navigator.pop(context);
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) {
      Navigator.of(context)
        ..pop()
        ..pop()
        ..pop();
      CommonFunctions.showSuccessSnackbar("Enquiry deleted.");
    });
  }

  Future<void> saveAsTemplate(
      BuildContext context, EnquiryListModel enquiryModel) async {
    CommonFunctions.showProgressBar(context);

    FormData formData = FormData.fromMap({
      "is_template": 1,
    });

    dynamic result;

    result = await enquiryRepository.updateEnquiry(
        context, formData, enquiryModel.id.toString());

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);

      Navigator.pop(context);
    }, (data) {
      if (data != null) {
        Navigator.pop(context);
        CommonFunctions.showSuccessSnackbar("Saved as Teplate");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: commonAppBar(
            onPressed: () {
              Navigator.pop(context);
            },
            elv: 3,
            context: context,
            heading: 'Enquiry',
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
                          name: 'Save as\nTemplate',
                          onTap: () {
                            // CommonFunctions.showSuccessSnackbar(
                            //     "Saved as Teplate");
                            saveAsTemplate(context, widget.enquiryListModel);
                          },
                          h: 28,
                          w: 28,
                        ),
                      ),
                      Expanded(
                        child: PdfBottomHelper(
                          assetName: "assets/images/document_edit.svg",
                          name: 'Edit\nEnquiry',
                          h: 28,
                          w: 28,
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteNames.updateEnquiry,
                                arguments: {
                                  "enquiryData": widget.enquiryData,
                                  "enqNo": "",
                                  "enquiryListModel": widget.enquiryListModel
                                });
                          },
                        ),
                      ),
                      Expanded(
                        child: PdfBottomHelper(
                          assetName: "assets/images/document_convert.svg",
                          name: 'Convert to\nQuotation',
                          onTap: () async {
                            bool isQuotationFill =
                                await LocalPreferences().getQuotationFill() ??
                                    false;
                            if (isQuotationFill) {
                              if (context.mounted) {
                                Navigator.of(context)
                                  ..pop()
                                  ..pushNamed(RouteNames.createQuotation,
                                      arguments: {
                                        "quotationData": widget.enquiryData,
                                        "quotationNo": "",
                                        "from": "Enquiry",
                                        "enqId": widget.enquiryListModel.id
                                            .toString()
                                      });
                              }
                            } else {
                              if (context.mounted) {
                                CommonFunctions.showWarningSnackbar(context,
                                    "Fill Quotation Settings to use this feature");
                              }
                            }
                          },
                          h: 28,
                          w: 28,
                        ),
                      ),
                      Expanded(
                        child: PdfBottomHelper(
                          assetName: "assets/images/document_share.svg",
                          name: 'Share\nEnquiry',
                          h: 28,
                          w: 28,
                          onTap: () {
                            // CommonFunctions.showShareDialogue(
                            //   context: context,
                            //   generalClick: () {
                            //     Navigator.pop(context);
                            //     Share.shareXFiles([XFile(widget.file!.path)],
                            //         text: 'Enquiry');
                            //   },
                            //   unSavedButonClick: () {
                            //     Navigator.pop(context);
                            //     CommonFunctions.showWarningSnackbar(
                            //         context, "Comming Soon..");
                            //   },
                            // );
                            Share.shareXFiles([XFile(widget.file!.path)],
                                text: 'Enquiry');
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
