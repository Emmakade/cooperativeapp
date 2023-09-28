class GuarantorResponseParam {
  String? response;
  String? loanRequestId;
  String? guarantorImg;

  GuarantorResponseParam(
      {this.response, this.loanRequestId, this.guarantorImg});

  GuarantorResponseParam.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    loanRequestId = json['loan_request_id'];
    guarantorImg = json['guarantor_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['loan_request_id'] = this.loanRequestId;
    data['guarantor_img'] = this.guarantorImg;
    return data;
  }
}