import 'package:fast_quote/Screens/Settings/Components/Profile/profile_model.dart';
import 'package:fast_quote/Screens/Settings/Components/SubscriptionScreen/plan_model.dart';

class CorporateModelResponse {
  final bool? response;
  final List<CorporateModel>? data;

  CorporateModelResponse({
    this.response,
    this.data,
  });

  factory CorporateModelResponse.fromJson(Map<String, dynamic> json) =>
      CorporateModelResponse(
        response: json["response"],
        data: json["data"] == null
            ? []
            : List<CorporateModel>.from(
                json["data"]!.map((x) => CorporateModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CorporateModel {
  final int? id;
  final int? userId;
  final int? subId;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? companyId;
  final SubscriptionModel? subscriptionPack;
  final ProfileModel? company;
  final ProfileModel? user;

  CorporateModel({
    this.id,
    this.userId,
    this.subId,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.companyId,
    this.subscriptionPack,
    this.company,
    this.user,
  });

  factory CorporateModel.fromJson(Map<String, dynamic> json) => CorporateModel(
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
        companyId: json["company_id"],
        subscriptionPack: json["subscription_pack"] == null
            ? null
            : SubscriptionModel.fromJson(json["subscription_pack"]),
        company: json["company"] == null
            ? null
            : ProfileModel.fromJson(json["company"], null),
        user: json["user"] == null
            ? null
            : ProfileModel.fromJson(json["user"], null),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "sub_id": subId,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "company_id": companyId,
        "subscription_pack": subscriptionPack?.toJson(),
        "company": company?.toJson(),
        "user": user?.toJson(),
      };
}
