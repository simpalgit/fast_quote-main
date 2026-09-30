import 'dart:convert';

import 'package:fast_quote/Screens/Terms/TermsSection/terms_repository.dart';
import 'package:fast_quote/Screens/Terms/terms_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:flutter/material.dart';

class EnquiryTermsProvider with ChangeNotifier {
  TermsRepository termsRepository = TermsRepository();
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _noDataFound = false;
  bool get noDataFound => _noDataFound;

  bool _errorEnable = false;
  bool get errorEnable => _errorEnable;

  String _errorText = "";
  String get errorText => _errorText;

  String _errorTerm = "";
  String get errorTerm => _errorTerm;

  bool _selectAll = false;
  bool get selectAll => _selectAll;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  List<TermsModel> _termsList = [];
  List<TermsModel> get termsList => _termsList;

  List<TermsModel> _searchResultList = [];
  List<TermsModel> get searchResultList => _searchResultList;

  List<TermsModel> _selectedList = [];
  List<TermsModel> get selectedList => _selectedList;

  void isLoadingFun(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void initData() {
    _noDataFound = false;
    _selectAll = false;
    _isLoading = true;
    _errorTerm = "";
    _termsList.clear();
    _errorText = "";
    _errorEnable = false;
    searchController.clear();
    if (_selectedList.isNotEmpty) {
      _selectedList.clear();
    }

    _searchResultList.clear();
  }

  getTermsData(List<TermsModel> helperLiset, BuildContext context) async {
    isLoadingFun(true);
    _searchController.removeListener(onSearchChanged);
    _searchController.addListener(onSearchChanged);

    initData();

    _selectedList = helperLiset;
    var result = await termsRepository.getEnquiryTerms(context);

    result.fold((error) {
      _errorText = error.message;
      _errorEnable = true;
      isLoadingFun(false);
    }, (data) {
      _errorText = "";
      _errorEnable = false;
      _termsList = data;
      searchResulList();
    });
  }

  getLastRecord(BuildContext context) async {
    var result = await termsRepository.getEnquiryTerms(context);

    result.fold((error) {
      _errorText = error.message;
      _errorEnable = true;
      isLoadingFun(false);
    }, (data) {
      adTermList(data.last);
    });
  }

  adTermList(TermsModel termsModel) {
    _searchResultList.add(termsModel);
    notifyListeners();
  }

  List<TermsModel> findCommonElements<T>(
      List<TermsModel> list1, List<TermsModel> list2) {
    return list1.where((element) => list2.contains(element)).toList();
  }

  searchResulList() {
    List<TermsModel> showResult = [];
    if (_searchController.text != '') {
      showResult = _termsList.where((prod) {
        var term = prod.term!.toLowerCase();

        return term.contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      showResult = List.from(_termsList);
    }
    if (showResult.isEmpty) {
      _noDataFound = true;
    } else {
      _noDataFound = false;
    }

    _searchResultList = showResult;

    if (_selectedList.isNotEmpty) {
      List<TermsModel> commonElements = _selectedList
          .where((element1) => _searchResultList
              .any((element2) => element2.termId == element1.termId))
          .toList();

      for (int i = 0; i < _searchResultList.length; i++) {
        for (int j = 0; j < commonElements.length; j++) {
          if (_searchResultList[i].termId == commonElements[j].termId) {
            _searchResultList[i].changeSelection = true;
          }
        }
      }
      bool allSame1 =
          _searchResultList.every((element) => element.isSelected == true);

      if (allSame1) {
        _selectAll = true;
      }
    }

    isLoadingFun(false);
  }

  onSearchChanged() {
    searchResulList();
  }

  void changeSelection(bool val, TermsModel termsModel) {
    termsModel.changeSelection = val;
    bool allSame1 =
        _searchResultList.every((element) => element.isSelected == true);

    if (allSame1) {
      _selectAll = true;
    } else {
      _selectAll = false;
    }
    notifyListeners();
  }

  void selectAllTerms(bool val) {
    _selectAll = val;
    for (var element in _searchResultList) {
      element.changeSelection = val;
    }

    notifyListeners();
  }

  Future<void> editTerm(
      BuildContext context, String type, String termData, String termId) async {
    isLoadingFun(true);
    var passedData = json.encode({"type": type, "description": termData});
    var result = await termsRepository.editTerm(context, passedData, termId);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(context, error.message);
      getTermsData(_selectedList, context);
    }, (data) {
      _errorTerm = "";

      if (data != null) {
        var responseJson = json.decode(data.body);

        if (data.statusCode == 400) {
          responseJson['error'].forEach((k, v) {
            if (k == "description") {
              _errorTerm = v[0];
            }
          });
        } else {
          Navigator.pop(context);
          CommonFunctions.showSuccessSnackbar("Term Updated.");
        }
      }
      getTermsData(_selectedList, context);
    });
  }

  deleteTerm(BuildContext context, String termId) async {
    isLoadingFun(true);

    var result = await termsRepository.deleteTerm(context, termId);

    result.fold((error) {
      Navigator.pop(context);
      CommonFunctions.showErrorSnackbar(context, error.message);
      getTermsData(_selectedList, context);
    }, (data) {
      CommonFunctions.showSuccessSnackbar("Term deleted.");
      Navigator.pop(context);
      getTermsData(_selectedList, context);
    });
  }
}
