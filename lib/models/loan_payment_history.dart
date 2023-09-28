class LoanPaymentHistory {
  int? totalLoanAmountRepaid;
  int? totalLoanAmountRemaining;
  List<History>? history;
  int? amountGiven;

  LoanPaymentHistory(
      {this.totalLoanAmountRepaid,
        this.totalLoanAmountRemaining,
        this.history,
        this.amountGiven});

  LoanPaymentHistory.fromJson(Map<String, dynamic> json) {
    totalLoanAmountRepaid = json['total_loan_amount_repaid'];
    totalLoanAmountRemaining = json['total_loan_amount_remaining'];
    if (json['history'] != null) {
      history = [];
      json['history'].forEach((v) {
        history?.add(new History.fromJson(v));
      });
    }
    amountGiven = json['amount_given'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_loan_amount_repaid'] = this.totalLoanAmountRepaid;
    data['total_loan_amount_remaining'] = this.totalLoanAmountRemaining;
    if (this.history != null) {
      data['history'] = this.history?.map((v) => v.toJson()).toList();
    }
    data['amount_given'] = this.amountGiven;
    return data;
  }
}

class History {
  String? amountPaid;
  String? createdAt;
  String? paidBy;
  String? meetingCalendarId;
  int? id;

  History(
      {this.amountPaid,
        this.createdAt,
        this.paidBy,
        this.meetingCalendarId,
        this.id});

  History.fromJson(Map<String, dynamic> json) {
    amountPaid = json['amount_paid'];
    createdAt = json['created_at'];
    paidBy = json['paid_by'];
    meetingCalendarId = json['meeting_calendar_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount_paid'] = this.amountPaid;
    data['created_at'] = this.createdAt;
    data['paid_by'] = this.paidBy;
    data['meeting_calendar_id'] = this.meetingCalendarId;
    data['id'] = this.id;
    return data;
  }
}