import 'package:fast_quote/Screens/Product/product_model.dart';
import 'package:fast_quote/Utils/local_shared_preferences.dart';
import 'package:flutter/material.dart';

import 'product_repository.dart';

class ProductProvider with ChangeNotifier {
  ProductRepository customerRepository = ProductRepository();
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

  String _taxHintValue = "";
  String get taxHintValue => _taxHintValue;

  void initData() {
    _noDataFound = false;
    _isLoading = true;
    _errorText = "";
    _errorEnable = false;
    _searchController.clear();
    _searchResultList.clear();
    _productList.clear();
  }

  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  List<ProductModel> _searchResultList = [];
  List<ProductModel> get searchResultList => _searchResultList;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  getProductData(BuildContext context) async {
    isLoadingFun(true);

    _searchController.addListener(onSearchChanged);

    initData();
    _taxHintValue = await LocalPreferences().getTaxLabel() ?? "";
    var result = await customerRepository.getProductData(context);

    result.fold((error) {
      _errorText = error.message;
      _errorEnable = true;
      isLoadingFun(false);
    }, (data) {
      _errorText = "";
      _errorEnable = false;
      _productList = data;
      searchResulList();
    });
  }

  searchResulList() {
    List<ProductModel> showResult = [];
    if (_searchController.text != '') {
      showResult = _productList.where((prod) {
        var name = prod.productName!.toLowerCase();
        return name.contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      showResult = List.from(_productList);
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
