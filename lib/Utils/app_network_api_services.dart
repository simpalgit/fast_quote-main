import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'app_base_api_services.dart';
import 'app_exceptions.dart';
import 'common_functions.dart';
import 'local_shared_preferences.dart';

class NetworkAPIService extends BaseApiService {
  Dio dio = Dio();
  static const _className = 'RemoteDataSourceImpl';
  @override
  Future getGetApiResponse(String url, BuildContext context) async {
    dynamic responseJson;
    String storedToken = await LocalPreferences().getAuthToken() ?? "";
    log("Token : $storedToken");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      ).timeout(const Duration(seconds: 30));

      print(response.toString());

      responseJson = _responseParser(response, context);
    } on SocketException {
      log('SocketException', name: _className);
      throw const NetworkException('No internet connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormateException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable 503', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
    return responseJson;
  }

  @override
  Future getGetApiResponseWithoutContext(
    String url,
  ) async {
    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));
      print(response.body);
      responseJson = _responseParserWithoutContext(
        response,
      );
    } on SocketException {
      log('SocketException', name: _className);
      throw const NetworkException('No internet connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormateException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable 503', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(
      String url, dynamic data, BuildContext context) async {
    dynamic responseJson;
    String storedToken = await LocalPreferences().getAuthToken() ?? "";

    try {
      http.Response response = await post(
        Uri.parse(url),
        body: data,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      ).timeout(const Duration(seconds: 30));

      print("responseBody : ${response.body}");

      responseJson = _responseParserPost(response, context);
    } on SocketException {
      log('SocketException', name: _className);
      throw const NetworkException('No internet connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormateException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable 503', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
    return responseJson;
  }

  @override
  Future getPostPaymentGatewayResponse(
      String url, dynamic data, BuildContext context, String newSHA256) async {
    dynamic responseJson;

    try {
      http.Response response = await post(
        Uri.parse(url),
        body: data,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-VERIFY': newSHA256,
        },
      ).timeout(const Duration(seconds: 30));

      responseJson = _responseParserPayment(response, context);
    } on SocketException {
      log('SocketException', name: _className);
      throw const NetworkException('No internet connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormateException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable 503', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
    return responseJson;
  }

  @override
  Future getGetPaymentGatewayResponse(String url, BuildContext context,
      String newSHA256, String merchantId) async {
    dynamic responseJson;

    try {
      http.Response response = await get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-VERIFY': newSHA256,
          'X-MERCHANT-ID': merchantId,
        },
      ).timeout(const Duration(seconds: 30));

      responseJson = _responseParserPayment(response, context);
    } on SocketException {
      log('SocketException', name: _className);
      throw const NetworkException('No internet connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormateException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable 503', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
    return responseJson;
  }

  @override
  Future getDeleteApiResponse(String url, BuildContext context) async {
    dynamic responseJson;
    String storedToken = await LocalPreferences().getAuthToken() ?? "";
    try {
      http.Response response = await delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      ).timeout(const Duration(seconds: 30));

      responseJson = _responseParser(response, context);
    } on SocketException {
      log('SocketException', name: _className);
      throw const NetworkException('No internet connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormateException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable 503', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
    return responseJson;
  }

  @override
  Future loginRegisterApiResponse(
      String url, dynamic data, BuildContext context) async {
    dynamic responseJson;

    try {
      http.Response response = await post(
        Uri.parse(url),
        body: data,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (context.mounted) {
        responseJson = _responseParserLoginReg(response, context);
      }
    } on SocketException {
      log('SocketException', name: _className);
      throw const NetworkException('No internet connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormateException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable 503', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
    return responseJson;
  }

  @override
  Future getPutApiResponse(String url, data, BuildContext context) async {
    dynamic responseJson;
    String storedToken = await LocalPreferences().getAuthToken() ?? "";
    try {
      http.Response response = await put(
        Uri.parse(url),
        body: data,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $storedToken',
        },
      ).timeout(const Duration(seconds: 30));

      responseJson = _responseParserPost(response, context);
    } on SocketException {
      log('SocketException', name: _className);
      throw const NetworkException('No internet connection', 10061);
    } on FormatException {
      log('FormatException', name: _className);
      throw const DataFormateException('Data format exception', 422);
    } on http.ClientException {
      ///503 Service Unavailable
      log('http ClientException', name: _className);
      throw const NetworkException('Service unavailable 503', 503);
    } on TimeoutException {
      log('TimeoutException', name: _className);
      throw const NetworkException('Request timeout', 408);
    }
    return responseJson;
  }

  static _responseParser(http.Response response, BuildContext context) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body);

        return responseJson;
      // throw ValidationException(list, 400);
      case 401:
        final errorMsg = parsingDoseNotExist(response.body);
        if (context.mounted) {
          CommonFunctions().sessionTimeOut(context);
        }
        throw UnauthorisedException(errorMsg, 401);

      case 402:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 402);
      case 403:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 403);
      case 404:
        throw const UnauthorisedException('Request not found', 404);
      case 405:
        throw const UnauthorisedException('Method not allowed', 405);
      case 408:

        ///408 Request Timeout
        throw const NetworkException('Request timeout', 408);
      case 415:

        /// 415 Unsupported Media Type
        throw const DataFormateException('Data format exception');

      case 422:

        ///Unprocessable Entity
        final errorMsg = parsingError(response.body);
        throw InvalidInputException(errorMsg, 422);
      case 500:

        ///500 Internal Server Error
        throw const InternalServerException('Internal server error', 500);

      case 429:
        throw const UnknowException('To many Requests', 429);

      default:
        throw FetchDataException(
            'Error occur while communication with Server', response.statusCode);
    }
  }

  static _responseParserWithoutContext(
    http.Response response,
  ) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body);

        return responseJson;
      case 401:
        final errorMsg = parsingDoseNotExist(response.body);

        // CommonFunctions().snackBarMessage(
        //     message: 'Session timeout login again.',
        //     position: NotificationPosition.top,
        //     time: 3);
        throw UnauthorisedException(errorMsg, 401);

      case 402:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 402);
      case 403:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 403);
      case 404:
        throw const UnauthorisedException('Request not found', 404);
      case 405:
        throw const UnauthorisedException('Method not allowed', 405);
      case 408:

        ///408 Request Timeout
        throw const NetworkException('Request timeout', 408);
      case 415:

        /// 415 Unsupported Media Type
        throw const DataFormateException('Data format exception');

      case 422:

        ///Unprocessable Entity
        final errorMsg = parsingError(response.body);
        throw InvalidInputException(errorMsg, 422);
      case 500:

        ///500 Internal Server Error
        throw const InternalServerException('Internal server error', 500);

      case 429:
        throw const UnknowException('To many Requests', 429);

      default:
        throw FetchDataException(
            'Error occur while communication with Server', response.statusCode);
    }
  }

  static String parsingDoseNotExist(String body) {
    final errorsMap = json.decode(body);
    try {
      if (errorsMap['notification'] != null) {
        return errorsMap['notification'];
      }
      if (errorsMap['message'] != null) {
        return errorsMap['message'];
      }
    } catch (e) {
      log(e.toString(), name: _className);
    }
    return 'Credentials does not match';
  }

  static String parsingError(String body) {
    final errorsMap = json.decode(body);
    try {
      if (errorsMap['errors'] != null) {
        final errors = errorsMap['errors'] as Map;
        final firstErrorMsg = errors.values.first;
        if (firstErrorMsg is List) return firstErrorMsg.first;
        return firstErrorMsg.toString();
      }
      if (errorsMap['message'] != null) {
        return errorsMap['message'];
      }
    } catch (e) {
      log(e.toString(), name: _className);
    }

    return 'Unknown error';
  }

  static _responseParserLoginReg(http.Response response, BuildContext context) {
    switch (response.statusCode) {
      case 200:
        return response;

      case 400:
        //  var responseJson = json.decode(response.body);

        return response;

      // throw ValidationException(list, 400);
      case 401:
        final errorMsg = parsingDoseNotExist(response.body);
        // if (context.mounted) {
        //   CommonFunctions().sessionTimeOut(context);
        // }
        throw UnauthorisedException(errorMsg, 401);

      case 402:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 402);
      case 403:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 403);
      case 404:
        throw const UnauthorisedException('Request not found', 404);
      case 405:
        throw const UnauthorisedException('Method not allowed', 405);
      case 408:

        ///408 Request Timeout
        throw const NetworkException('Request timeout', 408);
      case 415:

        /// 415 Unsupported Media Type
        throw const DataFormateException('Data format exception');

      case 422:

        ///Unprocessable Entity
        final errorMsg = parsingError(response.body);
        throw InvalidInputException(errorMsg, 422);
      case 500:

        ///500 Internal Server Error
        throw const InternalServerException('Internal server error', 500);

      case 429:
        throw const UnknowException('To many Requests', 429);

      default:
        throw FetchDataException(
            'Error occur while communication with Server', response.statusCode);
    }
  }

  static _responseParserPost(http.Response response, BuildContext context) {
    switch (response.statusCode) {
      case 200:
        return response;

      case 400:
        //  var responseJson = json.decode(response.body);

        return response;

      // throw ValidationException(list, 400);
      case 401:
        final errorMsg = parsingDoseNotExist(response.body);
        if (context.mounted) {
          CommonFunctions().sessionTimeOut(context);
        }
        throw UnauthorisedException(errorMsg, 401);

      case 402:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 402);
      case 403:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 403);
      case 404:
        throw const UnauthorisedException('Request not found', 404);
      case 405:
        throw const UnauthorisedException('Method not allowed', 405);
      case 408:

        ///408 Request Timeout
        throw const NetworkException('Request timeout', 408);
      case 415:

        /// 415 Unsupported Media Type
        throw const DataFormateException('Data format exception');

      case 422:

        ///Unprocessable Entity
        final errorMsg = parsingError(response.body);
        throw InvalidInputException(errorMsg, 422);
      case 500:

        ///500 Internal Server Error
        throw const InternalServerException('Internal server error', 500);

      case 429:
        throw const UnknowException('To many Requests', 429);

      default:
        throw FetchDataException(
            'Error occur while communication with Server', response.statusCode);
    }
  }

  static _responseParserPayment(http.Response response, BuildContext context) {
    switch (response.statusCode) {
      case 200:
        return response;

      case 400:
        //  var responseJson = json.decode(response.body);

        return response;

      // throw ValidationException(list, 400);
      case 401:
        final errorMsg = parsingDoseNotExist(response.body);

        throw UnauthorisedException(errorMsg, 401);

      case 402:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 402);
      case 403:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 403);
      case 404:
        throw const UnauthorisedException('Request not found', 404);
      case 405:
        throw const UnauthorisedException('Method not allowed', 405);
      case 408:

        ///408 Request Timeout
        throw const NetworkException('Request timeout', 408);
      case 415:

        /// 415 Unsupported Media Type
        throw const DataFormateException('Data format exception');

      case 422:

        ///Unprocessable Entity
        final errorMsg = parsingError(response.body);
        throw InvalidInputException(errorMsg, 422);
      case 500:

        ///500 Internal Server Error
        throw const InternalServerException('Internal server error', 500);

      case 429:
        throw const UnknowException('To many Requests', 429);

      default:
        throw FetchDataException(
            'Error occur while communication with Server', response.statusCode);
    }
  }

  @override
  Future dioApiResponse(
      String url, dynamic formData, BuildContext context) async {
    dynamic responseJson;
    String storedToken = await LocalPreferences().getAuthToken() ?? "";
    log(storedToken);
    try {
      dio.options.connectTimeout = const Duration(seconds: 60);
      dio.options.receiveTimeout = const Duration(seconds: 60);
      dio.options.sendTimeout = const Duration(seconds: 60);
      var responses = await dio.post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $storedToken',
          }),
          data: formData);

      if (context.mounted) {
        responseJson = _responseDioParser(responses, context);
      }
    } on DioException catch (exception) {
      if (exception.type == DioException.connectionError) {
        throw const NetworkException('Request timeout', 408);
      } else if (exception.type == DioException.connectionTimeout) {
        throw const NetworkException('Request timeout', 408);
      } else if (exception.type == DioException.sendTimeout) {
        throw const NetworkException('Request timeout', 408);
      } else if (exception.response == null) {
        throw const NetworkException('Request timeout', 408);
      } else if (exception.response!.statusCode == 400) {
        return exception.response;
      } else if (exception.response!.statusCode == 500) {
        throw const InternalServerException('Internal server error', 500);
      } else {
        return 'Something went wrong.';
      }
    }
    return responseJson;
  }

  @override
  Future dioPutApiResponse(
      String url, dynamic formData, BuildContext context) async {
    dynamic responseJson;
    String storedToken = await LocalPreferences().getAuthToken() ?? "";
    log(storedToken);
    try {
      dio.options.connectTimeout = const Duration(seconds: 60);
      dio.options.receiveTimeout = const Duration(seconds: 60);
      dio.options.sendTimeout = const Duration(seconds: 60);
      var responses = await dio.put(url,
          options: Options(headers: {
            'Authorization': 'Bearer $storedToken',
          }),
          data: formData);

      if (context.mounted) {
        responseJson = _responseDioParser(responses, context);
      }
    } on DioException catch (exception) {
      if (exception.type == DioException.connectionError) {
        throw const NetworkException('Request timeout', 408);
      } else if (exception.type == DioException.connectionTimeout) {
        throw const NetworkException('Request timeout', 408);
      } else if (exception.type == DioException.sendTimeout) {
        throw const NetworkException('Request timeout', 408);
      } else if (exception.response == null) {
        throw const NetworkException('Request timeout', 408);
      } else if (exception.response!.statusCode == 400) {
        return exception.response;
      } else {
        return 'Something went wrong.';
      }
    }
    return responseJson;
  }

  static _responseDioParser(var response, BuildContext context) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        var responseJson = json.decode(response.body);
        // var list = responseJson.values.toList();
        return responseJson;
      // throw ValidationException(list, 400);
      case 401:
        final errorMsg = parsingDoseNotExist(response.body);
        if (context.mounted) {
          // CommonFunctions().sessionTimeOut(context);
        }
        throw UnauthorisedException(errorMsg, 401);

      case 402:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 402);
      case 403:
        final errorMsg = parsingDoseNotExist(response.body);
        throw UnauthorisedException(errorMsg, 403);
      case 404:
        throw const UnauthorisedException('Request not found', 404);
      case 405:
        throw const UnauthorisedException('Method not allowed', 405);
      case 408:

        ///408 Request Timeout
        throw const NetworkException('Request timeout', 408);
      case 415:

        /// 415 Unsupported Media Type
        throw const DataFormateException('Data format exception');

      case 422:

        ///Unprocessable Entity
        final errorMsg = parsingError(response.body);
        throw InvalidInputException(errorMsg, 422);
      case 500:

        ///500 Internal Server Error
        throw const InternalServerException('Internal server error', 500);

      case 429:
        throw const UnknowException('To many Requests', 429);

      default:
        throw FetchDataException(
            'Error occur while communication with Server', response.statusCode);
    }
  }
}
