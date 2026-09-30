import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fast_quote/Screens/Settings/Components/CorporatePlanSetting/corporate_model.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/Components/PaymentHistory/history_model.dart';
import 'package:fast_quote/Screens/Settings/Components/Profile/profile_model.dart';
import 'package:fast_quote/Screens/Settings/Components/SubscriptionScreen/plan_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_exceptions.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

class SettingsRepository {
  BaseApiService apiService = NetworkAPIService();

  Future<Either<Failure, ProfileList>> getProfileData(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.profile, context);
      var responseJson = ProfileList.fromJson(response);

      LocalPreferences().setSupportVideoLink(response['support']);
      LocalPreferences().setHasPlan(response['hasPlan']);

      return right(responseJson);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, PDFInitiallizationNumber>> getHomeData(
      BuildContext context) async {
    try {
      var response = await apiService.getGetApiResponse(
          ReomteUrl.getUserPdfLength, context);

      var pdfInitiallizationNumber =
          PDFInitiallizationNumber.fromJson(response);

      return right(pdfInitiallizationNumber);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, BusinessModel>> getBusinessData(
      BuildContext context, String userId) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.business, context);
      List responseList = response['data'];
      BusinessModel extractedData;
      if (responseList.isNotEmpty) {
        var helper = responseList
            .firstWhere((element) => element['user_id'].toString() == userId);

        extractedData = BusinessModel.fromJson(helper);
      } else {
        extractedData = BusinessModel();
      }

      return right(extractedData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> updateProfile(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.dioApiResponse(
          ReomteUrl.updateProfile, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> updateProfileImage(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.dioApiResponse(
          ReomteUrl.updateProfileImage, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> postBusiness(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.dioApiResponse(
          ReomteUrl.business, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> putBusiness(
      BuildContext context, var passedData, String id) async {
    try {
      var response = await apiService.dioApiResponse(
          '${ReomteUrl.business}/$id', passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> getQuoteSettingsData(
      BuildContext context, String userId) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.quotation, context);

      List responseList = response['data'];
      QuoteInvSettingModel extractedData;
      if (responseList.isNotEmpty) {
        var helper = responseList
            .firstWhere((element) => element['user_id'].toString() == userId);

        extractedData = QuoteInvSettingModel.fromJson(helper);
      } else {
        extractedData = QuoteInvSettingModel();
      }

      return right(extractedData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> postQuoteSettingsData(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.getPostApiResponse(
          ReomteUrl.quotation, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> putQuoteSettingsData(
      BuildContext context, var passedData, String id) async {
    try {
      var response = await apiService.getPutApiResponse(
          "${ReomteUrl.quotation}/$id", passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, QuoteInvSettingModel>> getInvoiceSettingsData(
      BuildContext context, String userId) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.invoice, context);

      List responseList = response['data'];
      QuoteInvSettingModel extractedData;
      if (responseList.isNotEmpty) {
        var helper = responseList
            .firstWhere((element) => element['user_id'].toString() == userId);

        extractedData = QuoteInvSettingModel.fromJson(helper);
      } else {
        extractedData = QuoteInvSettingModel();
      }

      return right(extractedData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> postInvoiceSettingsData(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.getPostApiResponse(
          ReomteUrl.invoice, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> putInvoiceSettingsData(
      BuildContext context, var passedData, String id) async {
    try {
      var response = await apiService.getPutApiResponse(
          "${ReomteUrl.invoice}/$id", passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<SubscriptionModel>>> getSubscription(
    BuildContext context,
  ) async {
    ProfileModel profileData = await CommonFunctions().getStoredProfileData();
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.subscription, context);

      List responseList = response['data'];
      List<SubscriptionModel> extractedData = [];

      for (var element in responseList) {
        extractedData.add(SubscriptionModel.fromJson(
          element,
        ));
      }

      return right(extractedData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> deleteAccount(
      BuildContext context, String id) async {
    try {
      var response = await apiService.getDeleteApiResponse(
          ReomteUrl.deleteAccount, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> upgradeSubscription(
      BuildContext context, var passedData, int tableRecord) async {
    try {
      var response = await apiService.getPutApiResponse(
          "${ReomteUrl.userSubscription}/${tableRecord.toString()}",
          passedData,
          context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<CorporateModel>>> getUserSubscription(
    BuildContext context,
  ) async {
    try {
      var response = await apiService.getGetApiResponse(
          "${ReomteUrl.userSubscription}?type=Company", context);

      List<CorporateModel> corporateModelList = [];

      CorporateModelResponse corporateModelResponse =
          CorporateModelResponse.fromJson(response);

      corporateModelList = corporateModelResponse.data!;

      return right(corporateModelList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addUserSubscription(
    BuildContext context,
    var passedData,
  ) async {
    try {
      var response = await apiService.getPostApiResponse(
          ReomteUrl.addUserSubscription, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> startSomthing(
      BuildContext context, var passedData, String sha256) async {
    try {
      var response = await apiService.getPostPaymentGatewayResponse(
          ReomteUrl.startTrasactionLive, passedData, context, sha256);
      dynamic data;
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        data = InitPaymentModel.fromJson(decodeData);
      } else {
        data = "error";
      }

      return right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> getTransactionStatus(
    BuildContext context,
    String sha256,
    String merchantTransactionId,
  ) async {
    try {
      var response = await apiService.getGetPaymentGatewayResponse(
          "${ReomteUrl.checkStatusLive}$merchantTransactionId",
          context,
          sha256,
          ReomteUrl.liveMerchatID);
      dynamic data;

      //print("checkStatus : ${response.body}");
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        data = CheckPaymentModel.fromJson(decodeData);
      } else {
        data = "error";
      }

      return right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> postPaymentResponse(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.getPostApiResponse(
          ReomteUrl.paymentHistoryStore, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> getPaymentHistory(
    BuildContext context,
  ) async {
    var storedModel = await CommonFunctions().getStoredProfileData();
    try {
      var response = await apiService.getGetApiResponse(
        "${ReomteUrl.paymentHistory}${storedModel.id}",
        context,
      );

      List<HistoryModel> historyModelList = [];

      historyModelList = response['data']
          .map<HistoryModel>((e) => HistoryModel.fromJson(e))
          .toList();

      return right(historyModelList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
