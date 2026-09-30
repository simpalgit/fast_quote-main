import 'package:dartz/dartz.dart';
import 'package:fast_quote/Screens/Enquiry/EnquiryList/enquiry_list_model.dart';
import 'package:fast_quote/Screens/Invoice/InvoiceList/invoice_list_model.dart';
import 'package:fast_quote/Screens/Quotation/QuotationList/quotation_list_model.dart';
import 'package:fast_quote/Utils/app_base_api_services.dart';
import 'package:fast_quote/Utils/app_exceptions.dart';
import 'package:fast_quote/Utils/app_network_api_services.dart';
import 'package:fast_quote/Utils/remote_urls.dart';
import 'package:flutter/material.dart';

import '../../Utils/app_failure.dart';

class TemplateRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, List<EnquiryListModel>>> getEnquiryTemplates(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.isTemplate, context);

      List<EnquiryListModel> enquiryTemplateList = [];

      enquiryTemplateList = response['enquiries']
          .map<EnquiryListModel>((e) => EnquiryListModel.fromJson(e))
          .toList();

      return right(enquiryTemplateList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<QuotationListModel>>> getQuotationTemplates(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.isTemplate, context);

      List<QuotationListModel> enquiryTemplateList = [];

      enquiryTemplateList = response['quatation_main']
          .map<QuotationListModel>((e) => QuotationListModel.fromJson(e))
          .toList();

      return right(enquiryTemplateList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<InvoiceListModel>>> getInvoiceTemplates(
      BuildContext context) async {
    try {
      var response =
          await apiService.getGetApiResponse(ReomteUrl.isTemplate, context);

      List<InvoiceListModel> enquiryTemplateList = [];

      enquiryTemplateList = response['invoice_main']
          .map<InvoiceListModel>((e) => InvoiceListModel.fromJson(e))
          .toList();

      return right(enquiryTemplateList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
