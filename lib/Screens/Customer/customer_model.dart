// class CustomerModel {
//   final String? customerName;
//   final String? companyName;
//   final String? email;
//   final String? mobile;
//   final String? addressOne;
//   final String? addressTwo;
//   final String? otherInfo;
//   final String? gstInNumber;
//   final String? state;
//   final String? shippingAddress;

//   CustomerModel(
//       {this.customerName,
//       this.companyName,
//       this.email,
//       this.mobile,
//       this.addressOne,
//       this.addressTwo,
//       this.otherInfo,
//       this.gstInNumber,
//       this.state,
//       this.shippingAddress});
// }

// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'dart:convert';

List<CustomerModel> customerModelFromJson(String str) =>
    List<CustomerModel>.from(
        json.decode(str).map((x) => CustomerModel.fromJson(x)));

String customerModelToJson(List<CustomerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerModel {
  final String? id;
  String? customerName;
  final String? companyName;
  final String? email;
  String? mobile;
  String? addressOne;
  final String? addressTwo;
  final String? otherInfo;
  final String? gstin;
  final String? stateId;
  String? shippingAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final StateModel? state;

  CustomerModel({
    this.id,
    this.customerName,
    this.companyName,
    this.email,
    this.mobile,
    this.addressOne,
    this.addressTwo,
    this.otherInfo,
    this.gstin,
    this.stateId,
    this.shippingAddress,
    this.createdAt,
    this.updatedAt,
    this.state,
  });

  set newCustomerMobile(String mobileVal) {
    mobile = mobileVal;
  }

  set newCustomerAddress(String address) {
    addressOne = address;
  }

  set newShippingAddress(String address) {
    shippingAddress = address;
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["id"].toString(),
        customerName: json["name"] ?? "",
        companyName: json["company"] ?? "",
        email: json["email"] ?? "",
        mobile: json["mobile"] ?? "",
        addressOne: json["address_one"] ?? "",
        addressTwo: json["address_two"] ?? "",
        otherInfo: json["other_info"] ?? "",
        gstin: json["gstin"] ?? "",
        stateId: json["state_id"].toString(),
        shippingAddress: json["shipping_address"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        state: StateModel.fromJson(json["state"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": customerName,
        "company": companyName,
        "email": email,
        "mobile": mobile,
        "address_one": addressOne,
        "address_two": addressTwo,
        "other_info": otherInfo,
        "gstin": gstin,
        "state_id": stateId,
        "shipping_address": shippingAddress,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "state": state!.toJson(),
      };
}

class StateModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  StateModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
