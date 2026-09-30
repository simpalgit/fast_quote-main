import 'dart:convert';

import 'package:fast_quote/Screens/Settings/Components/Profile/profile_model.dart';
import 'package:fast_quote/Screens/Settings/Components/SubscriptionScreen/plan_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/Painter/payment_result.dart';
import 'package:fast_quote/Widgets/common_loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class PaymentGatwayResponse extends StatefulWidget {
  final CheckPaymentModel paymentResponse;
  const PaymentGatwayResponse({super.key, required this.paymentResponse});

  @override
  State<PaymentGatwayResponse> createState() => _PaymentGatwayResponseState();
}

class _PaymentGatwayResponseState extends State<PaymentGatwayResponse> {
  bool successStatus = true;
  bool isLoading = true;

  @override
  void initState() {
    setStatusBarColor(primaryColor);

    getSaveData();

    super.initState();
  }

  ProfileModel storedModel = ProfileModel();
  String type = "", transId = "", cardType = "";
  var amount = "";

  bool isCard = false;

  getSaveData() async {
    setState(() {
      isLoading = true;
    });

    storedModel = await CommonFunctions().getStoredProfileData();
    response = widget.paymentResponse;

    var paymentInstrument = json.decode(response.data!.paymentInstrument!);

    setState(() {
      amount = (response.data!.amount! / 100).toString();
      if (paymentInstrument != null) {
        type = paymentInstrument["type"];
        if (type == "UPI") {
          transId = paymentInstrument["utr"];
        } else {
          if (type == "CARD") {
            isCard = true;
            cardType = paymentInstrument["cardType"];
          } else {
            isCard = false;
          }
          transId = paymentInstrument["pgTransactionId"];
        }
      }
    });

    if (response.code == "PAYMENT_SUCCESS") {
      setState(() {
        successStatus = true;
      });
    } else {
      setState(() {
        successStatus = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    setStatusBarColor(bgColor);

    super.dispose();
  }

  CheckPaymentModel response = CheckPaymentModel();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.homeScreen, (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: isLoading
            ? Center(
                child: progressIndicator(context),
              )
            : Center(child: successStatus ? successWidget() : failedWidget()),
      ),
    );
  }

  Widget successWidget() {
    return Container(
      height: 500, //Add height as per requirement
      width: 500, //Add width as per requirement,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 15.0, spreadRadius: 1.0),
      ]),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ClipPath(
        clipper: DolDurmaClipper(holeRadius: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/status_success.svg',
                height: 50.h,
              ),
              SizedBox(
                height: 10.h,
              ),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                    color: Color(0xFF0fe600),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
              SizedBox(
                height: 12.h,
              ),
              TransactionHeaderTextHelper(
                title: "Transaction id",
                value: response.data!.transactionId!,
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TransactionTextHelper(
                      title: 'Payment Type :',
                      value: type,
                    ),
                    const SizedBox(height: 7),
                    TransactionTextHelper(
                      title: type == "UPI" ? "utr" : "transId",
                      value: transId,
                    ),
                    const SizedBox(height: 7),
                    isCard
                        ? TransactionTextHelper(
                            title: 'Card :',
                            value: cardType,
                          )
                        : const SizedBox(),
                    isCard ? const SizedBox(height: 7) : const SizedBox(),
                    TransactionTextHelper(
                      title: 'Mobile :',
                      value: storedModel.phone!,
                    ),
                    const SizedBox(height: 7),
                    TransactionTextHelper(
                      title: 'Email :',
                      value: storedModel.email!,
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount paid",
                          style: TextStyle(
                              fontSize: 12.5.sp,
                              color: const Color.fromARGB(255, 122, 120, 142),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1),
                        ),
                        Text(
                          "\u{20B9} $amount",
                          style: TextStyle(
                              fontSize: 12.5,
                              color: const Color.fromARGB(255, 57, 57, 58),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouteNames.homeScreen, (route) => false);
                  },
                  child: const Text('Close'))
            ],
          ),
        ),
      ),
    );
  }

  Widget failedWidget() {
    return Container(
      height: 500, //Add height as per requirement
      width: 500, //Add width as per requirement,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 15.0, spreadRadius: 1.0),
      ]),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ClipPath(
        clipper: DolDurmaClipper(holeRadius: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2)),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                    size: 45,
                  )),
              SizedBox(
                height: 10,
              ),
              const Text(
                'Payment Failed!',
                style: TextStyle(
                    color: Color(0xFFff0000),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
              SizedBox(
                height: 12.h,
              ),
              TransactionHeaderTextHelper(
                title: "Transaction No",
                value: response.data!.transactionId!,
              ),
              SizedBox(
                height: 50.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TransactionTextHelper(
                      title: 'Mobile :',
                      value: storedModel.phone!,
                    ),
                    const SizedBox(height: 7),
                    TransactionTextHelper(
                      title: 'Email :',
                      value: storedModel.email!,
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount :",
                          style: TextStyle(
                              fontSize: 12.5.sp,
                              color: const Color.fromARGB(255, 122, 120, 142),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1),
                        ),
                        Text(
                          "\u{20B9} $amount",
                          style: TextStyle(
                              fontSize: 12.5.sp,
                              color: const Color.fromARGB(255, 57, 57, 58),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionHeaderTextHelper extends StatelessWidget {
  final String title, value;
  const TransactionHeaderTextHelper(
      {super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 11,
              color: const Color.fromARGB(255, 122, 120, 142),
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        ),
        SizedBox(
          width: 5.h,
        ),
        const Text(
          ":",
          style: TextStyle(
              color: Color.fromARGB(255, 122, 120, 142),
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        ),
        SizedBox(
          width: 5.h,
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 11.sp,
              color: const Color.fromARGB(255, 122, 120, 142),
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        ),
      ],
    );
  }
}

class TransactionTextHelper extends StatelessWidget {
  final String title, value;
  const TransactionTextHelper(
      {super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 11.sp,
              color: const Color.fromARGB(255, 122, 120, 142),
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 11.sp,
              color: const Color.fromARGB(255, 57, 57, 58),
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
      ],
    );
  }
}
