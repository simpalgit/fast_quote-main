import 'dart:convert';
import 'dart:io';

import 'package:fast_quote/Screens/Settings/Components/Profile/profile_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:fast_quote/Utils/route_names.dart';
import 'package:fast_quote/Utils/iap_service.dart';
import 'package:fast_quote/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../Auth/PaymentGateway/create_json.dart';
import 'plan_model.dart';

class SubscriptionProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<SubscriptionModel> _subscriptionList = [];
  List<SubscriptionModel> get subscriptionList => _subscriptionList;

  ProfileModel _storedModel = ProfileModel();
  ProfileModel get storedModel => _storedModel;

  final IAPService _iapService = IAPService();
  List<ProductDetails> _iapProducts = [];
  List<ProductDetails> get iapProducts => _iapProducts;

  SubscriptionProvider() {
    if (Platform.isIOS) {
      _iapService.initialize();
      _iapService.onPurchaseSuccess = _handleIAPPurchaseSuccess;
      _iapService.onPurchaseError = (error) {
        if (NavigationService.navigatorKey.currentContext != null) {
          CommonFunctions.showErrorSnackbar(
            NavigationService.navigatorKey.currentContext!,
            error,
          );
        }
      };
    }
  }

  void _handleIAPPurchaseSuccess(PurchaseDetails purchase) {
    int subId = 2;
    if (purchase.productID == 'plan_3_yearly') {
      subId = 3;
    }

    var response = {
      "orderId": purchase.purchaseID,
      "id": purchase.transactionDate,
      "amount": 0,
      "status": "COMPLETED",
    };

    if (NavigationService.navigatorKey.currentContext != null) {
      updateSubcription(
        NavigationService.navigatorKey.currentContext!,
        response,
        subId,
        _storedModel.subscription!.id!,
      );
    }
  }

  Future loadIAPProducts() async {
    if (Platform.isIOS) {
      // Replace these with actual product IDs from App Store Connect
      List<String> productIds = ['plan_2_yearly', 'plan_3_yearly'];
      _iapProducts = await _iapService.getProducts(productIds);
      notifyListeners();
    }
  }

  Future startIAPPurchase(int subId) async {
    String productId = subId == 2 ? 'plan_2_yearly' : 'plan_3_yearly';
    var product = _iapProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception("Product not found"),
    );
    await _iapService.buyProduct(product);
  }

  initData() {
    _isLoading = false;
    _subscriptionList.clear();
  }

  void isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  double _percent = 0.0;
  double get percent => _percent;

  getProfileStoredData() async {
    _storedModel = await CommonFunctions().getStoredProfileData();

    if (!_storedModel.subscription!.status!) {
      var per =
          (storedModel.subscription!.totalDays! -
              storedModel.subscription!.remainingDays!) /
          storedModel.subscription!.totalDays!;

      _percent = 1.0 - per;
    } else {
      _percent = 0.0;
    }
    //}

    notifyListeners();
  }

  Future getSubscriptionDetails(BuildContext context) async {
    CommonFunctions.showProgressBar(context);

    isLoadingFun(true);
    initData();
    await getProfileStoredData();
    var result = await settingsRepository.getSubscription(context);

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
        isLoadingFun(false);
        Navigator.pop(context);
      },
      (data) {
        _subscriptionList = data;
        isLoadingFun(false);
        Navigator.pop(context);
      },
    );
  }

  InitPaymentModel initPaymentModel = InitPaymentModel();
  String _merchantTransactionId = "";
  String get merchantTransactionId => _merchantTransactionId;

  Future createJsonFunction(
    String targetApp,
    BuildContext context,
    selectedSubscriptionId,
    tableRecord,
    int amount,
  ) async {
    var storedModel = await CommonFunctions().getStoredProfileData();
    _merchantTransactionId = idGenerator();
    var encodedString = createJson(
      merachantId: ReomteUrl.liveMerchatID,
      merchantTransactionId: _merchantTransactionId,
      merchantUserId: storedModel.id!,
      amount: amount,
      // amount: 100,
      redirectUrl: "/callback",
      redirectMode: "POST",
      callbackUrl: "/callback",
      mobileNumber: storedModel.phone,
      targetApp: targetApp,
    );

    String base64Data = convertJsonToBase64(encodedString);

    var dada = "$base64Data/pg/v1/pay${ReomteUrl.liveSaltKey}";

    String newSHA256 = await sha256New(base: dada);

    startTransaction(
      context,
      base64Data,
      newSHA256,
      selectedSubscriptionId,
      tableRecord,
    );
  }

  Future startTransaction(
    BuildContext context,
    String base64Data,
    String newSHA256,
    selectedSubscriptionId,
    tableRecord,
  ) async {
    var passedData = json.encode({"request": base64Data});

    var result = await settingsRepository.startSomthing(
      context,
      passedData,
      newSHA256,
    );

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
      },
      (data) {
        initPaymentModel = data;

        var urldata =
            initPaymentModel.data!.instrumentResponse!.redirectInfo!.url!;

        comeBack(
          context,
          urldata.toString(),
          selectedSubscriptionId,
          tableRecord,
        );
      },
    );
  }

  Future comeBack(
    BuildContext context,
    String url,
    selectedSubscriptionId,
    tableRecord,
  ) async {
    var data = await Navigator.of(
      context,
    ).pushNamed(RouteNames.paymentGatewayScreen, arguments: {"url": url});
    if (!context.mounted) return;
    String newSHA256 = await statusSha256New(
      transactionId: _merchantTransactionId,
    );
    if (data != null) {
      checkTransactionStatus(
        context,
        newSHA256,
        _merchantTransactionId,
        selectedSubscriptionId,
        tableRecord,
      );
    } else {
      checkTransactionStatus(
        context,
        newSHA256,
        _merchantTransactionId,
        selectedSubscriptionId,
        tableRecord,
      );
    }
  }

  Future checkTransactionStatus(
    BuildContext context,
    String newSHA256,
    String merchantTransactionId,
    selectedSubscriptionId,
    tableRecord,
  ) async {
    var result = await settingsRepository.getTransactionStatus(
      context,
      newSHA256,
      merchantTransactionId,
    );

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.homeScreen,
          (route) => false,
        );
      },
      (data) {
        if (data != "error") {
          if (data.code == "PAYMENT_SUCCESS") {
            postPaymentResponse(
              context,
              data,
              selectedSubscriptionId,
              "success",
              "phonepay",
            ).then((value) {
              updateSubcription(
                context,
                data,
                selectedSubscriptionId,
                tableRecord,
              );
            });
          } else if (data.code == "PAYMENT_ERROR") {
            postPaymentResponse(
              context,
              data,
              selectedSubscriptionId,
              "failed",
              "phonepay",
            );
          }
        }
      },
    );
  }

  Future postPaymentResponse(
    BuildContext context,
    dynamic response,
    int selectedSubscriptionId,
    String from,
    String fromGateway,
  ) async {
    var storedModel = await CommonFunctions().getStoredProfileData();
    DateTime now = DateTime.now();
    String passedData;
    var paymentDate = DateFormat('dd-MM-yyyy').format(now);

    if (fromGateway == "phonepay") {
      var encodedData = json.encode(response.toJson());
      passedData = json.encode({
        "user_id": storedModel.id,
        "sub_id": selectedSubscriptionId.toString(),
        "code": response.code,
        "merchantTransactionId": response.data!.merchantTransactionId,
        "transactionId": response.data!.transactionId,
        "amount": response.data!.amount! / 100,
        "state": response.data!.state,
        "responseCode": response.data!.responseCode,
        "responseCodeDescription":
            response.code == "PAYMENT_PENDING" ||
                    response.code == "PAYMENT_SUCCESS"
                ? ""
                : response.data!.state,
        "paymentDate": paymentDate,
        "responseData": encodedData,
      });
    } else {
      var encodedData = json.encode(response.toJson());
      passedData = json.encode({
        "user_id": storedModel.id,
        "sub_id": selectedSubscriptionId.toString(),
        "code": "PAYMENT_SUCCESS",
        "merchantTransactionId": response.orderId,
        "transactionId": response.id,
        "amount": response.amount! / 100,
        "state": "COMPLETED",
        "responseCode": "SUCCESS",
        "responseCodeDescription": response.status,
        "paymentDate": paymentDate,
        "responseData": encodedData,
      });
    }

    var result = await settingsRepository.postPaymentResponse(
      context,
      passedData,
    );

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.homeScreen,
          (route) => false,
        );
      },
      (data) {
        if (from == "success") {
          Navigator.pushNamed(
            context,
            RouteNames.paymentGatwayResponse,
            arguments: {"PaymentResponse": response},
          );
        }
      },
    );
  }

  Future updateSubcription(
    BuildContext context,
    var response,
    int selectedSubscriptionId,
    int tableRecord,
  ) async {
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
      context,
      passedData,
      tableRecord,
    );

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(context, error.message);
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.homeScreen,
          (route) => false,
        );
      },
      (data) {
        CommonFunctions.showSuccessSnackbar(
          "Subscription activated. Use your new features.",
        );
        Navigator.pushNamed(
          context,
          RouteNames.paymentGatwayResponse,
          arguments: {"PaymentResponse": response},
        );
      },
    );
  }
}
