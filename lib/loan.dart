class Loan {
  double? amount;
  String? societyId;

  Loan({this.amount, this.societyId});

  Loan.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    societyId = json['societyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['societyId'] = this.societyId;
    return data;
  }
}

class Asset {
  double? amount;
  String? societyId;

  Asset({this.amount, this.societyId});

  Asset.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    societyId = json['societyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['societyId'] = this.societyId;
    return data;
  }
}