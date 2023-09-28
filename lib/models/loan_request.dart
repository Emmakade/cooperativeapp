//import 'dart:convert';

class LoanRequest {
  int? id;
  int? amountRequested;
  String? purpose;
  int? memberId;
  String? status;
  late int societyId;
  String? executedBy;
  double? interestRate;
  String? createdAt;
  String? updatedAt;

  LoanRequest(
      {this.id,
      this.amountRequested,
      this.purpose,
      this.memberId,
      this.status,
      required this.societyId,
      this.executedBy,
      this.interestRate,
      this.createdAt,
      this.updatedAt});

  LoanRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amountRequested = json['amount_requested'];
    purpose = json['purpose'];
    memberId = json['member_id'];
    status = json['status'];
    societyId = json['society_id'];
    executedBy = json['executed_by'];
    interestRate = json['interest_rate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

//  factory LoanRequest.fromJson(Map<String, dynamic> json) => LoanRequest(
//    id : json['id'],
//    amountRequested : json['amount_requested'],
//    purpose : json['purpose'],
//    memberId : json['member_id'],
//    status : json['status'],
//    societyId : json['society_id'],
//    executedBy : json['executed_by'],
//    interestRate : json['interest_rate'],
//    createdAt : json['created_at'],
//    updatedAt : json['updated_at'],
//  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount_requested'] = this.amountRequested;
    data['purpose'] = this.purpose;
    data['member_id'] = this.memberId;
    data['status'] = this.status;
    data['society_id'] = this.societyId;
    data['executed_by'] = this.executedBy;
    data['interest_rate'] = this.interestRate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
