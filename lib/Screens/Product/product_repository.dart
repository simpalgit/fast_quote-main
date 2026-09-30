import 'package:dartz/dartz.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_exceptions.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

import 'product_model.dart';

class ProductRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, List<ProductModel>>> getProductData(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.product, context);

      List<ProductModel> customerList = [];
      for (var e in response['data']) {
        customerList.add(ProductModel.fromJson(e));
      }

      return right(customerList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addProduct(
    BuildContext context,
    dynamic passedData,
  ) async {
    try {
      var response = await apiService.getPostApiResponse(
          ReomteUrl.product, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> editProduct(
      BuildContext context, dynamic passedData, String productId) async {
    try {
      var response = await apiService.getPutApiResponse(
          "${ReomteUrl.product}/$productId", passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> deleteCustomer(
      BuildContext context, String productId) async {
    try {
      var response = await apiService.getDeleteApiResponse(
          "${ReomteUrl.product}/$productId", context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
