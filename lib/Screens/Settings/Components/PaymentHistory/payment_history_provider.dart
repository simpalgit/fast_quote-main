import 'package:fast_quote/Screens/Settings/Components/PaymentHistory/history_model.dart';
import 'package:fast_quote/Screens/Settings/settings_repository.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:flutter/material.dart';

class PaymmentHistoryProvider with ChangeNotifier {
  SettingsRepository settingsRepository = SettingsRepository();
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hasNoData = false;
  bool get noDataFound => _hasNoData;

  bool _errorEnable = false;
  bool get errorEnable => _errorEnable;

  String _errorText = "";
  String get errorText => _errorText;

  iniData() {
    _hasNoData = false;
    _isLoading = true;
    _historyModelList.clear();
    _errorText = "";
    _errorEnable = false;
  }

  isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  List<HistoryModel> _historyModelList = [];
  List<HistoryModel> get historyModelList => _historyModelList;

  Future getPaymentHistory(BuildContext context) async {
    isLoadingFun(true);
    iniData();
    var result = await settingsRepository.getPaymentHistory(context);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
    }, (data) {
      _historyModelList = data;

      if (historyModelList.isEmpty) {
        _hasNoData = true;
      } else {
        _hasNoData = false;
      }
      isLoadingFun(false);
    });
  }
}
