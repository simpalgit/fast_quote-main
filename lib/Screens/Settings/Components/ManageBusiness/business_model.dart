import 'package:fast_quote/Utils/remote_urls.dart';

class BusinessModel {
  final String? id;
  final String? logo;
  final dynamic signature;
  final String? name;
  final String? contact;
  final String? email;
  final String? phone;
  final String? addressOne;
  final String? addressTwo;
  final String? addressThree;
  final String? otherInfo;
  final String? label;
  final String? businessNo;
  final String? stateId;
  final String? bankDetails;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BusinessModel({
    this.id,
    this.logo,
    this.signature,
    this.name,
    this.contact,
    this.email,
    this.phone,
    this.addressOne,
    this.addressTwo,
    this.addressThree,
    this.otherInfo,
    this.label,
    this.businessNo,
    this.stateId,
    this.bankDetails,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    String logo = "", signature = "";

    if (json["logo"] == "" || json["logo"] == null) {
      logo = "";
    } else {
      logo = "${ReomteUrl.businessImagePath}/${json["logo"]}";
    }
    if (json["signature"] == "" || json["signature"] == null) {
      signature = "";
    } else {
      signature = "${ReomteUrl.businessImagePath}/${json["signature"]}";
    }
    return BusinessModel(
      id: json["id"].toString(),
      logo: logo,
      signature: signature,
      name: json["name"],
      contact: json["contact"],
      email: json["email"],
      phone: json["phone"],
      addressOne: json["address_one"],
      addressTwo: json["address_two"],
      addressThree: json["address_three"],
      otherInfo: json["other_info"],
      label: json["label"],
      businessNo: json["business_no"],
      stateId: json["state_id"].toString(),
      bankDetails: json["bank_details"],
      userId: json["user_id"].toString(),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }

  factory BusinessModel.fromConverChallanJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json["id"].toString(),
      logo: json["logo"],
      signature: json["signature"],
      name: json["name"],
      contact: json["contact"],
      email: json["email"],
      phone: json["phone"],
      addressOne: json["address_one"],
      addressTwo: json["address_two"],
      addressThree: json["address_three"],
      otherInfo: json["other_info"],
      label: json["label"],
      businessNo: json["business_no"],
      stateId: json["state_id"].toString(),
      bankDetails: json["bank_details"],
      userId: json["user_id"].toString(),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo": logo,
        "signature": signature,
        "name": name,
        "contact": contact,
        "email": email,
        "phone": phone,
        "address_one": addressOne,
        "address_two": addressTwo,
        "address_three": addressThree,
        "other_info": otherInfo,
        "label": label,
        "business_no": businessNo,
        "state_id": stateId,
        "bank_details": bankDetails,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
