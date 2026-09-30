import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaidInfoModel {
  final String? id;
  final double? amount;
  final String? paidDate;
  final String? note;

  PaidInfoModel({this.amount, this.note, this.paidDate, this.id});

  factory PaidInfoModel.fromJson(Map<String, dynamic> json) => PaidInfoModel(
        id: json["id"],
        amount: json["amount"] ?? 0.0,
        paidDate: json["paidDate"] ?? "",
        note: json["note"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "paidDate": paidDate,
        "note": note,
      };
}

class PaidInfoProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final List<PaidInfoModel> _paidInfoList = [];
  List<PaidInfoModel> get paidInfoList => [..._paidInfoList];

  final TextEditingController _ctlPaidDate = TextEditingController();
  TextEditingController get ctlPaidDate => _ctlPaidDate;
  final TextEditingController _ctlAmount = TextEditingController();
  TextEditingController get ctlAmount => _ctlAmount;
  final TextEditingController _ctlNotes = TextEditingController();
  TextEditingController get ctlNotes => _ctlNotes;

  DateTime selectedDueDate = DateTime.now();

  clearData() {
    _isLoading = true;
    _paidInfoList.clear();
    _ctlPaidDate.clear();
    _ctlAmount.clear();
    ctlNotes.clear();
  }

  addInlist(var paidList) {
    _paidInfoList.clear();
    _paidInfoList.addAll(paidList);
  }

  initData() {
    _isLoading = true;
    // _paidInfoList.clear();
    _ctlPaidDate.clear();
    _ctlAmount.clear();
    ctlNotes.clear();
  }

  clearDialogueFields() {
    _ctlPaidDate.clear();
    _ctlAmount.clear();
    ctlNotes.clear();
    notifyListeners();
  }

  addData(PaidInfoModel paidInfoModel, BuildContext context) {
    _paidInfoList.add(paidInfoModel);
    clearDialogueFields();
    notifyListeners();
    Navigator.pop(context);
  }

  setValues(PaidInfoModel paidInfoModel) {
    _ctlPaidDate.text = paidInfoModel.paidDate!;
    _ctlAmount.text = paidInfoModel.amount!.toStringAsFixed(2);
    _ctlNotes.text = paidInfoModel.note!;
  }

  bool findInList(String id) {
    for (var i in _paidInfoList) {
      if (id == i.id) {
        return true;
      }
    }
    return false;
  }

  updateData(PaidInfoModel paidInfoModel, BuildContext context) {
    if (findInList(paidInfoModel.id!)) {
      int indexOfBob =
          _paidInfoList.indexWhere((person) => person.id == paidInfoModel.id);

      _paidInfoList[indexOfBob] = paidInfoModel;
    }
    notifyListeners();
    Navigator.pop(context);
  }

  deleteData(String id) {
    if (findInList(id)) {
      _paidInfoList.removeWhere((element) {
        return element.id == id;
      });
    }
    clearDialogueFields();
    notifyListeners();
  }

  Future<void> selectPaidDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (picked == null) {
      return;
    }
    if (picked != selectedDueDate) {
      selectedDueDate = picked;
      _ctlPaidDate.text = DateFormat('yyyy-MM-dd').format(selectedDueDate);
    }
    notifyListeners();
  }
}
