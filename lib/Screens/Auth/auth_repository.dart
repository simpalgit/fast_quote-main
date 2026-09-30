import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_exceptions.dart';
import 'package:fast_quote/Utils/app_failure.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, dynamic>> loginUser(data, context) async {
    try {
      var response = await apiService.loginRegisterApiResponse(
          ReomteUrl.login, data, context);
      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> registerUser(
      var data, BuildContext context) async {
    try {
      var extractedData = await apiService.loginRegisterApiResponse(
          ReomteUrl.register, data, context);
      return right(extractedData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> sendOtp(
      {required String mobile, required BuildContext context}) async {
    var passedData = json.encode({
      "phone": mobile,
    });
    try {
      final response = await apiService.loginRegisterApiResponse(
          ReomteUrl.sendOtp, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> sendForgotOtp(
      {required String mobile, required BuildContext context}) async {
    var passedData = json.encode({
      "phone": mobile,
    });
    try {
      final response = await apiService.loginRegisterApiResponse(
          ReomteUrl.sendForgetOtp, passedData, context);

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> forgotPassword(
      var data, BuildContext context) async {
    try {
      var extractedData = await apiService.loginRegisterApiResponse(
          ReomteUrl.changePassword, data, context);
      return right(extractedData);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
