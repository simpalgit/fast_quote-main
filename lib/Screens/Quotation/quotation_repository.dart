import 'package:dartz/dartz.dart';
import 'package:fast_quote/Screens/Quotation/QuotationList/quotation_list_model.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_exceptions.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

class QuotationRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, dynamic>> getQuotationData(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.quotationList, context);

      var result = QuotationResponseModel.fromJson(response);

      return right(result.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addQuotation(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.dioApiResponse(
          ReomteUrl.quotationList, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> updateQuotation(
      BuildContext context, var passedData, String id) async {
    try {
      var response = await apiService.dioApiResponse(
          "${ReomteUrl.quotationList}/$id", passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> deleteQuotation(
      BuildContext context, String quotationId) async {
    try {
      var response = await apiService.getDeleteApiResponse(
          "${ReomteUrl.quotationList}/$quotationId", context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
