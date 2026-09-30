import 'package:dartz/dartz.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

import '../../../Utils/app_base_api_services.dart';
import '../../../Utils/app_exceptions.dart';
import '../../../Utils/app_failure.dart';

class TermsRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, dynamic>> getEnquiryTerms(BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.terms, context);

      // List<TermsModel> customerList = [];

      List<TermsModel> enquiryTerms = [];
      for (var e in response['data']) {
        if (e['type'] == "Enquiry") {
          enquiryTerms.add(TermsModel.fromJson(e));
        }
      }

      return right(enquiryTerms);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> getInvoiceTerms(BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.terms, context);

      List<TermsModel> invoiceTerms = [];
      for (var e in response['data']) {
        if (e['type'] == "Invoice") {
          invoiceTerms.add(TermsModel.fromJson(e));
        }
      }
      return right(invoiceTerms);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> getQuotationTerms(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.terms, context);

      List<TermsModel> quotationTerms = [];
      for (var e in response['data']) {
        if (e['type'] == "Quotation") {
          quotationTerms.add(TermsModel.fromJson(e));
        }
      }
      return right(quotationTerms);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addTerm(
    BuildContext context,
    dynamic passedData,
  ) async {
    try {
      var response = await apiService.getPostApiResponse(
          ReomteUrl.terms, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> editTerm(
      BuildContext context, dynamic passedData, String termId) async {
    try {
      var response = await apiService.getPutApiResponse(
          "${ReomteUrl.terms}/$termId", passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> deleteTerm(
      BuildContext context, String termId) async {
    try {
      var response = await apiService.getDeleteApiResponse(
          "${ReomteUrl.terms}/$termId", context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
