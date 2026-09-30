import 'package:dartz/dartz.dart';
import 'package:fast_quote/Screens/Challan/ChallanList/challan_list_model.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_exceptions.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

import '../../Utils/app_failure.dart';

class ChallanRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, List<ChallanListModel>>> getChallanData(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.challanList, context);

      var result = ChallanResponseModel.fromJson(response);

      return right(result.data!);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> updateChallan(
      BuildContext context, var passedData, String id) async {
    try {
      var response = await apiService.dioApiResponse(
          "${ReomteUrl.challanUpdate}/$id", passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> deleteChallan(
      BuildContext context, String challanId) async {
    try {
      var response = await apiService.getDeleteApiResponse(
          "${ReomteUrl.challanList}/$challanId", context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
