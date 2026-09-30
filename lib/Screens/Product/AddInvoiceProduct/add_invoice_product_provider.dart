import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class AddInvoiceProductProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  QuoteInvSettingModel quoteInvSettingModel = QuoteInvSettingModel();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final bool _isPercentage = true;
  bool get isPercentage => _isPercentage;
  isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  final TextEditingController _ctlProductName = TextEditingController();
  TextEditingController get ctlProductName => _ctlProductName;

  final TextEditingController _ctlPrice = TextEditingController();
  TextEditingController get ctlPrice => _ctlPrice;

  final TextEditingController _ctlQuantity = TextEditingController();
  TextEditingController get ctlQuantity => _ctlQuantity;

  final TextEditingController _ctlGST = TextEditingController();
  TextEditingController get ctlGST => _ctlGST;

  final TextEditingController _ctlDescription = TextEditingController();
  TextEditingController get ctlDescription => _ctlDescription;

  String _taxHintValue = "";
  String get taxHintValue => _taxHintValue;

  void initData(ProductModel productModel, BuildContext context) async {
    CommonFunctions.showProgressBar(context);
    isLoadingFun(true);
    _taxHintValue = await LocalPreferences().getTaxLabel() ?? "";
    _ctlProductName.text = productModel.productName!;
    _ctlPrice.text = productModel.productPrice!;
    _ctlQuantity.text = "1";
    _ctlGST.text = productModel.productGST!;
    _ctlDescription.text = productModel.productDescription!;

    // notifyListeners();
    if (context.mounted) {
      getInvoiceSettingsData(context);
    }
  }

  Future<void> getInvoiceSettingsData(BuildContext context) async {
    var storedModel = await CommonFunctions().getStoredProfileData();

    var result = await settingsRepository.getInvoiceSettingsData(
        context, storedModel.id!);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      isLoadingFun(false);
      Navigator.pop(context);
    }, (data) {
      quoteInvSettingModel = data;
      Navigator.pop(context);
      isLoadingFun(false);
    });
  }

  addToEnquiryFun(BuildContext context, ProductModel model, bool isPercentage,
      String amount, String action) async {
    var doubleQuantity = double.parse(_ctlQuantity.text);
    var doublePrice = double.parse(_ctlPrice.text);
    var doubleTotal = doubleQuantity * doublePrice;
    if (_ctlGST.text.isEmpty) {
      _ctlGST.text = "0";
    }
    List taxAmt = [];
    double discAmt = 0.0;
    if (amount.isEmpty) {
      amount = "0";
    }

    if (quoteInvSettingModel.tax == "Per item" &&
        quoteInvSettingModel.discount == "Per item") {
      if (isPercentage) {
        if (action == "Create") {
          discAmt = CommonFunctions.discountOnPercentage(
              context, amount, doubleTotal);
        } else if (action == "Update") {
          if (amount == "0") {
            amount = "";
          }
          discAmt = CommonFunctions.discountOnPercentageFunction(
              context, amount, doubleTotal);
        } else {
          discAmt = CommonFunctions.discountOnPercentageFunction(
              context, amount, doubleTotal);
        }
        // discAmt =
        //     CommonFunctions.discountOnPercentage(context, amount, doubleTotal);
      } else {
        discAmt = CommonFunctions.discountOnFlatFunction(
            context, amount, doubleTotal);
      }
      var disscountedAmt = doubleTotal - discAmt;
      taxAmt =
          await CommonFunctions.getAmountForTax(_ctlGST.text, disscountedAmt);
    } else {
      if (quoteInvSettingModel.tax == "Per item") {
        taxAmt =
            await CommonFunctions.getAmountForTax(_ctlGST.text, doubleTotal);
      } else {
        taxAmt.insert(0, doubleTotal);
        taxAmt.insert(1, 0);
      }
      if (quoteInvSettingModel.discount == "Per item") {
        if (isPercentage) {
          if (action == "Create") {
            discAmt = CommonFunctions.discountOnPercentage(
                context, amount, doubleTotal);
          } else if (action == "Update") {
            if (amount == "0") {
              amount = "";
            }
            discAmt = CommonFunctions.discountOnPercentageFunction(
                context, amount, doubleTotal);
          } else {
            discAmt = CommonFunctions.discountOnPercentageFunction(
                context, amount, doubleTotal);
          }
        } else {
          discAmt = CommonFunctions.discountOnFlatFunction(
              context, amount, doubleTotal);
        }
        taxAmt[0] = taxAmt[0] - discAmt;
      }
    }

    ProductModel productModel = ProductModel(
        id: model.id,
        productName: _ctlProductName.text,
        productPrice: _ctlPrice.text,
        productQuantity: _ctlQuantity.text,
        productTotal: doubleTotal.toStringAsFixed(2),
        productGST: _ctlGST.text,
        productAppliedGST: taxAmt[1].toStringAsFixed(2),
        productTaxAmount: taxAmt[0].toStringAsFixed(2),
        productDescription: _ctlDescription.text,
        productUnit: model.productUnit,
        productHSNnumber: model.productHSNnumber,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        isDiscount: quoteInvSettingModel.discount == "Per item" ? true : false,
        discountType: isPercentage ? "Percentage" : "Amount",
        discountPercentage: amount == "" ? "0" : amount,
        discountAmt: discAmt.toStringAsFixed(2));

    if (context.mounted) {
      Navigator.pop(context, productModel);
    }
  }
}
