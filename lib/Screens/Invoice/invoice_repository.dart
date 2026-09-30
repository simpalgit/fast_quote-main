import 'package:dartz/dartz.dart';
import 'package:fast_quote/Screens/Invoice/InvoiceList/invoice_list_model.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_exceptions.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

import '../../Utils/app_failure.dart';

class InvoiceRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, dynamic>> getInvoiceData(BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.invoiceList, context);

      var result = InvoiceResponseModel.fromJson(response);

      return right(result.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addInvoice(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.dioApiResponse(
          ReomteUrl.invoiceList, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> updateInvoice(
      BuildContext context, var passedData, String id) async {
    try {
      var response = await apiService.dioApiResponse(
          "${ReomteUrl.invoiceList}/$id", passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> deleteInvoice(
      BuildContext context, String invoiceId) async {
    try {
      var response = await apiService.getDeleteApiResponse(
          "${ReomteUrl.invoiceList}/$invoiceId", context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addChallan(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.dioApiResponse(
          ReomteUrl.challanList, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
