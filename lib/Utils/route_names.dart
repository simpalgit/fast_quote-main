import 'dart:io';

import 'package:fast_quote/Screens/Auth/ForgotPassword/forgot_password.dart';
import 'package:fast_quote/Screens/Auth/Login/login_screen.dart';
import 'package:fast_quote/Screens/Auth/Registration/registration_screen.dart';
import 'package:fast_quote/Screens/Challan/ChallanList/challan_list.dart';
import 'package:fast_quote/Screens/Challan/ChallanList/challan_list_model.dart';
import 'package:fast_quote/Screens/Challan/ChallanList/challan_view.dart';
import 'package:fast_quote/Screens/Challan/EditChallan/update_challan.dart';
import 'package:fast_quote/Screens/Settings/Components/CorporatePlanSetting/corporate_plan.dart';
import 'package:fast_quote/Screens/Customer/AddCustomer/add_customer.dart';
import 'package:fast_quote/Screens/Customer/EditCustomer/edit_customer.dart';
import 'package:fast_quote/Screens/Customer/customer.dart';
import 'package:fast_quote/Screens/Customer/customer_model.dart';
import 'package:fast_quote/Screens/Enquiry/CreateEnquiry/create_enquiry.dart';
import 'package:fast_quote/Screens/Enquiry/CreateEnquiry/enquiry_pdf_viewer.dart';
import 'package:fast_quote/Screens/Enquiry/EditEnquiry/update_enquiry.dart';
import 'package:fast_quote/Screens/Enquiry/EnquiryList/enquiry_list.dart';
import 'package:fast_quote/Screens/Enquiry/EnquiryList/enquiry_list_model.dart';
import 'package:fast_quote/Screens/Enquiry/EnquiryList/enquiry_view.dart';
import 'package:fast_quote/Screens/Invoice/CreateInvoice/create_invoice.dart';
import 'package:fast_quote/Screens/Invoice/CreateInvoice/invoice_pdf_viewer.dart';
import 'package:fast_quote/Screens/Invoice/EditInvoice/update_invoice.dart';
import 'package:fast_quote/Screens/Invoice/InvoiceList/invoice_list.dart';
import 'package:fast_quote/Screens/Invoice/InvoiceList/invoice_list_model.dart';
import 'package:fast_quote/Screens/Invoice/InvoiceList/invoice_view.dart';
import 'package:fast_quote/Screens/Invoice/PaidInfoList/paid_info.dart';
import 'package:fast_quote/Screens/Leads/lead_list_screen.dart';
import 'package:fast_quote/Screens/PaymentGateway/payment_gateway_response.dart';
import 'package:fast_quote/Screens/Product/AddEnquiryProduct/add_enquiry_product.dart';
import 'package:fast_quote/Screens/Product/AddInvoiceProduct/add_invoice_product.dart';
import 'package:fast_quote/Screens/Product/AddProduct/add_product.dart';
import 'package:fast_quote/Screens/Product/AddQuotationProduct/add_quotation_product.dart';
import 'package:fast_quote/Screens/Product/EditProduct/edit_product.dart';
import 'package:fast_quote/Screens/Product/product.dart';
import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Quotation/CreateQuotation/create_quotation.dart';
import 'package:fast_quote/Screens/Quotation/CreateQuotation/quotation_pdf_viewer.dart';
import 'package:fast_quote/Screens/Quotation/EditQuotation/update_quotation.dart';
import 'package:fast_quote/Screens/Quotation/QuotationList/quotation_list.dart';
import 'package:fast_quote/Screens/Quotation/QuotationList/quotation_list_model.dart';
import 'package:fast_quote/Screens/Quotation/QuotationList/quotation_view.dart';
import 'package:fast_quote/Screens/Settings/Components/ChangePassword/change_password.dart';
import 'package:fast_quote/Screens/Settings/Components/ColumnHeading/column_heading.dart';
import 'package:fast_quote/Screens/Settings/Components/InvoiceSetting/invoice_setting.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/manage_business.dart';
import 'package:fast_quote/Screens/Settings/Components/PaymentHistory/payment_history.dart';
import 'package:fast_quote/Screens/Settings/Components/Profile/profile.dart';
import 'package:fast_quote/Screens/Settings/Components/QuotationSetting/quotation_setting.dart';
import 'package:fast_quote/Screens/Settings/Components/SubscriptionScreen/plan_model.dart';
import 'package:fast_quote/Screens/Settings/Components/SubscriptionScreen/subscription_screen.dart';
import 'package:fast_quote/Screens/Settings/settings_screen.dart';
import 'package:fast_quote/Screens/Template/Components/EnquiryTemplate/enquiry_template_view.dart';
import 'package:fast_quote/Screens/Template/Components/InvoiceTemplate/invoice_template_view.dart';
import 'package:fast_quote/Screens/Template/Components/QuotationTemplate/quotation_template_view.dart';
import 'package:fast_quote/Screens/Template/template.dart';
import 'package:fast_quote/Screens/Terms/TermsSection/EnquiryTerms/enquiry_terms.dart';
import 'package:fast_quote/Screens/Terms/TermsSection/InvoiceTerms/invoice_terms.dart';
import 'package:fast_quote/Screens/Terms/TermsSection/QuotationTerms/quotation_terms.dart';
import 'package:fast_quote/Screens/Terms/terms.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Screens/home_screen.dart';
import 'package:fast_quote/Screens/instruction_screen.dart';
import 'package:fast_quote/Screens/splash_screen.dart';
import 'package:fast_quote/Screens/support.dart';
import 'package:fast_quote/Screens/webview_screen.dart';
import 'package:fast_quote/Screens/youtube_player.dart';
import 'package:fast_quote/Widgets/amimated_route.dart';
import 'package:fast_quote/Widgets/custom_page_route.dart';
import 'package:flutter/material.dart';

class RouteNames {
  static const String splashScreen = '/splashScreen';
  static const String homeScreen = '/homeScreen';
  static const String leadListScreen = '/leadListScreen';
  static const String loginScreen = '/loginScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String registrationScreen = '/registrationScreen';
  static const String settingsScreen = '/settingScreen';
  static const String customerScreen = '/customerScreen';
  static const String addCustomerScreen = '/addCustomerScreen';
  static const String editCustomerScreen = '/editCustomerScreen';
  static const String productScreen = '/productScreen';
  static const String addProductScreen = '/addProductScreen';
  static const String editProductScreen = '/editProductScreen';
  static const String addProductEnquiry = '/addProductEnquiry';
  static const String addProductQuotation = '/addProductQuotation';
  static const String addProductInvoice = '/addProductInvoice';
  static const String termsScreen = '/termsScreen';
  static const String enquiryTermsScreen = '/enquiryTermsScreen';
  static const String invoiceTermsScreen = '/invoiceTermsScreen';
  static const String quotationTermsScreen = '/quotationTermsScreen';
  static const String employeeTermsScreen = '/quotationSetting';
  static const String supportScreen = '/supportScreen';
  static const String profileScreen = '/profileScreen';
  static const String changePassword = '/changePassword';
  static const String manageBusiness = '/manageBusiness';
  static const String columnHeading = '/columnHeading';
  static const String invoiceSetting = '/invoiceSetting';
  static const String quotationSetting = '/quotationSetting';

  static const String createEnquiry = '/createEnquiry';
  static const String enquiryPFDViewerPage = '/enquiryPFDViewerPage';
  static const String updateEnquiry = '/updateEnquiry';
  static const String enquiryList = '/enquiryList';
  static const String enquiryView = '/enquiryView';

  static const String createQuotation = '/createQuotation';
  static const String quotationPFDViewerPage = '/quotationPFDViewerPage';
  static const String quotationList = '/quotationList';
  static const String quotationViewPage = '/quotationViewPage';
  static const String updateQuotationPdf = '/updateQuotationPdf';

  static const String createInvoice = '/createInvoice';
  static const String invoiceList = '/invoiceList';
  static const String invoiceViewPage = '/invoiceViewPage';
  static const String updateInvoicePdf = '/updateInvoicePdf';
  static const String invoicePFDViewerPage = '/invoicePFDViewerPage';

  static const String paidInfoListScreen = '/paidInfoListScreen';
  static const String subscriptionScreen = '/subscriptionScreen';

  static const String challanList = '/challanList';
  static const String challanViewPage = '/challanViewPage';
  static const String updateChallanScreen = '/updateChallanScreen';

  static const String paymentGatwayResponse = '/paymentGatwayResponse';

  static const String templatesScreen = '/templatesScreen';
  static const String enquiryTemplateViewPage = '/enquiryTemplateViewPage';
  static const String invoiceTemplateViewPage = '/invoiceTemplateViewPage';
  static const String quotationTemplateViewPage = '/quotationTemplateViewPage';

  static const String webviewScreen = '/webviewScreen';
  static const String instructionsScreen = '/instructionsScreen';
  static const String youtubePlayerFlutter = '/youtubePlayerFlutter';
  static const String corporatePlanScreen = '/corporatePlanScreen';
  static const String paymentGatewayScreen = '/paymentGatewayScreen';
  static const String paymmentHistory = '/paymmentHistory';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return createRoute(const SplashScreen(), 0.0, 0.0);
      // return MaterialPageRoute(
      //     settings: settings, builder: (_) => const SplashScreen());

      case RouteNames.homeScreen:
        return createRoute(const HomeScreen(), 0.0, 1.0);

      case RouteNames.leadListScreen:
        return createRoute(const LeadsScreen(), 0.0, 1.0);

      case RouteNames.loginScreen:
        return createRoute(const LoginScreen(), 0.0, 1.0);

      case RouteNames.forgotPasswordScreen:
        return createRoute(const ForgotPasswordScreen(), 0.0, 1.0);

      case RouteNames.registrationScreen:
        return createRoute(const RegistrationScreen(), 0.0, 1.0);

      case RouteNames.settingsScreen:
        return createRoute(const SettingsScreen(), 0.0, 0.0);

      case RouteNames.customerScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final data = args['from'] as String;
        return createRoute(CustomerScreen(onClicked: data), 0.0, 0.0);

      case RouteNames.addCustomerScreen:
        return CustomPageRoute(
          child: const AddCustomerScreen(),
          direction: AxisDirection.up,
        );

      case RouteNames.editCustomerScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final data = args['model'] as CustomerModel;
        return createRoute(EditCustomerScreen(customerModel: data), 0.0, 0.0);

      case RouteNames.productScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final data = args['from'] as String;
        final fromPage = args['fromPage'] as String;
        final action = args['action'] as String;
        return createRoute(
          ProductScreen(onClicked: data, fromPage: fromPage, action: action),
          0.0,
          0.0,
        );

      case RouteNames.addProductScreen:
        return CustomPageRoute(
          child: const AddProductScreen(),
          direction: AxisDirection.up,
        );

      case RouteNames.editProductScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final data = args['model'] as ProductModel;
        return createRoute(EditProductScreen(productModel: data), 0.0, 0.0);

      case RouteNames.addProductEnquiry:
        final args = settings.arguments as Map<String, dynamic>;
        final data = args['model'] as ProductModel;
        return createRoute(AddEnquiryProduct(productModel: data), 0.0, 0.0);

      case RouteNames.addProductQuotation:
        final args = settings.arguments as Map<String, dynamic>;
        final data = args['model'] as ProductModel;
        final action = args['action'] as String;
        return createRoute(
          AddQuotationProduct(productModel: data, action: action),
          0.0,
          0.0,
        );

      case RouteNames.addProductInvoice:
        final args = settings.arguments as Map<String, dynamic>;
        final data = args['model'] as ProductModel;
        final action = args['action'] as String;
        return createRoute(
          AddInvoiceProduct(productModel: data, action: action),
          0.0,
          0.0,
        );

      case RouteNames.termsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final initPage = args['initPage'] as int;
        return createRoute(TermsScreen(initNumber: initPage), 0.0, 0.0);

      case RouteNames.supportScreen:
        return CustomPageRoute(
          child: const SupportScreen(),
          direction: AxisDirection.left,
        );

      case RouteNames.profileScreen:
        return createRoute(const ProfileScreen(), 0.0, 0.0);

      case RouteNames.changePassword:
        return createRoute(const ChangePasswordScreen(), 0.0, 0.0);

      case RouteNames.manageBusiness:
        return createRoute(const ManageBusinessScreen(), 0.0, 0.0);

      case RouteNames.columnHeading:
        return createRoute(const ColumnHeadingScreen(), 0.0, 0.0);

      case RouteNames.invoiceSetting:
        return createRoute(const InvoiceSettingsScreen(), 0.0, 0.0);

      case RouteNames.quotationSetting:
        return createRoute(const QuotationSettingsScreen(), 0.0, 0.0);

      case RouteNames.enquiryTermsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final fromAddTerm = args['fromAddTerm'] as bool;
        final context = args['context'] as BuildContext;
        final selectedTerms = args['selectedTerms'] as List<TermsModel>;
        return createRoute(
          EnquiryTermsScreen(
            fromAddTerm: fromAddTerm,
            baseContext: context,
            selectedTerms: selectedTerms,
          ),
          0.0,
          0.0,
        );

      case RouteNames.invoiceTermsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final fromAddTerm = args['fromAddTerm'] as bool;
        final context = args['context'] as BuildContext;
        final selectedTerms = args['selectedTerms'] as List<TermsModel>;
        return createRoute(
          InvoiceTermsScreen(
            fromAddTerm: fromAddTerm,
            baseContext: context,
            selectedTerms: selectedTerms,
          ),
          0.0,
          0.0,
        );

      case RouteNames.quotationTermsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final fromAddTerm = args['fromAddTerm'] as bool;
        final context = args['context'] as BuildContext;
        final selectedTerms = args['selectedTerms'] as List<TermsModel>;
        return createRoute(
          QuotationTermsScreen(
            fromAddTerm: fromAddTerm,
            baseContext: context,
            selectedTerms: selectedTerms,
          ),
          0.0,
          0.0,
        );

      case RouteNames.createEnquiry:
        final args = settings.arguments as Map<String, dynamic>;
        final enquiryData = args['enquiryData'] as String;
        final from = args['from'] as String;

        return createRoute(
          CreateEnquiryPdf(enquiryData: enquiryData, from: from),
          0.0,
          0.0,
        );

      case RouteNames.enquiryPFDViewerPage:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final enquiryData = args['enquiryData'] as String;
        final enquiryListModel = args['enquiryListModel'] as EnquiryListModel;
        return createRoute(
          EnquiryPFDViewerPage(
            file: file,
            enquiryData: enquiryData,
            enquiryListModel: enquiryListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.updateEnquiry:
        final args = settings.arguments as Map<String, dynamic>;
        final enquiryData = args['enquiryData'] as String;
        final enqNo = args['enqNo'] as String;
        final enquiryListModel = args['enquiryListModel'] as EnquiryListModel;
        return createRoute(
          UpdateEnquiryPdf(
            enquiryData: enquiryData,
            enqId: enqNo,
            enquiryListModel: enquiryListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.enquiryList:
        return createRoute(const EnquiryList(), 0.0, 0.0);

      case RouteNames.enquiryView:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final enquiryData = args['enquiryData'] as String;
        final enquiryListModel = args['enquiryListModel'] as EnquiryListModel;
        return createRoute(
          EnquiryViewPage(
            file: file,
            enquiryData: enquiryData,
            enquiryListModel: enquiryListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.createQuotation:
        final args = settings.arguments as Map<String, dynamic>;
        final quotationData = args['quotationData'] as String;
        final quotationNo = args['quotationNo'] as String;
        final from = args['from'] as String;
        final enqId = args['enqId'] as String;
        return createRoute(
          CreateQuotationPdf(
            from: from,
            quotationData: quotationData,
            quotationNo: quotationNo,
            enqId: enqId,
          ),
          0.0,
          0.0,
        );

      case RouteNames.quotationPFDViewerPage:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final quotationData = args['quotationData'] as String;
        final isSavedAsTemplate = args['isSavedAsTemplate'] as bool;
        final quotationListModel =
            args['quotationListModel'] as QuotationListModel;
        return createRoute(
          QuotationPFDViewerPage(
            file: file,
            quotationData: quotationData,
            isSavedAsTemplate: isSavedAsTemplate,
            quotationListModel: quotationListModel,
          ),
          0.0,
          0.0,
        );
      case RouteNames.quotationList:
        return createRoute(const QuotationList(), 0.0, 0.0);
      case RouteNames.updateQuotationPdf:
        final args = settings.arguments as Map<String, dynamic>;
        final quotationData = args['quotationData'] as String;
        final quotationNo = args['quotationNo'] as String;
        final quotationListModel =
            args['quotationListModel'] as QuotationListModel;
        return createRoute(
          UpdateQuotationPdf(
            quotationData: quotationData,
            quotationNo: quotationNo,
            quotationListModel: quotationListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.quotationViewPage:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final quotationData = args['quotationData'] as String;
        final isSavedAsTemplate = args['isSavedAsTemplate'] as bool;
        final quotationListModel =
            args['quotationListModel'] as QuotationListModel;
        return createRoute(
          QuotationViewPage(
            file: file,
            quotationData: quotationData,
            isSavedAsTemplate: isSavedAsTemplate,
            quotationListModel: quotationListModel,
          ),
          0.0,
          0.0,
        );

      ///--------------------------------------------------------------------------------------------

      case RouteNames.invoiceList:
        return createRoute(const InvoiceList(), 0.0, 0.0);

      case RouteNames.invoicePFDViewerPage:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final invoiceData = args['invoiceData'] as String;
        final isSavedAsTemplate = args['isSavedAsTemplate'] as bool;
        final invoiceListModel = args['invoiceListModel'] as InvoiceListModel;
        return createRoute(
          InvoicePDFViewerPage(
            file: file,
            invoiceData: invoiceData,
            isSavedAsTemplate: isSavedAsTemplate,
            invoiceListModel: invoiceListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.createInvoice:
        final args = settings.arguments as Map<String, dynamic>;
        final quotationData = args['invoiceData'] as String;
        final quotationNo = args['invoiceNo'] as String;
        final from = args['from'] as String;
        return createRoute(
          CreateInvoicePdf(
            from: from,
            invoiceData: quotationData,
            invoiceNo: quotationNo,
          ),
          0.0,
          0.0,
        );

      case RouteNames.invoiceViewPage:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final invoiceData = args['invoiceData'] as String;
        final isSavedAsTemplate = args['isSavedAsTemplate'] as bool;
        final invoiceListModel = args['invoiceListModel'] as InvoiceListModel;

        return createRoute(
          InvoiceViewPage(
            file: file,
            invoiceData: invoiceData,
            isSavedAsTemplate: isSavedAsTemplate,
            invoiceListModel: invoiceListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.updateInvoicePdf:
        final args = settings.arguments as Map<String, dynamic>;
        final invoiceData = args['invoiceData'] as String;
        final invoiceNo = args['invoiceNo'] as String;
        final invoiceListModel = args['invoiceListModel'] as InvoiceListModel;
        return createRoute(
          UpdateInvoicePdf(
            invoiceData: invoiceData,
            invoiceNo: invoiceNo,
            invoiceListModel: invoiceListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.paidInfoListScreen:
        return createRoute(const PaidInfoListScreen(), 0.0, 0.0);

      case RouteNames.subscriptionScreen:
        return createRoute(const SubscriptionScreen(), 0.0, 0.0);

      case RouteNames.paymentGatwayResponse:
        final args = settings.arguments as Map<String, dynamic>;
        final paymentResponse = args['PaymentResponse'] as CheckPaymentModel;
        return createRoute(
          PaymentGatwayResponse(paymentResponse: paymentResponse),
          0.0,
          0.0,
        );

      case RouteNames.templatesScreen:
        return createRoute(const TemplatesScreen(), 0.0, 0.0);

      case RouteNames.webviewScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final appBartitle = args['appBartitle'] as String;
        final url = args['url'] as String;

        return createRoute(
          WebviewScreen(appBartitle: appBartitle, url: url),
          0.0,
          0.0,
        );

      case RouteNames.challanList:
        return createRoute(const ChallanList(), 0.0, 0.0);

      case RouteNames.challanViewPage:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final invoiceData = args['invoiceData'] as String;
        final isSavedAsTemplate = args['isSavedAsTemplate'] as bool;
        final challanListModel = args['invoiceListModel'] as ChallanListModel;
        return createRoute(
          ChallanViewPage(
            file: file,
            invoiceData: invoiceData,
            isSavedAsTemplate: isSavedAsTemplate,
            challanListModel: challanListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.updateChallanScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final challanListModel = args['challanListModel'] as ChallanListModel;
        final data = args['data'] as String;
        return createRoute(
          UpdateChallanScreen(challanListModel: challanListModel, data: data),
          0.0,
          0.0,
        );

      case RouteNames.enquiryTemplateViewPage:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final enquiryData = args['enquiryData'] as String;
        final enquiryListModel = args['enquiryListModel'] as EnquiryListModel;
        return createRoute(
          EnquiryTemplateViewPage(
            file: file,
            enquiryData: enquiryData,
            enquiryListModel: enquiryListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.invoiceTemplateViewPage:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final invoiceData = args['invoiceData'] as String;
        final isSavedAsTemplate = args['isSavedAsTemplate'] as bool;
        final invoiceListModel = args['invoiceListModel'] as InvoiceListModel;

        return createRoute(
          InvoiceTemplateViewPage(
            file: file,
            invoiceData: invoiceData,
            isSavedAsTemplate: isSavedAsTemplate,
            invoiceListModel: invoiceListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.quotationTemplateViewPage:
        final args = settings.arguments as Map<String, dynamic>;
        final file = args['file'] as File;
        final quotationData = args['quotationData'] as String;
        final isSavedAsTemplate = args['isSavedAsTemplate'] as bool;
        final quotationListModel =
            args['quotationListModel'] as QuotationListModel;
        return createRoute(
          QuotationTemplateViewPage(
            file: file,
            quotationData: quotationData,
            isSavedAsTemplate: isSavedAsTemplate,
            quotationListModel: quotationListModel,
          ),
          0.0,
          0.0,
        );

      case RouteNames.instructionsScreen:
        return createRoute(const InstructionsScreen(), 0.0, 0.0);

      case RouteNames.youtubePlayerFlutter:
        final args = settings.arguments as Map<String, dynamic>;
        final videoLink = args['videoLink'] as String;
        return createRoute(
          YoutubePlayerWeb(videoLink: videoLink),
          0.0,
          0.0,
        );

      case RouteNames.corporatePlanScreen:
        return createRoute(const CorporatePlanScreen(), 0.0, 0.0);

      case RouteNames.paymentGatewayScreen:
        final args = settings.arguments as Map<String, dynamic>;

        final url = args['url'] as String;

        return createRoute(PaymentGatewayScreen(url: url), 0.0, 0.0);

      case RouteNames.paymmentHistory:
        return createRoute(const PaymmentHistory(), 0.0, 0.0);

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
