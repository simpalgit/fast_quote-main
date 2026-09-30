class TermsModel {
  final String? termId;
  final String? type;
  final String? term;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool? isSelected;

  TermsModel(
      {this.termId,
      this.type,
      this.term,
      this.createdAt,
      this.updatedAt,
      this.isSelected = false});

  set changeSelection(bool val) {
    isSelected = val;
  }

  factory TermsModel.fromJson(Map<String, dynamic> json) => TermsModel(
        termId: json["id"].toString(),
        type: json["type"],
        term: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": termId,
        "type": type,
        "description": term,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
