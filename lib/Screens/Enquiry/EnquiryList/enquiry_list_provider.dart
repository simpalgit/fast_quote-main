import 'package:fast_quote/Screens/Enquiry/EnquiryList/enquiry_list_model.dart';
import 'package:fast_quote/Screens/Enquiry/enquiry_repository.dart';
import 'package:flutter/material.dart';

class EnquiryListProvider with ChangeNotifier {
  EnquiryRepository enquiryRepository = EnquiryRepository();
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
    _enquiryList.clear();
    _searchResultList.clear();
    _searchController.clear();
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  List<EnquiryListModel> _enquiryList = [];
  List<EnquiryListModel> get enquiryList => _enquiryList;

  List<EnquiryListModel> _searchResultList = [];
  List<EnquiryListModel> get searchResultList => _searchResultList;

  getEnquiryData(BuildContext context) async {
    isLoadingFun(true);
    _searchController.addListener(onSearchChanged);

    initData();
    var result = await enquiryRepository.getEnquiryData(context);

    result.fold((error) {
      _errorText = error.message;
      _errorEnable = true;
      isLoadingFun(false);
    }, (data) {
      _errorText = "";
      _errorEnable = false;
      _enquiryList = data;
      searchResulList();
    });
  }

  searchResulList() {
    List<EnquiryListModel> showResult = [];
    if (_searchController.text != '') {
      showResult = _enquiryList.where((prod) {
        var company = prod.customerName!.toLowerCase();
        var customer = prod.customerName!.toLowerCase();

        return company.contains(_searchController.text.toLowerCase()) ||
            customer.contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      showResult = List.from(_enquiryList);
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
