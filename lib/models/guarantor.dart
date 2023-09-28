class Guarantor {
  int? id;
  String? loanRequestId;
  String? memberId;
  String? status;
  String? guarantorImg;
  String? createdAt;
  String? updatedAt;

  Guarantor(
      {this.id,
        this.loanRequestId,
        this.memberId,
        this.status,
        this.guarantorImg,
        this.createdAt,
        this.updatedAt});

  Guarantor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    loanRequestId = json['loan_request_id'];
    memberId = json['member_id'];
    status = json['status'];
    guarantorImg = json['guarantor_img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['loan_request_id'] = this.loanRequestId;
    data['member_id'] = this.memberId;
    data['status'] = this.status;
    data['guarantor_img'] = this.guarantorImg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


class GuarantorRequest {
  int? id;
  String? loanRequestId;
  String? memberId;
  String? status;
  String? guarantorImg;
  String? createdAt;
  String? updatedAt;
  String? loanRequestMemberId;
  String? loanRequestSocietyId;
  String? loanRequestStatus;

  GuarantorRequest(
      {this.id,
        this.loanRequestId,
        this.memberId,
        this.status,
        this.guarantorImg,
        this.createdAt,
        this.updatedAt,
        this.loanRequestMemberId,
        this.loanRequestSocietyId,
        this.loanRequestStatus});

  GuarantorRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    loanRequestId = json['loan_request_id'];
    memberId = json['member_id'];
    status = json['status'];
    guarantorImg = json['guarantor_img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    loanRequestMemberId = json['loan_request_member_id'];
    loanRequestSocietyId = json['loan_request_society_id'];
    loanRequestStatus = json['loan_request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['loan_request_id'] = this.loanRequestId;
    data['member_id'] = this.memberId;
    data['status'] = this.status;
    data['guarantor_img'] = this.guarantorImg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['loan_request_member_id'] = this.loanRequestMemberId;
    data['loan_request_society_id'] = this.loanRequestSocietyId;
    data['loan_request_status'] = this.loanRequestStatus;
    return data;
  }
}