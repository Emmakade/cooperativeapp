class LoanRequestParam {
  int? societyId;
  double? amountRequested;
  String? purpose;
  List<int>? guarantorIds;

  LoanRequestParam(
      {this.societyId, this.amountRequested, this.purpose, this.guarantorIds});

  LoanRequestParam.fromJson(Map<String, dynamic> json) {
    societyId = json['society_id'];
    amountRequested = json['amount_requested'];
    purpose = json['purpose'];
    guarantorIds = json['guarantor_ids'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['society_id'] = this.societyId;
    data['amount_requested'] = this.amountRequested;
    data['purpose'] = this.purpose;
    data['guarantor_ids'] = this.guarantorIds;
    return data;
  }
}