import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:flutter/material.dart';

class ColumnHeadingProvider with ChangeNotifier {
  final TextEditingController _ctlTaxLabel = TextEditingController();
  TextEditingController get ctlTaxLabel => _ctlTaxLabel;

  final TextEditingController _ctlProductHSNLabel = TextEditingController();
  TextEditingController get ctlProductHSNLabel => _ctlProductHSNLabel;

  final TextEditingController _ctlOtherChargesLabel = TextEditingController();
  TextEditingController get ctlOtherChargesLabel => _ctlOtherChargesLabel;

  void initData() async {
    _ctlTaxLabel.text = await LocalPreferences().getTaxLabel() ?? "";
    _ctlProductHSNLabel.text =
        await LocalPreferences().getProductHSNLabel() ?? "";
    _ctlOtherChargesLabel.text =
        await LocalPreferences().getOtherChargesLabel() ?? "";
    // _ctlTaxLabel.clear();
    // _ctlProductHSNLabel.clear();
    // _ctlOtherChargesLabel.clear();
    notifyListeners();
  }

  updateColumnHeading(BuildContext context) {
    LocalPreferences().setTaxLabel(_ctlTaxLabel.text);
    LocalPreferences().setProductHSNLabel(_ctlProductHSNLabel.text);
    LocalPreferences().setOtherChargesLabel(_ctlOtherChargesLabel.text);

    CommonFunctions.showSuccessSnackbar("Settings updated successfully..");

    Navigator.pop(context);
  }
}
