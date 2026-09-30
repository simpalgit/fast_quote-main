import 'dart:convert';
import 'dart:developer';

import 'package:fast_quote/Screens/Auth/internet_provider.dart';
import 'package:fast_quote/Screens/PaymentGateway/payment_gateway_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/constants.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Widgets/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart' as nbutils;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'plan_model.dart';
import 'subscription_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  SubscriptionScreenState createState() => SubscriptionScreenState();
}

class SubscriptionScreenState extends State<SubscriptionScreen> {
  SettingsRepository settingsRepository = SettingsRepository();
  final TextEditingController _logController = TextEditingController();
  bool isUpdateStatus = false;

  List<PlanModal> periodModal = [];
  List<FaqModel> faqList = [
    FaqModel(
        question: "Is it possible to terminate my subscription post-purchase?",
        answer: "No, You Can Not Cancel Your Subscription After Purchase."),
    FaqModel(
        question:
            "Is it permissible to alter my plan after making the purchase?",
        answer: "Yes, You Can Upgrade Your Plan."),
    FaqModel(
        question: "Is it acceptable to use alternative payment methods?",
        answer:
            "The Fast Quote accept various payment methods for their services."),
    FaqModel(
        question:
            "What happens if my payment is accepted but my subscription isn't running?",
        answer:
            "Processing Time Sometimes, there might be a delay between a successful payment and the activation of your subscription. It could take a short while for the system to update and activate your subscription."),
    FaqModel(
        question:
            "What if my account is debited, but the UPI payment is not confirmed?",
        answer:
            "Wait for Confirmation: Sometimes, UPI payments might take a little longer to confirm due to various reasons such as network issues or bank processing delays. Check your UPI app or banking statement to see if the transaction has been processed or is pending."),
    FaqModel(
        question:
            "What happens if the upi payment fails and the account is debited with money?",
        answer:
            "Check Transaction Status: Verify the status of the transaction within your UPI app or through your bank. If the payment is showing as failed or pending, take note of the transaction ID and related details."),
  ];
  int selectIndex = 1, tableRecord = 0, subId = 0;
  int containerIndex = 0;
  final _razorpay = Razorpay();
  Color screenColor = const Color(0xFFEBA791);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<SubscriptionProvider>(context, listen: false);
      provider.getSubscriptionDetails(context).then((value) {
        selectIndex = provider.storedModel.subscription!.subId! - 1;
        tableRecord = provider.storedModel.subscription!.id!;
        subId = provider.storedModel.subscription!.subId!;
      });
    });

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // init();
  }

  int selectedSubscriptionId = 1;
  ScrollController _scrollController = ScrollController();

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      isUpdateStatus = true;
    });
    getTransactionDetails(response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isUpdateStatus = false;
    });
    CommonFunctions.showErrorSnackbar(context, response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      isUpdateStatus = false;
    });
    // Do something when an external wallet is selected
  }

  void createOrder(int amount) async {
    String username = 'rzp_live_xkGkdJ7HK27mh0'; // razorpay live pay key
    String password = "pvhMYBDwyulVq55flN76PEGn"; // razoepay live secret key
    // String username = 'rzp_test_aoRHClTQjks0Iw'; // razorpay test pay key
    // String password = "tPvqvdu2bYDtwSR5w9eQa8oh"; // razoepay test secret key

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": amount,
      "currency": "INR",
      "receipt": "receipt#1"
    };
    var res = await http.post(
      Uri.https("api.razorpay.com", "v1/orders"),
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      openCheckout(
          jsonDecode(res.body)['id'], jsonDecode(res.body)['amount']); // 😎🔥
    }
  }

  void getTransactionDetails(String payId) async {
    String username = 'rzp_live_xkGkdJ7HK27mh0'; // razorpay live pay key
    String password = "pvhMYBDwyulVq55flN76PEGn"; // razoepay live secret key
    // String username = 'rzp_test_aoRHClTQjks0Iw'; // razorpay test pay key
    // String password = "tPvqvdu2bYDtwSR5w9eQa8oh"; // razoepay test secret key
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    var res = await http.get(
      Uri.parse("https://api.razorpay.com/v1/payments/$payId"),
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
        'Accept': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      var decodedData = json.decode(res.body);
      log("Card : ${res.body}");

      var response = PaymentResponse.fromJson(decodedData);

      updateSubcription(context, response, selectedSubscriptionId, tableRecord)
          .then((value) {
        final provider =
            Provider.of<SubscriptionProvider>(context, listen: false);

        provider.postPaymentResponse(
            context, response, selectedSubscriptionId, "success", "razorpay");
      });
    } else {
      CommonFunctions.showErrorSnackbar(context, "Something went wrong.");
      setState(() {
        isUpdateStatus = false;
      });
    }
  }

  Future updateSubcription(BuildContext context, var response,
      int selectedSubscriptionId, int tableRecord) async {
    DateTime currentDate = DateTime.now();
    var storedModel = await CommonFunctions().getStoredProfileData();
    dynamic passedData;
    if (selectedSubscriptionId == 2) {
      var afterOneYearDate = currentDate.add(const Duration(days: 365));
      passedData = json.encode({
        "company_id": storedModel.id,
        "user_id": storedModel.id,
        "start_date": currentDate.toIso8601String(),
        "end_date": afterOneYearDate.toIso8601String(),
        "sub_id": selectedSubscriptionId.toString(),
      });
    } else if (selectedSubscriptionId == 3) {
      var afterOneYearDate = currentDate.add(const Duration(days: 365));
      passedData = json.encode({
        "company_id": "",
        "user_id": storedModel.id,
        "start_date": currentDate.toIso8601String(),
        "end_date": afterOneYearDate.toIso8601String(),
        "sub_id": selectedSubscriptionId.toString(),
      });
    }

    var result = await settingsRepository.upgradeSubscription(
        context, passedData, tableRecord);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      setState(() {
        isUpdateStatus = false;
      });
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.homeScreen, (route) => false);
    }, (data) {
      setState(() {
        isUpdateStatus = false;
      });
      CommonFunctions.showSuccessSnackbar(
          "Subscription activated. Use your new features.");
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.homeScreen, (route) => false);
    });
  }

  void openCheckout(String orderId, var amt) async {
    var options = {
      'key': 'rzp_live_xkGkdJ7HK27mh0', //live
      // 'key': 'rzp_test_aoRHClTQjks0Iw', //test
      "amount": amt, //in the smallest currency sub-unit.
      'name': 'Webvision',
      'order_id': orderId, // Generate order_id using Orders API
      'description': 'Webvision',
      'timeout': 300, // in seconds
      //  'prefill': {'contact': '9930034224', 'email': 'info@hdpartypal.com'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  double daysLeft = 50;
  double daysCompleted = 100;

  @override
  Widget build(BuildContext context) {
    // double percent = daysCompleted / daysLeft;
    final provider = Provider.of<SubscriptionProvider>(
      context,
    );
    var networkStatus = Provider.of<NetworkStatus>(context);

    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: networkStatus == NetworkStatus.online
              ? isUpdateStatus
                  ? const Center(child: CircularProgressIndicator())
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverAppBar(
                          backgroundColor: primaryColor,
                          expandedHeight: 250.0,
                          elevation: 0,
                          pinned: true,
                          iconTheme: const IconThemeData(
                            color: Colors.white,
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                'Choose Subscription',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            background: Image.asset(
                              'assets/images/subscription_image.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate([
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _logController,
                                ),
                                16.height,
                                ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 5.h,
                                    );
                                  },
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.subscriptionList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (_, int index) {
                                    var data = provider.subscriptionList[index];

                                    bool value = selectIndex == index;
                                    bool selectedSubvalue =
                                        (selectIndex == index &&
                                            selectIndex ==
                                                provider.storedModel
                                                        .subscription!.subId! -
                                                    1);
                                    return Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            boxShadow: value
                                                ? selectedSubvalue
                                                    ? []
                                                    : []
                                                : [
                                                    BoxShadow(
                                                        color: primaryColor,
                                                        blurRadius: 3.0,
                                                        spreadRadius: 1),
                                                  ],
                                            color: value
                                                ? selectedSubvalue
                                                    ? provider
                                                            .storedModel
                                                            .subscription!
                                                            .status!
                                                        ? Colors.red
                                                            .withOpacity(0.3)
                                                        : Colors.amber
                                                            .withOpacity(0.2)
                                                    : primaryColor
                                                        .withOpacity(0.3)
                                                : context.cardColor,
                                            borderRadius: BorderRadius.circular(
                                                nbutils.defaultRadius),
                                            border: value
                                                ? selectedSubvalue
                                                    ? Border.all(
                                                        color: blackColor,
                                                        width: 1)
                                                    : Border.all(
                                                        color: primaryColor,
                                                        width: 2)
                                                : Border.all(
                                                    color: Colors.white,
                                                    width: 1)),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: context.cardColor,
                                                    shape: BoxShape.circle,
                                                    border: value
                                                        ? selectedSubvalue
                                                            ? Border.all(
                                                                color: Colors
                                                                    .black)
                                                            : Border.all(
                                                                color: Colors
                                                                    .white)
                                                        : Border.all(
                                                            color: Colors.blue),
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    size: 14,
                                                  ).visible(value).center(),
                                                ),
                                                12.width,
                                                Text(data.title!,
                                                        style: nbutils
                                                            .boldTextStyle(
                                                                size: 16,
                                                                color:
                                                                    primaryColor))
                                                    .expand(),
                                                data.cost.toString() == "0"
                                                    ? const SizedBox()
                                                    : index == subId - 1
                                                        ? provider
                                                                    .storedModel
                                                                    .subscription!
                                                                    .subId !=
                                                                1
                                                            ? Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        24,
                                                                    vertical:
                                                                        8),
                                                                decoration: BoxDecoration(
                                                                    color: primaryColor
                                                                        .withOpacity(
                                                                            0.8),
                                                                    borderRadius:
                                                                        nbutils.radius(
                                                                            nbutils.defaultRadius)),
                                                                child: Text(
                                                                  'Renew',
                                                                  style: nbutils
                                                                      .secondaryTextStyle(
                                                                          color:
                                                                              whiteColor),
                                                                ),
                                                              ).onTap(() {
                                                                setState(() {
                                                                  selectedSubscriptionId =
                                                                      data.id!;
                                                                });

                                                                showPopUp(
                                                                  context:
                                                                      context,
                                                                  screenHeight:
                                                                      size.height,
                                                                  screenWidth:
                                                                      size.width,
                                                                  onPhonePayClick:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    provider.createJsonFunction(
                                                                        "",
                                                                        context,
                                                                        selectedSubscriptionId,
                                                                        tableRecord,
                                                                        data.offerCost! *
                                                                            100);
                                                                  },
                                                                  onRazorPayClick:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    createOrder(
                                                                        data.offerCost! *
                                                                            100);
                                                                  },
                                                                );
                                                              })
                                                            : Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        24,
                                                                    vertical:
                                                                        8),
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:
                                                                            blackColor),
                                                                    color: Colors
                                                                        .amber,
                                                                    borderRadius:
                                                                        nbutils.radius(
                                                                            nbutils.defaultRadius)),
                                                                child: Text(
                                                                    'Current',
                                                                    style: nbutils
                                                                        .secondaryTextStyle(
                                                                            color:
                                                                                blackColor)),
                                                              )
                                                        : Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        24,
                                                                    vertical:
                                                                        8),
                                                            decoration: BoxDecoration(
                                                                color: primaryColor
                                                                    .withOpacity(
                                                                        0.8),
                                                                borderRadius:
                                                                    nbutils.radius(
                                                                        nbutils
                                                                            .defaultRadius)),
                                                            child: Text(
                                                                'Upgrade',
                                                                style: nbutils
                                                                    .secondaryTextStyle(
                                                                        color:
                                                                            whiteColor)),
                                                          ).onTap(() {
                                                            setState(() {
                                                              selectedSubscriptionId =
                                                                  data.id!;
                                                            });

                                                            showPopUp(
                                                              context: context,
                                                              screenHeight:
                                                                  size.height,
                                                              screenWidth:
                                                                  size.width,
                                                              onPhonePayClick:
                                                                  () {
                                                                Navigator.pop(
                                                                    context);
                                                                provider.createJsonFunction(
                                                                    "",
                                                                    context,
                                                                    selectedSubscriptionId,
                                                                    tableRecord,
                                                                    data.offerCost! *
                                                                        100);
                                                              },
                                                              onRazorPayClick:
                                                                  () {
                                                                Navigator.pop(
                                                                    context);
                                                                createOrder(
                                                                    data.offerCost! *
                                                                        100);
                                                              },
                                                            );
                                                          }),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            ExpansionTile(
                                              title: Text(
                                                "Benefits",
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1),
                                              ),
                                              children: <Widget>[
                                                ListView.separated(
                                                    padding: EdgeInsets.only(
                                                        left: 10.w,
                                                        right: 10.w,
                                                        bottom: 10.h),
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Text(
                                                        data.benefits![index],
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            letterSpacing: 0.5,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return const SizedBox(
                                                        height: 10,
                                                      );
                                                    },
                                                    itemCount:
                                                        data.benefits!.length)
                                              ],
                                            ),
                                            value && selectedSubvalue
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 20),
                                                      LinearPercentIndicator(
                                                        leading: Icon(
                                                          Icons.circle,
                                                          color: provider
                                                                  .storedModel
                                                                  .subscription!
                                                                  .status!
                                                              ? Colors.red
                                                              : provider.percent >=
                                                                      0.6
                                                                  ? Colors.green
                                                                  : provider.percent <
                                                                              0.6 &&
                                                                          provider.percent >
                                                                              0.2
                                                                      ? const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          59,
                                                                          82,
                                                                          255)
                                                                      : Colors
                                                                          .red,
                                                          size: 15.sp,
                                                        ),
                                                        restartAnimation: false,
                                                        animation: true,
                                                        fillColor:
                                                            Colors.transparent,
                                                        animateFromLastPercent:
                                                            true,
                                                        animationDuration: 1000,
                                                        width: 300.0,
                                                        lineHeight: 14.0,
                                                        percent:
                                                            provider.percent,
                                                        backgroundColor:
                                                            Colors.white,
                                                        barRadius: const Radius
                                                            .circular(16),
                                                        progressColor: provider
                                                                .storedModel
                                                                .subscription!
                                                                .status!
                                                            ? Colors.red
                                                            : provider.percent >=
                                                                    0.6
                                                                ? Colors.green
                                                                : provider.percent <
                                                                            0.6 &&
                                                                        provider.percent >
                                                                            0.2
                                                                    ? const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        59,
                                                                        82,
                                                                        255)
                                                                    : Colors
                                                                        .red,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      provider
                                                              .storedModel
                                                              .subscription!
                                                              .status!
                                                          ? Text(
                                                              provider.storedModel.subscription!
                                                                          .subId ==
                                                                      1
                                                                  ? "Your Trial is Expired."
                                                                  : "Your Subscription is Expired.",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red))
                                                          : Text(
                                                              "${provider.storedModel.subscription!.remainingDays!.toString()} Days Remaining out of ${provider.storedModel.subscription!.totalDays!.toString()} ",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      primaryColor)),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                            data.cost.toString() == "0"
                                                ? const SizedBox()
                                                : const SizedBox(
                                                    height: 10,
                                                  ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                data.cost.toString() == "0"
                                                    ? const SizedBox()
                                                    : Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5,
                                                                horizontal: 18),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .green[100],
                                                            border: Border.all(
                                                                color: const Color
                                                                    .fromRGBO(
                                                                    27,
                                                                    94,
                                                                    32,
                                                                    1)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child: Text(
                                                          '50% Off',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green[900]),
                                                        ),
                                                      ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                        data.cost.toString() ==
                                                                "0"
                                                            ? ""
                                                            : "\u{20B9} ${data.cost.toString()}",
                                                        style: TextStyle(
                                                            fontSize: 12.5.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough)),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        data.offerCost
                                                                    .toString() ==
                                                                "0"
                                                            ? ""
                                                            : "\u{20B9} ${data.offerCost.toString()}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13.sp,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                24, 121, 27))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        )).onTap(
                                      () {
                                        selectIndex = index;

                                        setState(() {});
                                      },
                                      borderRadius: nbutils.radius(16),
                                    ).paddingSymmetric(
                                        horizontal: 16, vertical: 4);
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    boxShadow: [
                                      BoxShadow(
                                          color: primaryColor,
                                          blurRadius: 1.0,
                                          spreadRadius: 1),
                                    ],
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 8.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 12.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Priority Privileges',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 15.h),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: primaryColor),
                                            color:
                                                primaryColor.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/subscription_gift.svg",
                                                    height: size.width * 0.2,
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    'Exclusive Offers',
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2.h,
                                                  ),
                                                  Text(
                                                    'Offers roud the year',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: secondary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/images/subscription_support.svg",
                                                    height: size.width * 0.2,
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    'Priority 24x7',
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2.h,
                                                  ),
                                                  Text(
                                                    'Customer Support',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: secondary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Text(
                                        'FAQ',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color:
                                                primaryColor.withOpacity(0.7),
                                            elevation: 0,
                                            clipBehavior: Clip.antiAlias,
                                            margin: EdgeInsets.zero,
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  dividerColor:
                                                      Colors.transparent),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 3),
                                                child: ListTileTheme(
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  dense: true,
                                                  horizontalTitleGap: 0.0,
                                                  minLeadingWidth: 0,
                                                  child: ExpansionTile(
                                                    iconColor: whiteColor,
                                                    collapsedIconColor:
                                                        whiteColor,
                                                    title: Text(
                                                      faqList[index].question!,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: whiteColor,
                                                          letterSpacing: 0.7,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    expandedCrossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Column(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8.w),
                                                            width:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7.r)),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 10.h,
                                                                ),
                                                                Text(
                                                                  faqList[index]
                                                                      .answer!,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11.sp,
                                                                      color:
                                                                          primaryColor,
                                                                      letterSpacing:
                                                                          0.7,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                SizedBox(
                                                                  height: 10.h,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 5.h,
                                          );
                                        },
                                        itemCount: faqList.length,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ).paddingBottom(16),
                          ),
                        ]))
                      ],
                    )
              : const NoInternetWidget()),
    );
  }

  showPopUp({
    required BuildContext context,
    required double screenHeight,
    required double screenWidth,
    required VoidCallback onRazorPayClick,
    required VoidCallback onPhonePayClick,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Select Payment method",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ColumnAssetsImageTextHelper(
                      imagePath: 'assets/images/razorpay.jpeg',
                      title: 'RazorPay',
                      onCLicked: onRazorPayClick,
                      sHeight: screenHeight,
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    ColumnAssetsImageTextHelper(
                      imagePath: 'assets/images/phonepe.png',
                      title: 'PhonePay',
                      onCLicked: onPhonePayClick,
                      sHeight: screenHeight,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        });
  }
}

class FaqModel {
  final String? question;
  final String? answer;

  FaqModel({this.question, this.answer});
}
