// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

AddPartModel addPartModelFromJson(String str) =>
    AddPartModel.fromJson(json.decode(str));

String welcomeToJson(AddPartModel data) => json.encode(data.toJson());

class AddPartModel {
  AddPartModel(
      {this.id,
      this.pname,
      this.price,
      this.quantity,
      this.quantityHelper,
      this.total,
      this.hsnCode,
      this.gstTotal,
      this.gstRate,
      this.isInclusive,
      this.finalTotal});

  String? id;
  String? pname;
  String? price;
  String? quantity;
  String? hsnCode;
  int? quantityHelper;
  String? gstTotal;
  String? total;
  String? gstRate;
  bool? isInclusive;
  String? finalTotal;

  set setproductName(String val) {
    pname = val;
  }

  set setproductQuantity(String val) {
    quantity = val;
  }

  set setproductPrice(String val) {
    price = val;
  }

  set setFinalTotal(String val) {
    finalTotal = val;
  }

  set setGSTTotal(String val) {
    gstTotal = val;
  }

  set setGst(String val) {
    gstRate = val;
  }

  set setInclusive(bool val) {
    isInclusive = val;
  }

  factory AddPartModel.fromJson(Map<String, dynamic> json) => AddPartModel(
      id: json["id"],
      pname: json["pname"],
      price: json["price"],
      quantity: json["quantity"],
      total: json["total"],
      gstTotal: json["gsttotal"],
      gstRate: json["gstRate"],
      finalTotal: json["finalTotal"],
      isInclusive: json["isInclusive"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "pname": pname,
        "price": price,
        "quantity": quantity,
        "total": total,
        "gsttotal": gstTotal,
        "gstRate": gstRate,
        "isInclusive": isInclusive,
        "finalTotal": finalTotal,
      };
}
