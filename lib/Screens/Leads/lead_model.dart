import 'package:flutter/material.dart';

/// Lead pipeline stages — mirrors the "Lead Status Guide" shown in the
/// FastQuote design (New / Follow-up / Negotiation / Cold Follow-up / Won / Lost).
enum LeadStatus { newLead, followUp, negotiation, coldFollowUp, meetingRequired, won, lost }

extension LeadStatusX on LeadStatus {
  String get label {
    switch (this) {
      case LeadStatus.newLead:
        return "New Lead";
      case LeadStatus.followUp:
        return "Follow-up Due";
      case LeadStatus.negotiation:
        return "Negotiation";
      case LeadStatus.coldFollowUp:
        return "Cold Follow-up";
      case LeadStatus.meetingRequired:
        return "Meeting Required";
      case LeadStatus.won:
        return "Won";
      case LeadStatus.lost:
        return "Lost";
    }
  }

  /// Which top-level tab (All / New / Follow-up / Negotiation / Won / Lost)
  /// this status should be grouped under.
  String get tabGroup {
    switch (this) {
      case LeadStatus.newLead:
        return "New";
      case LeadStatus.followUp:
      case LeadStatus.coldFollowUp:
      case LeadStatus.meetingRequired:
        return "Follow-up";
      case LeadStatus.negotiation:
        return "Negotiation";
      case LeadStatus.won:
        return "Won";
      case LeadStatus.lost:
        return "Lost";
    }
  }

  Color get color {
    switch (this) {
      case LeadStatus.newLead:
        return const Color(0xFF2563EB);
      case LeadStatus.followUp:
        return const Color(0xFF7C3AED);
      case LeadStatus.negotiation:
        return const Color(0xFFF2994A);
      case LeadStatus.coldFollowUp:
        return const Color(0xFF64748B);
      case LeadStatus.meetingRequired:
        return const Color(0xFFF2C94C);
      case LeadStatus.won:
        return const Color(0xFF10B981);
      case LeadStatus.lost:
        return const Color(0xFFEF4444);
    }
  }
}

/// Simple lead record.
///
/// NOTE: There is no Leads API/table in the FastQuote backend yet — this
/// model + the sample list below exist purely so the Leads screen UI can be
/// built and wired up now. Swap `LeadModel.sampleLeads()` for a real
/// repository call once a `/leads` endpoint exists.
class LeadModel {
  final String company;
  final String contactPerson;
  final String mobile;
  final String email;
  final String source;
  final double value;
  final LeadStatus status;
  final DateTime followUpDate;
  final String assignedTo;

  const LeadModel({
    required this.company,
    required this.contactPerson,
    required this.mobile,
    required this.email,
    required this.source,
    required this.value,
    required this.status,
    required this.followUpDate,
    required this.assignedTo,
  });

  String get initials {
    final parts = company.trim().split(RegExp(r"\s+"));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  static List<LeadModel> sampleLeads() => [
        LeadModel(
          company: "ABC Industries Pvt Ltd",
          contactPerson: "Mr. Amit Bansal",
          mobile: "9876543210",
          email: "amit@abcindustries.com",
          source: "Website",
          value: 850000,
          status: LeadStatus.followUp,
          followUpDate: DateTime(2026, 7, 21),
          assignedTo: "Binod Yadav",
        ),
        LeadModel(
          company: "Delta Engineering",
          contactPerson: "Mr. Deepak Mehta",
          mobile: "9820012345",
          email: "deepak@deltaengg.com",
          source: "Referral",
          value: 520000,
          status: LeadStatus.negotiation,
          followUpDate: DateTime(2026, 7, 22),
          assignedTo: "Rohit Sharma",
        ),
        LeadModel(
          company: "XYZ Corporation",
          contactPerson: "Mr. Yogesh Kulkarni",
          mobile: "9811122233",
          email: "yogesh@xyzcorp.com",
          source: "Trade Show",
          value: 1200000,
          status: LeadStatus.newLead,
          followUpDate: DateTime(2026, 7, 23),
          assignedTo: "Binod Yadav",
        ),
        LeadModel(
          company: "Global Tech Solutions",
          contactPerson: "Ms. Neha Gupta",
          mobile: "9870011223",
          email: "neha@globaltech.com",
          source: "LinkedIn",
          value: 375000,
          status: LeadStatus.coldFollowUp,
          followUpDate: DateTime(2026, 7, 24),
          assignedTo: "Rohit Sharma",
        ),
        LeadModel(
          company: "Prime Solutions Pvt Ltd",
          contactPerson: "Mr. Prakash Nair",
          mobile: "9898989898",
          email: "prakash@primesolutions.com",
          source: "Walk-in",
          value: 680000,
          status: LeadStatus.won,
          followUpDate: DateTime(2026, 7, 18),
          assignedTo: "Binod Yadav",
        ),
      ];
}
