import 'guarantor.dart';
import 'loan_request.dart';

class LoanRequestResponse {
  LoanRequest? loanRequest;
  List<Guarantor>? guarantors;

  LoanRequestResponse({this.loanRequest, this.guarantors});

  LoanRequestResponse.fromJson(Map<String, dynamic> json) {
    loanRequest = json['loanRequest'] != null
        ? new LoanRequest.fromJson(json['loanRequest'])
        : null;
    if (json['guarantors'] != null) {
      guarantors = [];
      json['guarantors'].forEach((v) {
        guarantors?.add(new Guarantor.fromJson(v));
      });
    }
  }
}

class LoanRequestResp{
  List<LoanRequest>? loanRequests;

  LoanRequestResp({this.loanRequests});

  LoanRequestResp.fromJson(Map<String, dynamic> json) {
    if (json['loanRequests'] != null) {
      loanRequests = [];
      json['loanRequests'].forEach((v) {
        loanRequests?.add(new LoanRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loanRequests != null) {
      data['loanRequests'] = this.loanRequests?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
