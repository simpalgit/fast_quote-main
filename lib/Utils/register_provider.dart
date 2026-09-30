import 'package:fast_quote/Screens/Auth/ForgotPassword/forgot_password_provider.dart';
import 'package:fast_quote/Screens/Auth/Login/login_provider.dart';
import 'package:fast_quote/Screens/Auth/Registration/registration_provider.dart';
import 'package:fast_quote/Screens/Auth/internet_provider.dart';
import 'package:fast_quote/Screens/Challan/ChallanList/challan_list_provider.dart';
import 'package:fast_quote/Screens/Challan/EditChallan/update_challan_provider.dart';
import 'package:fast_quote/Screens/Settings/Components/CorporatePlanSetting/corporate_plan_provider.dart';
import 'package:fast_quote/Screens/Customer/EditCustomer/edit_customer_provider.dart';
import 'package:fast_quote/Screens/Customer/customer_provider.dart';
import 'package:fast_quote/Screens/Enquiry/CreateEnquiry/create_enquiry_provider.dart';
import 'package:fast_quote/Screens/Enquiry/EditEnquiry/update_enquiry_provider.dart';
import 'package:fast_quote/Screens/Enquiry/EnquiryList/enquiry_list_provider.dart';
import 'package:fast_quote/Screens/Invoice/CreateInvoice/create_invoice_provider.dart';
import 'package:fast_quote/Screens/Invoice/EditInvoice/update_invoice_provider.dart';
import 'package:fast_quote/Screens/Invoice/InvoiceList/invoice_list_provider.dart';
import 'package:fast_quote/Screens/Invoice/PaidInfoList/paid_info_provider.dart';
import 'package:fast_quote/Screens/Product/AddEnquiryProduct/add_enquiry_product_provider.dart';
import 'package:fast_quote/Screens/Product/AddInvoiceProduct/add_invoice_product_provider.dart';
import 'package:fast_quote/Screens/Product/AddProduct/add_product_provider.dart';
import 'package:fast_quote/Screens/Product/AddQuotationProduct/add_quotation_product_provider.dart';
import 'package:fast_quote/Screens/Product/EditProduct/edit_product_provider.dart';
import 'package:fast_quote/Screens/Product/product_provider.dart';
import 'package:fast_quote/Screens/Quotation/CreateQuotation/create_quotation_provider.dart';
import 'package:fast_quote/Screens/Quotation/EditQuotation/update_quotation_provider.dart';
import 'package:fast_quote/Screens/Quotation/QuotationList/quotation_list_provider.dart';
import 'package:fast_quote/Screens/Settings/Components/ColumnHeading/column_heading_provider.dart';
import 'package:fast_quote/Screens/Settings/Components/InvoiceSetting/invoice_setting_provider.dart';
import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/manage_business_provider.dart';
import 'package:fast_quote/Screens/Settings/Components/PaymentHistory/payment_history_provider.dart';
import 'package:fast_quote/Screens/Settings/Components/Profile/profile_provider.dart';
import 'package:fast_quote/Screens/Settings/Components/QuotationSetting/quotation_setting_provider.dart';
import 'package:fast_quote/Screens/Settings/Components/SubscriptionScreen/subscription_provider.dart';
import 'package:fast_quote/Screens/Template/Components/EnquiryTemplate/enquiry_template_provider.dart';
import 'package:fast_quote/Screens/Template/Components/InvoiceTemplate/invoice_template_provider.dart';
import 'package:fast_quote/Screens/Template/Components/QuotationTemplate/quotation_template_provider.dart';
import 'package:fast_quote/Screens/Terms/TermsSection/EnquiryTerms/enquiry_terms_provider.dart';
import 'package:fast_quote/Screens/Terms/TermsSection/InvoiceTerms/invoice_terms_provider.dart';
import 'package:fast_quote/Screens/Terms/TermsSection/QuotationTerms/quotation_terms_provider.dart';
import 'package:fast_quote/Screens/splash_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../Screens/Customer/AddCustomer/add_customer_provider.dart';
import '../Screens/Settings/Components/ChangePassword/change_pass_provider.dart';

List<SingleChildWidget> get registerProviders {
  return [
    //Auth
    ChangeNotifierProvider(create: (context) => SplashScreenProvider()),
    ChangeNotifierProvider(create: (context) => LoginProvider()),
    ChangeNotifierProvider(create: (context) => RegistrationProvider()),
    ChangeNotifierProvider(create: (context) => ForgotPasswordProvider()),

    //Customer
    ChangeNotifierProvider(create: (context) => CustomerProvider()),
    ChangeNotifierProvider(create: (context) => AddCustomerProvider()),
    ChangeNotifierProvider(create: (context) => EditCustomerProvider()),

    //PRODUCT
    ChangeNotifierProvider(create: (context) => ProductProvider()),
    ChangeNotifierProvider(create: (context) => AddProductProvider()),
    ChangeNotifierProvider(create: (context) => EditProductProvider()),
    ChangeNotifierProvider(create: (context) => AddEnquiryProductProvider()),
    ChangeNotifierProvider(create: (context) => AddQuotationProductProvider()),
    ChangeNotifierProvider(create: (context) => AddInvoiceProductProvider()),
    ChangeNotifierProvider(create: (context) => PaidInfoProvider()),

    //Terms
    ChangeNotifierProvider(create: (context) => EnquiryTermsProvider()),
    ChangeNotifierProvider(create: (context) => InvoiceTermsProvider()),
    ChangeNotifierProvider(create: (context) => QuotationTermsProvider()),

    ///Enqquiry
    ChangeNotifierProvider(create: (context) => EnquiryListProvider()),
    ChangeNotifierProvider(create: (context) => CreateEnquiryProvider()),
    ChangeNotifierProvider(create: (context) => UpdateEnquiryProvider()),

    ChangeNotifierProvider(create: (context) => QuotationListProvider()),
    ChangeNotifierProvider(create: (context) => CreateQuotationProvider()),
    ChangeNotifierProvider(create: (context) => UpdateQuotationProvider()),

    ChangeNotifierProvider(create: (context) => CreateInvoiceProvider()),
    ChangeNotifierProvider(create: (context) => InvoiceListProvider()),
    ChangeNotifierProvider(create: (context) => UpdateInvoiceProvider()),

    ChangeNotifierProvider(create: (context) => ChallanListProvider()),

    //Setings Providers
    ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ChangeNotifierProvider(create: (context) => ChangePassProvider()),
    ChangeNotifierProvider(create: (context) => ManageBusinessProvider()),
    ChangeNotifierProvider(create: (context) => ColumnHeadingProvider()),
    ChangeNotifierProvider(create: (context) => InvoiceSettingsProvider()),
    ChangeNotifierProvider(create: (context) => QuotationSettingsProvider()),
    ChangeNotifierProvider(create: (context) => SubscriptionProvider()),

    ///Templates
    ChangeNotifierProvider(create: (context) => EnquiryTemplateProvider()),
    ChangeNotifierProvider(create: (context) => QuotationTemplateProvider()),
    ChangeNotifierProvider(create: (context) => InvoiceTemplateProvider()),

    ChangeNotifierProvider(create: (context) => UpdateChallanProvider()),
    ChangeNotifierProvider(create: (context) => CorporatePlanProvider()),
    ChangeNotifierProvider(create: (context) => PaymmentHistoryProvider()),

    StreamProvider(
      create: (_) => NetworkService().controller.stream,
      initialData: NetworkStatus.online,
    ),
  ];
}
