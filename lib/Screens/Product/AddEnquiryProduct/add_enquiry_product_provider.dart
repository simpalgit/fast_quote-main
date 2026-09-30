import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class AddEnquiryProductProvider with ChangeNotifier {
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

  void initData(ProductModel productModel) async {
    _taxHintValue = await LocalPreferences().getTaxLabel() ?? "";
    _ctlProductName.text = productModel.productName!;
    _ctlPrice.text = productModel.productPrice!;
    _ctlQuantity.text = "1";
    _ctlGST.text = productModel.productGST!;
    _ctlDescription.text = productModel.productDescription!;

    notifyListeners();
  }

  addToEnquiryFun(BuildContext context, ProductModel model) async {
    var doubleQuantity = double.parse(_ctlQuantity.text);
    var doublePrice = double.parse(_ctlPrice.text);

    var doubleTotal = doubleQuantity * doublePrice;

    if (_ctlGST.text.isEmpty) {
      _ctlGST.text = "0";
    }

    var taxAmt =
        await CommonFunctions.getAmountForTax(_ctlGST.text, doubleTotal);

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
      isDiscount: false,
      discountType: "Percentage",
      discountPercentage: "0",
      discountAmt: "0",
    );

    if (context.mounted) {
      Navigator.pop(context, productModel);
    }
  }
}
