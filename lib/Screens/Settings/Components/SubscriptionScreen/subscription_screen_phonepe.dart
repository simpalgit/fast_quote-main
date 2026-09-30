import 'dart:io';

import 'package:flutter/services.dart';

class PhonePePaymentSdk {
  static const MethodChannel _channel = MethodChannel('phonepe_payment_sdk');

  /*
   * This method is used to initiate PhonePe Payment sdk.
   * Provide all the information as requested by the method signature.
   * Params:
   *    - environment: This signified the environment required for the payment sdk
   *      possible values: SANDBOX, PRODUCTION
   *      if any unknown value is provided, PRODUCTION will be considered as default.
   *    - appId: The appId provided by PhonePe at the time of onboarding. send null if not provided.
   *    - merchantId: The merchant id provided by PhonePe  at the time of onboarding.
   *    - enableLogging: If you to enabled / visualize sdk log @IOS
   *        - enabled = YES
   *        - disable = NO
   */
  static Future<bool> init(
    String environment,
    String? appId,
    String merchantId,
    bool enableLogging,
  ) async {
    bool result = await _channel.invokeMethod('init', {
      'environment': environment,
      'appId': appId,
      'merchantId': merchantId,
      'enableLogs': enableLogging,
    });
    return result;
  }

  /*
    * This method is used to initiate PhonePe B2B PG Flow.
    * Provide all the information as requested by the method signature.
    * Params:
    *    - body : The request body for the transaction as per the developer docs.
    *    - appSchema: @Optional(for Android) Your custom app URL Schemes, as per the developer docs.
    *    - checkSum: checksum for the particular transaction as per the developer docs.
    *    - packageName: @Optional(for iOS) in case of android if intent url is expected for specific app.
    *
    * Return: Will be returning a dictionary / hashMap
    *  {
    *     status: String, // string value to provide the status of the transaction
    *                     // possible values: SUCCESS, FAILURE, INTERRUPTED
    *     error: String   // if any error occurs
    *  }
    */
  static Future<Map<dynamic, dynamic>?> startTransaction(
    String body,
    String appSchema,
    String checksum,
    String? packageName,
  ) async {
    var dict = <String, dynamic>{
      'body': body,
      'callbackUrl': appSchema,
      'checksum': checksum,
      'packageName': packageName,
    };
    Map<dynamic, dynamic>? result = await _channel.invokeMethod(
      'startTransaction',
      dict,
    );
    return result;
  }

  /*
   * This method is called to verify / check if PhonePe app is installed on the user / target device.
   * Return: Boolean
   *  true -> PhonePe app installed/available
   *  false -> PhonePe app unavailable
   *  NOTE :- In iOS, Add all the request Query URL Schema as per the developer doc.
   */
  static Future<bool> isPhonePeInstalled() async {
    return await _channel.invokeMethod('isPhonePeInstalled');
  }

  /*
   * This method is called to verify / check if Paytm app is installed on the user / target device.
   * Return: Boolean
   *  true -> Paytm app installed/available
   *  false -> Paytm app unavailable
   *  NOTE :- In iOS, Add all the request Query URL Schema as per the developer doc.
   */
  static Future<bool> isPaytmAppInstalled() async {
    return await _channel.invokeMethod('isPaytmAppInstalled');
  }

  /*
   * This method is called to verify / check if GPay app is installed on the user / target device.
   * Return: Boolean
   *  true -> GPay app installed/available
   *  false -> GPay app unavailable
   *  NOTE :- In iOS, Add all the request Query URL Schema as per the developer doc.
   */
  static Future<bool> isGPayAppInstalled() async {
    return await _channel.invokeMethod('isGPayAppInstalled');
  }

  /*
   * This method is called to get list of upi apps in @Android only.
   * Return: String
   *  JSON String -> List of UPI App with packageName, applicationName & versionCode
   *  NOTE :- In iOS, it will throw os error at runtime.
   */
  static Future<String?> getInstalledUpiAppsForAndroid() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('getInstalledUpiAppsForAndroid');
    }
    return null;
  }

  /*
   * This method is called to get list of upi apps in @iOS only.
   * Return: String
   *  Array -> List of UPI Apps name
   *  NOTE :- In Android, it will throw os error at runtime.
   */
  static Future<List<Object?>?> getInstalledUpiAppsForiOS() async {
    if (Platform.isIOS) {
      return await _channel.invokeMethod('getUPIAppsInstalled');
    }
    return null;
  }

  /*
   * This method is called to get package signature while creation of AppId in @Android only.
   * Return: String
   *  Non empty string -> app package signature
   *  NOTE :- In iOS, it will throw os error at runtime.
   */
  static Future<String?> getPackageSignatureForAndroid() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod('getPackageSignatureForAndroid');
    }
    return null;
  }
}
