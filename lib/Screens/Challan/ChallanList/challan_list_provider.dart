import 'package:fast_quote/Screens/Challan/challan_repository.dart';
import 'package:flutter/cupertino.dart';

import 'challan_list_model.dart';

class ChallanListProvider with ChangeNotifier {
  ChallanRepository challanRepository = ChallanRepository();
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _noDataFound = false;
  bool get noDataFound => _noDataFound;

  bool _errorEnable = false;
  bool get errorEnable => _errorEnable;

  String _errorText = "";
  String get errorText => _errorText;

  void isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void initData() {
    _noDataFound = false;
    _errorText = "";
    _errorEnable = false;
    _isLoading = true;
    _challanList.clear();
    _searchResultList.clear();
    _searchController.clear();
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  List<ChallanListModel> _challanList = [];
  List<ChallanListModel> get challanList => _challanList;

  List<ChallanListModel> _searchResultList = [];
  List<ChallanListModel> get searchResultList => _searchResultList;

  getChallanData(BuildContext context) async {
    isLoadingFun(true);
    _searchController.addListener(onSearchChanged);

    initData();
    var result = await challanRepository.getChallanData(context);

    result.fold((error) {
      _errorText = error.message;
      _errorEnable = true;
      isLoadingFun(false);
    }, (data) {
      _errorText = "";
      _errorEnable = false;
      _challanList = data;
      searchResulList();
    });
  }

  searchResulList() {
    List<ChallanListModel> showResult = [];
    if (_searchController.text != '') {
      showResult = _challanList.where((prod) {
        var company = prod.customerName!.toLowerCase();
        var customer = prod.customerName!.toLowerCase();

        return company.contains(_searchController.text.toLowerCase()) ||
            customer.contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      showResult = List.from(_challanList);
    }
    if (showResult.isEmpty) {
      _noDataFound = true;
    } else {
      _noDataFound = false;
    }

    _searchResultList = showResult;
    isLoadingFun(false);
  }

  onSearchChanged() {
    searchResulList();
  }
}
