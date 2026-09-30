import 'package:fast_quote/Screens/Settings/Components/ManageBusiness/business_model.dart';
import 'package:fast_quote/Screens/Settings/quote_inv_setting_model.dart';
import 'package:fast_quote/Utils/common_functions.dart';
import 'package:fast_quote/Utils/remote_urls.dart';

class ProfileList {
  final ProfileModel? profile;
  final Subscription? subscription;
  final bool? business;
  final bool? invoice;
  final bool? quatation;

  ProfileList(
      {this.profile,
      this.business,
      this.invoice,
      this.quatation,
      this.subscription});

  factory ProfileList.fromJson(Map<String, dynamic> json) => ProfileList(
        profile: json["profile"] == null
            ? null
            : ProfileModel.fromJson(json["profile"],
                json["subscription"] == null ? null : json['subscription']),
        business: json["business"].isEmpty
            ? false
            : checkBusinessData(json["business"]),
        invoice:
            json["invoice"].isEmpty ? false : checkInvoiceData(json["invoice"]),
        quatation: json["quatation"].isEmpty
            ? false
            : checkQuotationData(json["quatation"]),
        subscription: json["subscription"] == null
            ? null
            : Subscription.fromJson(json["subscription"]),
      );
}

bool checkBusinessData(List data) {
  var businessData = BusinessModel.fromJson(data[0]);

  if (businessData.addressOne != null &&
      businessData.addressThree != null &&
      businessData.addressTwo != null &&
      businessData.bankDetails != null &&
      businessData.businessNo != null &&
      businessData.contact != null &&
      businessData.email != null &&
      businessData.label != null &&
      businessData.logo != "" &&
      businessData.name != null &&
      businessData.otherInfo != null &&
      businessData.phone != null &&
      businessData.signature != "" &&
      businessData.stateId != null &&
      businessData.userId != null) {
    return true;
  } else {
    return false;
  }
}

bool checkInvoiceData(List data) {
  var invoiceData = QuoteInvSettingModel.fromJson(data[0]);

  if (invoiceData.id != null &&
      invoiceData.prefix != null &&
      invoiceData.serialNo != null &&
      invoiceData.discount != null &&
      invoiceData.tax != null &&
      invoiceData.product != null &&
      invoiceData.topMessage != null &&
      invoiceData.bottomMsg != null &&
      invoiceData.bankDetails != "" &&
      invoiceData.userId != null &&
      invoiceData.createdAt != null &&
      invoiceData.updatedAt != null) {
    return true;
  } else {
    return false;
  }
}

bool checkQuotationData(List data) {
  var quotationData = QuoteInvSettingModel.fromJson(data[0]);

  if (quotationData.id != null &&
      quotationData.prefix != null &&
      quotationData.serialNo != null &&
      quotationData.discount != null &&
      quotationData.tax != null &&
      quotationData.product != null &&
      quotationData.topMessage != null &&
      quotationData.bottomMsg != null &&
      quotationData.bankDetails != "" &&
      quotationData.userId != null &&
      quotationData.createdAt != null &&
      quotationData.updatedAt != null) {
    return true;
  } else {
    return false;
  }
}

class ProfileModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final DateTime? phoneVerifiedAt;
  final String? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Subscription? subscription;

  ProfileModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.phoneVerifiedAt,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.subscription,
      this.image});

  factory ProfileModel.fromJson(
      Map<String, dynamic> json, dynamic jsonSubscription) {
    String profileImage = "";
    if (json["image"] == "" || json["image"] == null) {
      profileImage = "${ReomteUrl.requiredImagePath}/profile_picture.jpg";
    } else {
      profileImage = "${ReomteUrl.profileImagePath}/${json["image"]}";
    }
    return ProfileModel(
      id: json["id"].toString(),
      name: json["name"].toString(),
      email: json["email"].toString(),
      phone: json["phone"].toString(),
      image: profileImage,
      phoneVerifiedAt: DateTime.parse(json["phone_verified_at"]),
      type: json["type"].toString(),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      subscription: jsonSubscription == null
          ? Subscription()
          : Subscription.fromJson(jsonSubscription),
    );
  }
  factory ProfileModel.fromGetJson(
      Map<String, dynamic> json, Map<String, dynamic>? jsonSubscription) {
    return ProfileModel(
      id: json["id"].toString(),
      name: json["name"].toString(),
      email: json["email"].toString(),
      phone: json["phone"].toString(),
      image: json["image"].toString(),
      phoneVerifiedAt: DateTime.parse(json["phone_verified_at"]),
      type: json["type"].toString(),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      subscription: Subscription.fromJson(json["subscription"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "phone_verified_at": phoneVerifiedAt!.toIso8601String(),
        "type": type,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "subscription": subscription
      };
}

class Subscription {
  final int? id;
  final int? userId;
  final int? subId;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SubscriptionPack? subscriptionPack;
  final bool? status;
  final int? totalDays, remainingDays;

  Subscription(
      {this.id,
      this.userId,
      this.subId,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
      this.subscriptionPack,
      this.status,
      this.totalDays,
      this.remainingDays});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    bool status = false;
    DateTime currentDate = DateTime.now();

    int totalDays = 0, remainingDays = 0;
    if (json["end_date"] != null) {
      var endDate = DateTime.parse(json["end_date"]);
      status = currentDate.isAfter(endDate);
    } else {
      status = true;
    }

    if (json["end_date"] != null && json["start_date"] != null) {
      totalDays = CommonFunctions().calculateRemainingDays(
          DateTime.parse(json["start_date"]), DateTime.parse(json["end_date"]));

      remainingDays = CommonFunctions().calculateRemainingDays(
        currentDate,
        DateTime.parse(json["end_date"]),
      );
    }

    return Subscription(
        id: json["id"],
        userId: json["user_id"],
        subId: json["sub_id"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        subscriptionPack: json["subscription_pack"] == null
            ? null
            : SubscriptionPack.fromJson(json["subscription_pack"]),
        status: status,
        totalDays: totalDays,
        remainingDays: remainingDays);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "sub_id": subId,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "subscription_pack": subscriptionPack?.toJson(),
        "status": status,
        "totalDays": totalDays,
        "remainingDays": remainingDays,
      };
}

class SubscriptionPack {
  final int? id;
  final String? title;
  final String? benefits;
  final int? cost;
  final int? offerCost;
  final DateTime? createdAt;
  final dynamic updatedAt;

  SubscriptionPack({
    this.id,
    this.title,
    this.benefits,
    this.cost,
    this.offerCost,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionPack.fromJson(Map<String, dynamic> json) =>
      SubscriptionPack(
        id: json["id"],
        title: json["title"],
        benefits: json["benefits"],
        cost: json["cost"],
        offerCost: json["offer_cost"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "benefits": benefits,
        "cost": cost,
        "offer_cost": offerCost,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt,
      };
}
