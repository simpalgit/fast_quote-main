import 'package:fast_quote/Screens/Invoice/InvoiceList/invoice_list_model.dart';
import 'package:fast_quote/Screens/Template/template_repository.dart';
import 'package:flutter/material.dart';

class InvoiceTemplateProvider with ChangeNotifier {
  TemplateRepository templateRepository = TemplateRepository();
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
    _invoiceList.clear();
    _searchResultList.clear();
    _searchController.clear();
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  List<InvoiceListModel> _invoiceList = [];
  List<InvoiceListModel> get invoiceList => _invoiceList;

  List<InvoiceListModel> _searchResultList = [];
  List<InvoiceListModel> get searchResultList => _searchResultList;

  getInvoiceData(BuildContext context) async {
    isLoadingFun(true);
    _searchController.addListener(onSearchChanged);

    initData();
    var result = await templateRepository.getInvoiceTemplates(context);

    result.fold((error) {
      _errorText = error.message;
      _errorEnable = true;
      isLoadingFun(false);
    }, (data) {
      _errorText = "";
      _errorEnable = false;
      _invoiceList = data;
      searchResulList();
    });
  }

  searchResulList() {
    List<InvoiceListModel> showResult = [];
    if (_searchController.text != '') {
      showResult = invoiceList.where((prod) {
        var company = prod.customerName!.toLowerCase();
        var customer = prod.customerName!.toLowerCase();

        return company.contains(_searchController.text.toLowerCase()) ||
            customer.contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      showResult = List.from(_invoiceList);
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
