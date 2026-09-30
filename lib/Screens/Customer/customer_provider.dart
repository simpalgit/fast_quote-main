import 'package:fast_quote/Screens/Customer/customer_repository.dart';
import 'package:flutter/material.dart';

import 'customer_model.dart';

class CustomerProvider with ChangeNotifier {
  CustomerRepository customerRepository = CustomerRepository();
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
    _customerList.clear();
    _searchResultList.clear();
    _searchController.clear();
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  List<CustomerModel> _customerList = [];
  List<CustomerModel> get customerList => _customerList;

  List<CustomerModel> _searchResultList = [];
  List<CustomerModel> get searchResultList => _searchResultList;

  getCustomerData(BuildContext context) async {
    isLoadingFun(true);
    _searchController.addListener(onSearchChanged);

    initData();
    var result = await customerRepository.getCustomerData(context);

    result.fold((error) {
      _errorText = error.message;
      _errorEnable = true;
      isLoadingFun(false);
    }, (data) {
      _errorText = "";
      _errorEnable = false;
      _customerList = data;
      searchResulList();
    });
  }

  searchResulList() {
    List<CustomerModel> showResult = [];
    if (_searchController.text != '') {
      showResult = _customerList.where((prod) {
        var company = prod.companyName!.toLowerCase();
        var customer = prod.customerName!.toLowerCase();
        var mobile = prod.mobile!.toLowerCase();
        return company.contains(_searchController.text.toLowerCase()) ||
            customer.contains(_searchController.text.toLowerCase()) ||
            mobile.contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      showResult = List.from(_customerList);
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
