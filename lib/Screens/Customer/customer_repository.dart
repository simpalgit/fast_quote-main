import 'package:dartz/dartz.dart';
import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_exceptions.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

class CustomerRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, List<CustomerModel>>> getCustomerData(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.customer, context);

      List<CustomerModel> customerList = [];
      for (var e in response['data']) {
        customerList.add(CustomerModel.fromJson(e));
      }

      return right(customerList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<StateModel>>> getStateList(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.states, context);

      List<StateModel> stateList = [];

      for (var i in response['data']) {
        stateList.add(StateModel.fromJson(i));
      }

      return right(stateList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addCustomer(
    BuildContext context,
    dynamic passedData,
  ) async {
    try {
      var response = await apiService.getPostApiResponse(
          ReomteUrl.customer, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> editCustomer(
      BuildContext context, dynamic passedData, String customerId) async {
    try {
      var response = await apiService.getPutApiResponse(
          "${ReomteUrl.customer}/$customerId", passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> deleteCustomer(
      BuildContext context, String customerId) async {
    try {
      var response = await apiService.getDeleteApiResponse(
          "${ReomteUrl.customer}/$customerId", context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
