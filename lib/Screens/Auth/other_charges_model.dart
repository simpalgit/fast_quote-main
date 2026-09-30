class OtherchargesModel {
  final int? id;
  final String? title;
  final String? amount;
  String? tax;
  String? taxAmt;
  bool? isTaxable;

  set isCheckedFun(bool val) {
    isTaxable = val;
  }

  set changeTax(String val) {
    tax = "0.0";
    taxAmt = "0.0";
  }

  OtherchargesModel(
      {this.title,
      this.amount,
      this.tax,
      this.taxAmt,
      this.isTaxable,
      this.id});

  factory OtherchargesModel.fromJson(Map<String, dynamic> json) =>
      OtherchargesModel(
        id: json["id"],
        title: json["title"] ?? "",
        amount: json["amount"] ?? "",
        tax: json["tax"] ?? "",
        taxAmt: json["taxAmt"] ?? "",
        isTaxable: json["isTaxable"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "amount": amount,
        "tax": tax,
        "taxAmt": taxAmt,
        "isTaxable": isTaxable,
        "id": id,
      };
}
