// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:fast_quote/Screens/Auth/other_charges_model.dart';
import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/generate_pdf/pdf_api.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Utils/remote_urls.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class EnquiryPDF {
  var appLogo, todayDate, phoneIcon, emailIcon;
  var font, boldFont;
  String labelType = "";

  getinitData(BusinessModel model) async {
    todayDate = CommonFunctions().getCurrentDate();
    appLogo = await networkImage(model.logo!);
    phoneIcon = await networkImage("${ReomteUrl.requiredImagePath}/mobile.png");
    emailIcon = await networkImage("${ReomteUrl.requiredImagePath}/email.png");
    font = await PdfGoogleFonts.nunitoMedium();
    boldFont = await PdfGoogleFonts.nunitoBold();
    labelType = await LocalPreferences().getTaxLabel() ?? "";
  }

  Future<File?> generate(
      CustomerModel customerModel,
      List<ProductModel> productList,
      List<TermsModel> termsList,
      List<OtherchargesModel> otherChargeList,
      BusinessModel businessModel,
      amtDue,
      totalTax,
      subTotal,
      enqNum,
      rouoffValue) async {
    final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);
    await getinitData(businessModel);

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        buildbody(
            todayDate,
            appLogo,
            customerModel,
            productList,
            termsList,
            otherChargeList,
            businessModel,
            font,
            amtDue,
            totalTax,
            subTotal,
            labelType,
            boldFont,
            enqNum,
            phoneIcon,
            emailIcon,
            rouoffValue)
      ],
      // header: (context) => buildTitle(context, netImage),
    ));
    return PdfApi.saveDocument(
      name: 'Enquiry.pdf',
      pdf: pdf,
    );
  }

  static pw.Widget buildbody(
      String date,
      appLogo,
      CustomerModel customerModel,
      List<ProductModel> productList,
      List<TermsModel> termsList,
      List<OtherchargesModel> otherChargeList,
      BusinessModel businessModel,
      font,
      amtDue,
      totalTax,
      subTotal,
      labelType,
      boldFont,
      enqNum,
      phoneIcon,
      emailIcon,
      rouoffValue) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColors.white,
          ),
          borderRadius: pw.BorderRadius.circular(0)),
      child:
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Divider(),
        pw.Container(
            padding:
                const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(children: [
              pw.Image(appLogo, width: 60),
              SizedBox(width: 25),
              pw.Expanded(
                child: pw.Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        businessModel.name!,
                        style: pw.TextStyle(
                          fontSize: 13,
                          font: boldFont,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        businessModel.contact!,
                        textAlign: TextAlign.center,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        businessModel.addressOne!,
                        textAlign: TextAlign.center,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 9,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            pw.Image(phoneIcon, width: 15),
                            pw.Text(
                              "+91 ${businessModel.phone!}",
                              textAlign: TextAlign.center,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Image(emailIcon, width: 15),
                            pw.SizedBox(width: 5),
                            pw.Text(
                              businessModel.email!,
                              textAlign: TextAlign.center,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ]),
                      pw.SizedBox(height: 3),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              "${businessModel.label!} : ",
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 9,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.Text(
                              businessModel.businessNo!,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 9,
                                color: PdfColors.black,
                              ),
                            ),
                          ])
                    ]),
              ),
              SizedBox(width: 25),
              pw.Column(children: [
                pw.Text(
                  'ENQUIRY',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    color: PdfColors.black,
                  ),
                ),
                SizedBox(height: 10),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(
                              'ENQ # : ',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 8,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.Text(
                              'Date : ',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 8,
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                      pw.SizedBox(width: 5),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(
                              enqNum,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 8,
                                color: PdfColors.black,
                              ),
                            ),
                            pw.Text(
                              date,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 8,
                                color: PdfColors.black,
                              ),
                            ),
                          ]),
                      pw.SizedBox(height: 5),
                    ])
              ]),
            ])),
        pw.Divider(),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.SizedBox(height: 5),
                pw.Text(
                  'From, ',
                  style: pw.TextStyle(
                    fontSize: 9,
                    font: boldFont,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        customerModel.companyName!,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 9,
                          color: PdfColors.black,
                        ),
                      ),
                      Row(children: [
                        pw.Text(
                          "GSTIN No. : ",
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 9,
                            color: PdfColors.black,
                          ),
                        ),
                        pw.Text(
                          customerModel.gstin!,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            color: PdfColors.black,
                          ),
                        ),
                      ])
                    ]),
                pw.SizedBox(height: 3),
                pw.Text(
                  '+91${customerModel.mobile!}',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  customerModel.email!,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  customerModel.addressOne!,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Thank you for your inquiry , we are pleased to quote you the following,',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(height: 10),
              ]),
        ),
        pw.SizedBox(height: 0.2 * PdfPageFormat.cm),
        pw.Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: buildPartsbody(productList, font, labelType, boldFont),
        ),
        pw.Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: pw.Container(color: PdfColors.black, height: .5),
        ),

        otherChargeList.isEmpty && (rouoffValue == "0" || rouoffValue == "0.00")
            ? pw.Container()
            : pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  width: 250,
                  alignment: Alignment.centerRight,
                  padding:
                      const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(
                          bottom: pw.BorderSide(color: PdfColors.black),
                          left: pw.BorderSide(color: PdfColors.black))),
                  child: pw.Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        pw.Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                'TOTAL AMOUNT  :',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 8,
                                  color: PdfColors.black,
                                ),
                              ),
                              otherChargeList.isNotEmpty
                                  ? SizedBox(height: 5)
                                  : SizedBox(),
                              otherChargeList.isNotEmpty
                                  ? pw.ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return pw.SizedBox(height: 3);
                                      },
                                      itemBuilder: (context, index) {
                                        return pw.Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              pw.Text(
                                                otherChargeList[index].title!,
                                                style: pw.TextStyle(
                                                  font: boldFont,
                                                  fontSize: 8,
                                                  color: PdfColors.black,
                                                ),
                                              ),
                                              otherChargeList[0].tax! == ""
                                                  ? SizedBox()
                                                  : pw.Text(
                                                      "(${otherChargeList[index].tax!}%)",
                                                      style: pw.TextStyle(
                                                        font: font,
                                                        fontSize: 8,
                                                        color: PdfColors.black,
                                                      ),
                                                    )
                                            ]);
                                      },
                                      itemCount: otherChargeList.length)
                                  : SizedBox(),
                              rouoffValue != "0" && rouoffValue != "0.00"
                                  ? SizedBox(height: 5)
                                  : SizedBox(),
                              rouoffValue != "0" && rouoffValue != "0.00"
                                  ? pw.Text(
                                      "Round Off Amt.",
                                      style: pw.TextStyle(
                                        font: font,
                                        fontSize: 8,
                                        color: PdfColors.black,
                                      ),
                                    )
                                  : SizedBox(),
                            ]),
                        SizedBox(width: 15),
                        pw.Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                "\u{20B9} $subTotal",
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    color: PdfColors.black,
                                    font: font),
                              ),
                              otherChargeList.isNotEmpty
                                  ? SizedBox(height: 5)
                                  : SizedBox(),
                              otherChargeList.isNotEmpty
                                  ? pw.ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return pw.SizedBox(height: 3);
                                      },
                                      itemBuilder: (context, index) {
                                        return pw.Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              pw.Text(
                                                "\u{20B9} ${otherChargeList[0].amount!}",
                                                style: pw.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  color: PdfColors.black,
                                                ),
                                              ),
                                              otherChargeList[0].tax! == ""
                                                  ? SizedBox()
                                                  : pw.Text(
                                                      "\u{20B9} ${otherChargeList[0].taxAmt!}",
                                                      style: pw.TextStyle(
                                                        font: font,
                                                        fontSize: 8,
                                                        color: PdfColors.black,
                                                      ),
                                                    )
                                            ]);
                                      },
                                      itemCount: otherChargeList.length)
                                  : SizedBox(),
                              rouoffValue != "0" && rouoffValue != "0.00"
                                  ? SizedBox(height: 5)
                                  : SizedBox(),
                              rouoffValue != "0" && rouoffValue != "0.00"
                                  ? pw.Text(
                                      "- \u{20B9} $rouoffValue",
                                      style: pw.TextStyle(
                                        font: font,
                                        fontSize: 8,
                                        color: PdfColors.black,
                                      ),
                                    )
                                  : SizedBox(),
                            ])
                      ]),
                ),
              ),

        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Container(
            width: 250,
            padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: const pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border(
                    // right: pw.BorderSide(color: PdfColors.black),
                    bottom: pw.BorderSide(color: PdfColors.grey100),
                    left: pw.BorderSide(color: PdfColors.black))),
            child: pw.Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              pw.Text(
                'GRAND TOTAL :',
                textAlign: TextAlign.right,
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 8,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(width: 15),
              pw.Container(
                alignment: Alignment.centerRight,
                width: 70,
                child: pw.Text(
                  '\u{20B9} $amtDue',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 8,
                    color: PdfColors.black,
                  ),
                ),
              )
            ]),
          ),
        ),

        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: const pw.BoxDecoration(
              border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.black),
                  top: pw.BorderSide(color: PdfColors.black))),
          child: pw.Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Note : By accepting this, you agree to bound the following terms and conditions.',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 9,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Terms and Conditions :',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 9,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.ListView.separated(
                    separatorBuilder: (context, index) {
                      return pw.SizedBox(height: 3);
                    },
                    itemBuilder: (context, index) {
                      var serialNum = index + 1;
                      return pw.Align(
                          alignment: Alignment.centerLeft,
                          child: pw.Text(
                            '$serialNum ${termsList[index].term}',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 9,
                              color: PdfColors.black,
                            ),
                          ));
                    },
                    itemCount: termsList.length),
                pw.SizedBox(height: 3),
                // pw.Text(
                //   'We will be happy to supply any futher information you may need and trust that you call us to fullfill your order, which will receive our prompt and carefull attention.',
                //   style: pw.TextStyle(
                //     font: font,
                //     fontSize: 9,
                //     color: PdfColors.black,
                //   ),
                // ),
              ]),
        ),
        // pw.Container(
        //   padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        //   decoration: const pw.BoxDecoration(
        //       border: pw.Border(
        //           bottom: pw.BorderSide(color: PdfColors.black),
        //           top: pw.BorderSide(color: PdfColors.black))),
        //   child: pw.Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         pw.Text(
        //           textAlign: TextAlign.center,
        //           'Authorised Dealers for Computer, Laptop, Printers and Scanners for HP, Acer, Dell, Lenova',
        //           style: pw.TextStyle(
        //
        //             fontSize: 9,
        //             color: PdfColors.black,
        //           ),
        //         ),
        //         pw.SizedBox(height: 8),
        //         pw.Text(
        //           textAlign: TextAlign.center,
        //           'Laptops | Desktop | Printers | CCTV Camera & DVR | LED & LCD | Hard Disks | Projectors | Pendrives Webcams | Data Cards | Routers | Modem | Tv Tuner Card | Speakers | Biomteric Devices | Currency Counter ',
        //           style: pw.TextStyle(
        //
        //             fontSize: 9,
        //             color: PdfColors.black,
        //           ),
        //         ),
        //       ]),
        // ),
      ]),
    );
  }

  static pw.Widget buildPartsbody(
      List<ProductModel> partData, font, labelType, boldFont) {
    final headers = ['SR', 'PRODUCT', 'QTY', 'PRICE', labelType, 'TOTAL'];

    final data = List.generate(
      partData.length,
      (index) {
        // double qty = double.parse(partData[index].quantity!);
        // double price = double.parse(partData[index].price!);
        // var total = qty * price;
        return [
          index + 1,
          partData[index].productName,
          partData[index].productQuantity,
          '\u{20B9} ${partData[index].productPrice}',
          "\u{20B9} ${partData[index].productAppliedGST}\n(${partData[index].productGST}%)",
          '\u{20B9} ${partData[index].productTaxAmount}',
        ];
      },
    );

    return pw.Table.fromTextArray(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        headerCellDecoration: const BoxDecoration(
            color: PdfColors.grey100,
            border: Border(
                top: BorderSide(color: PdfColors.black),
                bottom: BorderSide(color: PdfColors.black))),
        border: const TableBorder(
            horizontalInside: BorderSide(
                width: 1, color: PdfColors.white, style: BorderStyle.solid)),
        headers: headers,
        headerAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
        },
        cellAlignment: Alignment.center,
        data: data,
        headerStyle: pw.TextStyle(fontSize: 8, font: boldFont),
        headerDecoration: const pw.BoxDecoration(color: PdfColors.white),
        cellStyle:
            pw.TextStyle(fontSize: 8, font: font, color: PdfColors.black),
        columnWidths: {
          0: const FlexColumnWidth(20),
          1: const FlexColumnWidth(120),
          2: const FlexColumnWidth(30),
          3: const FlexColumnWidth(40),
          4: const FlexColumnWidth(40),
          5: const FlexColumnWidth(50),
        },
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
          4: pw.Alignment.centerRight,
          5: pw.Alignment.centerRight,
        });
  }
}
