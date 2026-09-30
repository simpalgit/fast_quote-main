import 'package:dartz/dartz.dart';
import 'package:fast_quote/Screens/Enquiry/EnquiryList/enquiry_list_model.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_exceptions.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

class EnquiryRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, dynamic>> getEnquiryData(BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.enquiry, context);

      var result = EnquiryResponseModel.fromJson(response);

      return right(result.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addEnquiry(
      BuildContext context, var passedData) async {
    try {
      var response = await apiService.dioApiResponse(
          ReomteUrl.enquiry, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> updateEnquiry(
      BuildContext context, var passedData, String id) async {
    try {
      var response = await apiService.dioApiResponse(
          "${ReomteUrl.enquiry}/$id", passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> deleteEnquiry(
      BuildContext context, String enquiryId) async {
    try {
      var response = await apiService.getDeleteApiResponse(
          "${ReomteUrl.enquiry}/$enquiryId", context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
