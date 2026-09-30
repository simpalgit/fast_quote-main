// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:fast_quote/Screens/Auth/other_charges_model.dart';
import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/generate_pdf/pdf_api.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Utils/remote_urls.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class QuotationPDFThree {
  var appLogo, signature, todayDate, phoneIcon, emailIcon;

  var font, boldFont;
  String labelType = "";
  var showTaxDiscHSN,
      showTaxDisc,
      showTaxHSN,
      showTax,
      showDiscHSN,
      showDisc,
      showHSN;
  getinitData(
      BusinessModel model, QuoteInvSettingModel quoteInvSettingModel) async {
    todayDate = CommonFunctions().getCurrentDate();
    appLogo = await networkImage(model.logo!);
    signature = await networkImage(model.signature!);
    phoneIcon =
        await networkImage("${ReomteUrl.requiredImagePath}/mobile_white.png");
    emailIcon =
        await networkImage("${ReomteUrl.requiredImagePath}/email_white.png");
    font = await PdfGoogleFonts.nunitoMedium();
    boldFont = await PdfGoogleFonts.nunitoBold();
    labelType = await LocalPreferences().getTaxLabel() ?? "";

    showTaxDiscHSN = quoteInvSettingModel.tax == "Per item" &&
        quoteInvSettingModel.discount == "Per item" &&
        quoteInvSettingModel.product == "Yes";

    showTaxDisc = quoteInvSettingModel.tax == "Per item" &&
        quoteInvSettingModel.discount == "Per item" &&
        quoteInvSettingModel.product == "No";

    showTaxHSN = quoteInvSettingModel.tax == "Per item" &&
        (quoteInvSettingModel.discount == "On Total" ||
            quoteInvSettingModel.discount == "No Discount") &&
        quoteInvSettingModel.product == "Yes";

    showTax = quoteInvSettingModel.tax == "Per item" &&
        (quoteInvSettingModel.discount == "On Total" ||
            quoteInvSettingModel.discount == "No Discount") &&
        quoteInvSettingModel.product == "No";

    showDiscHSN = quoteInvSettingModel.discount == "Per item" &&
        (quoteInvSettingModel.tax == "On Total" ||
            quoteInvSettingModel.tax == "No Tax") &&
        quoteInvSettingModel.product == "Yes";

    showDisc = quoteInvSettingModel.discount == "Per item" &&
        (quoteInvSettingModel.tax == "On Total" ||
            quoteInvSettingModel.tax == "No Tax") &&
        quoteInvSettingModel.product == "No";

    showHSN = (quoteInvSettingModel.tax == "On Total" ||
            quoteInvSettingModel.tax == "No Tax" ||
            quoteInvSettingModel.discount == "On Total" ||
            quoteInvSettingModel.discount == "No Discount") &&
        quoteInvSettingModel.product == "Yes";
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
      QuoteInvSettingModel quoteInvSettingModel,
      subTotalDiscount,
      totalApplyTax,
      totalApplyDisc,
      quoteNumber) async {
    // var number = int.parse(gstPercent) / 2;
    // var sgstCGSTPercent = number.toInt();
    final pdf = pw.Document();
    await getinitData(businessModel, quoteInvSettingModel);

    // totalPriceWords = NumberToWordsEnglish.convert(finaltotal.toInt());
    pdf.addPage(pw.MultiPage(
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
            signature,
            quoteInvSettingModel,
            showTaxDiscHSN,
            showTaxDisc,
            showTaxHSN,
            showTax,
            showDiscHSN,
            showDisc,
            showHSN,
            subTotalDiscount,
            totalApplyTax,
            totalApplyDisc,
            quoteNumber,
            phoneIcon,
            emailIcon)
      ],
      // header: (context) => buildTitle(context, netImage),
    ));
    return PdfApi.saveDocument(
      name: 'Quotation.pdf',
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
      signature,
      QuoteInvSettingModel quoteInvSettingModel,
      showTaxDiscHSN,
      showTaxDisc,
      showTaxHSN,
      showTax,
      showDiscHSN,
      showDisc,
      showHSN,
      subTotalDiscount,
      totalApplyTax,
      totalApplyDisc,
      quoteNumber,
      phoneIcon,
      emailIcon) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: templateTwoSecondary,
          ),
          borderRadius: pw.BorderRadius.circular(0)),
      child:
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Container(
            decoration: pw.BoxDecoration(
                //     gradient: LinearGradient(
                //   begin: Alignment.bottomLeft,
                //   end: Alignment.topRight,
                //   stops: const [0.4, 1.0],
                //   colors: [
                //     templateThreePrimary,
                //     templateTwoPromaryTwo,
                //   ],
                // )
                color: templateThreePrimary),
            padding:
                const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(children: [
              ClipOval(
                child: pw.Image(appLogo, width: 60),
              ),
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
                          color: templateWhiteColor,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        businessModel.contact!,
                        textAlign: TextAlign.center,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                          color: templateWhiteColor,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        businessModel.addressOne!,
                        textAlign: TextAlign.center,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 9,
                          color: templateWhiteColor,
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
                                  color: templateWhiteColor),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Image(
                              emailIcon,
                              width: 15,
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text(
                              businessModel.email!,
                              textAlign: TextAlign.center,
                              style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: templateWhiteColor),
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
                                color: templateWhiteColor,
                              ),
                            ),
                            pw.Text(
                              businessModel.businessNo!,
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 9,
                                color: templateWhiteColor,
                              ),
                            ),
                          ])
                    ]),
              ),
              SizedBox(width: 25),
              pw.Column(children: [
                pw.Text(
                  'Quotation',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    color: templateWhiteColor,
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
                              'Quote : ',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 8,
                                color: templateWhiteColor,
                              ),
                            ),
                            pw.Text(
                              'Date : ',
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 8,
                                color: templateWhiteColor,
                              ),
                            ),
                          ]),
                      pw.SizedBox(width: 5),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(
                              quoteNumber,
                              style: pw.TextStyle(
                                  font: font,
                                  fontSize: 8,
                                  color: templateWhiteColor),
                            ),
                            pw.Text(
                              date,
                              style: pw.TextStyle(
                                  font: font,
                                  fontSize: 8,
                                  color: templateWhiteColor),
                            ),
                          ]),
                      pw.SizedBox(height: 5),
                    ])
              ]),
            ])),

        // pw.SizedBox(height: 15),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.SizedBox(height: 5),
                pw.Text(
                  'To, ',
                  style: pw.TextStyle(
                    fontSize: 9,
                    font: boldFont,
                    color: templateThreePrimary,
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        customerModel.companyName!,
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 13,
                          color: templateTwoSecondary,
                        ),
                      ),
                      Row(children: [
                        pw.Text(
                          "GSTIN No. : ",
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 9,
                            color: templateThreePrimary,
                          ),
                        ),
                        pw.Text(
                          customerModel.gstin!,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            color: templateTwoSecondary,
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
                    color: templateTwoSecondary,
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  customerModel.email!,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: templateTwoSecondary,
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  customerModel.addressOne!,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: templateTwoSecondary,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  quoteInvSettingModel.topMessage!,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 10,
                    color: templateTwoSecondary,
                  ),
                ),
                pw.SizedBox(height: 10),
              ]),
        ),
        pw.SizedBox(height: 0.2 * PdfPageFormat.cm),
        pw.Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: buildBody(
              productList,
              font,
              labelType,
              boldFont,
              quoteInvSettingModel,
              showTaxDiscHSN,
              showTaxDisc,
              showTaxHSN,
              showTax,
              showDiscHSN,
              showDisc,
              showHSN),
        ),
        pw.Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: pw.Container(color: PdfColors.black, height: .5),
        ),

        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Container(
            width: 250,
            alignment: Alignment.centerRight,
            padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                          'SUB AMOUNT  :',
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 8,
                            color: PdfColors.black,
                          ),
                        ),
                        quoteInvSettingModel.discount == "Per item"
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        quoteInvSettingModel.discount == "Per item"
                            ? Text(
                                'DISCOUNT  :',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 8,
                                  color: PdfColors.black,
                                ),
                              )
                            : SizedBox(),
                        quoteInvSettingModel.discount == "On Total"
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        quoteInvSettingModel.discount == "On Total"
                            ? Text(
                                'DISCOUNT  :',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 8,
                                  color: PdfColors.black,
                                ),
                              )
                            : SizedBox(),
                        quoteInvSettingModel.tax == "On Total"
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        quoteInvSettingModel.tax == "On Total"
                            ? Text(
                                'Tax  (${totalApplyTax[0]} %):',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 8,
                                  color: PdfColors.black,
                                ),
                              )
                            : SizedBox(),
                        quoteInvSettingModel.tax == "Per item"
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        quoteInvSettingModel.tax == "Per item"
                            ? pw.Text(
                                'TAX  :',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 8,
                                  color: PdfColors.black,
                                ),
                              )
                            : SizedBox(),
                        otherChargeList.isNotEmpty
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        otherChargeList.isNotEmpty
                            ? pw.Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                    pw.Text(
                                      otherChargeList[0].title!,
                                      style: pw.TextStyle(
                                        font: boldFont,
                                        fontSize: 8,
                                        color: PdfColors.black,
                                      ),
                                    ),
                                    otherChargeList[0].tax! == ""
                                        ? SizedBox()
                                        : pw.Text(
                                            "(${otherChargeList[0].tax!}%)",
                                            style: pw.TextStyle(
                                              font: font,
                                              fontSize: 8,
                                              color: PdfColors.black,
                                            ),
                                          )
                                  ])
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
                              fontSize: 8, color: PdfColors.black, font: font),
                        ),
                        quoteInvSettingModel.discount == "Per item"
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        quoteInvSettingModel.discount == "Per item"
                            ? pw.Text(
                                "- \u{20B9} $subTotalDiscount",
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    color: PdfColors.black,
                                    font: font),
                              )
                            : SizedBox(),
                        quoteInvSettingModel.discount == "On Total"
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        quoteInvSettingModel.discount == "On Total"
                            ? pw.Text(
                                "- \u{20B9} ${totalApplyDisc[1]}",
                                style: pw.TextStyle(
                                    fontSize: 8,
                                    color: PdfColors.black,
                                    font: font),
                              )
                            : SizedBox(),
                        quoteInvSettingModel.tax == "On Total"
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        quoteInvSettingModel.tax == "On Total"
                            ? pw.Text(
                                '\u{20B9} ${totalApplyTax[1]}',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                  color: PdfColors.black,
                                ),
                              )
                            : SizedBox(),
                        quoteInvSettingModel.tax == "Per item"
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        quoteInvSettingModel.tax == "Per item"
                            ? pw.Text(
                                '\u{20B9} $totalTax',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                  color: PdfColors.black,
                                ),
                              )
                            : SizedBox(),
                        otherChargeList.isNotEmpty
                            ? SizedBox(height: 5)
                            : SizedBox(),
                        otherChargeList.isNotEmpty
                            ? pw.Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                  ])
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
            decoration: pw.BoxDecoration(
                color: templateThreePrimary,
                border: const pw.Border(
                    //   right: pw.BorderSide(color: PdfColors.black),
                    bottom: pw.BorderSide(color: PdfColors.grey100),
                    left: pw.BorderSide(color: PdfColors.black))),
            child: pw.Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              pw.Text(
                'GRAND TOTAL :',
                textAlign: TextAlign.right,
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 8,
                  color: templateWhiteColor,
                ),
              ),
              pw.SizedBox(width: 15),
              pw.Text(
                '\u{20B9} $amtDue',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 8,
                  color: templateWhiteColor,
                ),
              ),
            ]),
          ),
        ),

        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: const pw.BoxDecoration(
              border: pw.Border(
                  // bottom: pw.BorderSide(color: PdfColors.black),
                  top: pw.BorderSide(color: PdfColors.black))),
          child: pw.Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pw.Text(
                  quoteInvSettingModel.bottomMsg!,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Note : By accepting this, you agree to bound the following terms and conditions.',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 9,
                    color: PdfColors.black,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Terms and Conditions :',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 9,
                                  color: templateThreePrimary,
                                ),
                              ),
                              pw.SizedBox(height: 8),
                              pw.ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return pw.SizedBox(height: 3);
                                  },
                                  itemBuilder: (context, index) {
                                    var serialNum = index + 1;
                                    return pw.Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            "${serialNum.toString()}. ",
                                            style: pw.TextStyle(
                                              font: font,
                                              fontSize: 9,
                                              color: PdfColors.black,
                                            ),
                                          ),
                                          pw.Expanded(
                                              child: pw.Text(
                                            '${termsList[index].term}',
                                            style: pw.TextStyle(
                                              font: font,
                                              fontSize: 9,
                                              color: PdfColors.black,
                                            ),
                                          ))
                                        ]);
                                  },
                                  itemCount: termsList.length),
                            ]),
                      ),
                      SizedBox(width: 10),
                      quoteInvSettingModel.bankDetails == "Yes"
                          ? pw.Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  pw.Text(
                                    'Bank Details.',
                                    style: pw.TextStyle(
                                      font: boldFont,
                                      fontSize: 9,
                                      color: templateThreePrimary,
                                    ),
                                  ),
                                  pw.SizedBox(height: 8),
                                  pw.Text(
                                    '${businessModel.bankDetails}',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 9,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                ]))
                          : SizedBox(),
                      SizedBox(width: 10),
                      pw.Expanded(
                        child: pw.Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'For , ${businessModel.name!.toUpperCase()}',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 9,
                                  color: PdfColors.black,
                                ),
                              ),
                              pw.SizedBox(height: 8),
                              pw.Image(signature, width: 60, height: 60),
                              pw.SizedBox(height: 10),
                              pw.Text(
                                'Authorised Signature',
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 9,
                                  color: PdfColors.black,
                                ),
                              ),
                            ]),
                      ),
                    ]),
                pw.SizedBox(height: 3),
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

  static pw.Widget buildBody(
      List<ProductModel> partData,
      font,
      labelType,
      boldFont,
      QuoteInvSettingModel quoteInvSettingModel,
      showTaxDiscHSN,
      showTaxDisc,
      showTaxHSN,
      showTax,
      showDiscHSN,
      showDisc,
      showHSN) {
    var headers, data;

    if (showTaxDiscHSN) {
      headers = [
        'SR',
        'PRODUCT',
        'HSN',
        'QTY',
        'PRICE',
        "Disc",
        labelType,
        'TOTAL'
      ];
      data = List.generate(
        partData.length,
        (index) {
          return [
            index + 1,
            partData[index].productName,
            partData[index].productHSNnumber,
            partData[index].productQuantity,
            '\u{20B9} ${partData[index].productPrice}',
            partData[index].discountType == "Percentage"
                ? '\u{20B9} ${partData[index].discountAmt}\n(${partData[index].discountPercentage}%)'
                : '\u{20B9} ${partData[index].discountAmt}',
            "\u{20B9} ${partData[index].productAppliedGST}\n(${partData[index].productGST}%)",
            '\u{20B9} ${partData[index].productTaxAmount}',
          ];
        },
      );
      return pw.TableHelper.fromTextArray(
          headerCellDecoration: BoxDecoration(color: templateThreePrimary),
          border: const TableBorder(
              horizontalInside: BorderSide(
                  width: 1, color: PdfColors.white, style: BorderStyle.solid)),
          headers: headers,
          headerAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
            6: pw.Alignment.centerRight,
            7: pw.Alignment.centerRight,
          },
          cellAlignment: Alignment.center,
          data: data,
          headerStyle: pw.TextStyle(
              fontSize: 8, font: boldFont, color: templateWhiteColor),
          headerDecoration: pw.BoxDecoration(color: templateThreePrimary),
          cellStyle:
              pw.TextStyle(fontSize: 8, font: font, color: PdfColors.black),
          columnWidths: {
            0: const FixedColumnWidth(40),
            1: const FixedColumnWidth(160),
            2: const FixedColumnWidth(50),
            3: const FixedColumnWidth(40),
            4: const FixedColumnWidth(50),
            5: const FixedColumnWidth(50),
            6: const FixedColumnWidth(50),
            7: const FixedColumnWidth(50),
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
            6: pw.Alignment.centerRight,
            7: pw.Alignment.centerRight,
          });
    } else if (showTaxDisc) {
      headers = ['SR', 'PRODUCT', 'QTY', 'PRICE', 'Disc', labelType, 'TOTAL'];
      data = List.generate(
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
            partData[index].discountType == "Percentage"
                ? '\u{20B9} ${partData[index].discountAmt}\n(${partData[index].discountPercentage}%)'
                : '\u{20B9} ${partData[index].discountAmt}',
            "\u{20B9} ${partData[index].productAppliedGST}\n(${partData[index].productGST}%)",
            '\u{20B9} ${partData[index].productTaxAmount}',
          ];
        },
      );
      return pw.TableHelper.fromTextArray(
          headerCellDecoration: BoxDecoration(color: templateThreePrimary),
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
            6: pw.Alignment.centerRight,
          },
          cellAlignment: Alignment.center,
          data: data,
          headerStyle: pw.TextStyle(
              fontSize: 8, font: boldFont, color: templateWhiteColor),
          headerDecoration: pw.BoxDecoration(color: templateThreePrimary),
          cellStyle:
              pw.TextStyle(fontSize: 8, font: font, color: PdfColors.black),
          columnWidths: {
            0: const FlexColumnWidth(1.5),
            1: const FlexColumnWidth(5),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(2.5),
            4: const FlexColumnWidth(2.5),
            5: const FlexColumnWidth(2.5),
            6: const FlexColumnWidth(3),
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
            6: pw.Alignment.centerRight,
          });
    } else if (showTaxHSN) {
      headers = ['SR', 'PRODUCT', 'HSN', 'QTY', 'PRICE', labelType, 'TOTAL'];
      data = List.generate(
        partData.length,
        (index) {
          // double qty = double.parse(partData[index].quantity!);
          // double price = double.parse(partData[index].price!);
          // var total = qty * price;
          return [
            index + 1,
            partData[index].productName,
            partData[index].productHSNnumber,
            partData[index].productQuantity,
            '\u{20B9} ${partData[index].productPrice}',
            "\u{20B9} ${partData[index].productAppliedGST}\n(${partData[index].productGST}%)",
            '\u{20B9} ${partData[index].productTaxAmount}',
          ];
        },
      );
      return pw.TableHelper.fromTextArray(
          headerCellDecoration: BoxDecoration(color: templateThreePrimary),
          border: const TableBorder(
              horizontalInside: BorderSide(
                  width: 1, color: PdfColors.white, style: BorderStyle.solid)),
          headers: headers,
          headerAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
            6: pw.Alignment.centerRight,
          },
          cellAlignment: Alignment.center,
          data: data,
          headerStyle: pw.TextStyle(
              fontSize: 8, font: boldFont, color: templateWhiteColor),
          headerDecoration: pw.BoxDecoration(color: templateThreePrimary),
          cellStyle:
              pw.TextStyle(fontSize: 8, font: font, color: PdfColors.black),
          columnWidths: {
            0: const FixedColumnWidth(40),
            1: const FixedColumnWidth(210),
            2: const FlexColumnWidth(40),
            3: const FixedColumnWidth(40),
            4: const FixedColumnWidth(50),
            5: const FixedColumnWidth(40),
            6: const FlexColumnWidth(40),
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
            6: pw.Alignment.centerRight,
          });
    } else if (showTax) {
      headers = ['SR', 'PRODUCT', 'QTY', 'PRICE', labelType, 'TOTAL'];
      data = List.generate(
        partData.length,
        (index) {
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
      return pw.TableHelper.fromTextArray(
          defaultColumnWidth: const FixedColumnWidth(200.0),
          headerCellDecoration: BoxDecoration(color: templateThreePrimary),
          border: const TableBorder(
              horizontalInside: BorderSide(
                  width: 1, color: PdfColors.white, style: BorderStyle.solid)),
          headers: headers,
          headerAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          },
          cellAlignment: Alignment.center,
          data: data,
          headerStyle: pw.TextStyle(
              fontSize: 8, font: boldFont, color: templateWhiteColor),
          headerDecoration: pw.BoxDecoration(color: templateThreePrimary),
          cellStyle:
              pw.TextStyle(fontSize: 8, font: font, color: PdfColors.black),
          columnWidths: {
            0: const FlexColumnWidth(20),
            1: const FlexColumnWidth(140),
            2: const FlexColumnWidth(30),
            3: const FlexColumnWidth(40),
            4: const FlexColumnWidth(50),
            5: const FlexColumnWidth(60),
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          });
    } else if (showDiscHSN) {
      headers = ['SR', 'PRODUCT', 'HSN', 'QTY', 'PRICE', 'Disc', 'TOTAL'];
      data = List.generate(
        partData.length,
        (index) {
          // double qty = double.parse(partData[index].quantity!);
          // double price = double.parse(partData[index].price!);
          // var total = qty * price;
          return [
            index + 1,
            partData[index].productName,
            partData[index].productHSNnumber,
            partData[index].productQuantity,
            '\u{20B9} ${partData[index].productPrice}',
            partData[index].discountType == "Percentage"
                ? '\u{20B9} ${partData[index].discountAmt}\n(${partData[index].discountPercentage}%)'
                : '\u{20B9} ${partData[index].discountAmt}',
            '\u{20B9} ${partData[index].productTaxAmount}',
          ];
        },
      );
      return pw.TableHelper.fromTextArray(
          headerCellDecoration: BoxDecoration(color: templateThreePrimary),
          border: const TableBorder(
              horizontalInside: BorderSide(
                  width: 1, color: PdfColors.white, style: BorderStyle.solid)),
          headers: headers,
          headerAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
            6: pw.Alignment.centerRight,
          },
          cellAlignment: Alignment.center,
          data: data,
          headerStyle: pw.TextStyle(
              fontSize: 8, font: boldFont, color: templateWhiteColor),
          headerDecoration: pw.BoxDecoration(color: templateThreePrimary),
          cellStyle:
              pw.TextStyle(fontSize: 8, font: font, color: PdfColors.black),
          columnWidths: {
            0: const FixedColumnWidth(40),
            1: const FixedColumnWidth(180),
            2: const FlexColumnWidth(60),
            3: const FixedColumnWidth(40),
            4: const FixedColumnWidth(50),
            5: const FixedColumnWidth(50),
            6: const FlexColumnWidth(70),
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
            6: pw.Alignment.centerRight,
          });
    } else if (showDisc) {
      headers = ['SR', 'PRODUCT', 'QTY', 'PRICE', "Disc", 'TOTAL'];
      data = List.generate(
        partData.length,
        (index) {
          return [
            index + 1,
            partData[index].productName,
            partData[index].productQuantity,
            '\u{20B9} ${partData[index].productPrice}',
            partData[index].discountType == "Percentage"
                ? '\u{20B9} ${partData[index].discountAmt}\n(${partData[index].discountPercentage}%)'
                : '\u{20B9} ${partData[index].discountAmt}',
            '\u{20B9} ${partData[index].productTaxAmount}',
          ];
        },
      );
      return pw.TableHelper.fromTextArray(
          headerCellDecoration: BoxDecoration(color: templateThreePrimary),
          border: const TableBorder(
              horizontalInside: BorderSide(
                  width: 1, color: PdfColors.white, style: BorderStyle.solid)),
          headers: headers,
          headerAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          },
          cellAlignment: Alignment.center,
          data: data,
          headerStyle: pw.TextStyle(
              fontSize: 8, font: boldFont, color: templateWhiteColor),
          headerDecoration: pw.BoxDecoration(color: templateThreePrimary),
          cellStyle:
              pw.TextStyle(fontSize: 8, font: font, color: PdfColors.black),
          columnWidths: {
            0: const FlexColumnWidth(1),
            1: const FlexColumnWidth(6),
            2: const FlexColumnWidth(1),
            3: const FlexColumnWidth(2),
            4: const FlexColumnWidth(2),
            5: const FlexColumnWidth(3),
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          });
    } else if (showHSN) {
      headers = ['SR', 'PRODUCT', 'HSN', 'QTY', 'PRICE', 'TOTAL'];
      data = List.generate(
        partData.length,
        (index) {
          // double qty = double.parse(partData[index].quantity!);
          // double price = double.parse(partData[index].price!);
          // var total = qty * price;
          return [
            index + 1,
            partData[index].productName,
            partData[index].productHSNnumber,
            partData[index].productQuantity,
            '\u{20B9} ${partData[index].productPrice}',
            '\u{20B9} ${partData[index].productTaxAmount}',
          ];
        },
      );
      return pw.TableHelper.fromTextArray(
          headerCellDecoration: BoxDecoration(color: templateThreePrimary),
          border: const TableBorder(
              horizontalInside: BorderSide(
                  width: 1, color: PdfColors.white, style: BorderStyle.solid)),
          headers: headers,
          headerAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          },
          cellAlignment: Alignment.center,
          data: data,
          headerStyle: pw.TextStyle(
              fontSize: 8, font: boldFont, color: templateWhiteColor),
          headerDecoration: pw.BoxDecoration(color: templateThreePrimary),
          cellStyle:
              pw.TextStyle(fontSize: 8, font: font, color: PdfColors.black),
          columnWidths: {
            0: const FixedColumnWidth(40),
            1: const FixedColumnWidth(260),
            2: const FlexColumnWidth(30),
            3: const FixedColumnWidth(40),
            4: const FixedColumnWidth(40),
            5: const FlexColumnWidth(30),
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          });
    } else {
      headers = ['SR', 'PRODUCT', 'QTY', 'PRICE', 'TOTAL'];
      data = List.generate(
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
            '\u{20B9} ${partData[index].productTaxAmount}',
          ];
        },
      );
      return pw.TableHelper.fromTextArray(
          headerCellDecoration: BoxDecoration(color: templateThreePrimary),
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
          },
          cellAlignment: Alignment.center,
          data: data,
          headerStyle: pw.TextStyle(
              fontSize: 8, font: boldFont, color: templateWhiteColor),
          headerDecoration: pw.BoxDecoration(color: templateThreePrimary),
          cellStyle:
              pw.TextStyle(fontSize: 8, font: font, color: PdfColors.black),
          columnWidths: {
            0: const FlexColumnWidth(20),
            1: const FlexColumnWidth(130),
            2: const FlexColumnWidth(30),
            3: const FlexColumnWidth(40),
            4: const FlexColumnWidth(40),
          },
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
          });
    }
  }
}
