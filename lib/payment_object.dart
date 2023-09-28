class Passbook {
  String? id;
  String? date;
  List<Payments>? payments;

  Passbook({this.id, this.date, this.payments});

  Passbook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    if (json['payments'] != null) {
      payments = [];
      json['payments'].forEach((v) {
        payments?.add(new Payments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    final payments = this.payments;
    if (payments != null) {
      data['payments'] = payments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payments {
  String? name;
  int? credit;
  int? balance;

  Payments({this.name, this.credit, this.balance});

  Payments.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    credit = json['credit'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['credit'] = this.credit;
    data['balance'] = this.balance;
    return data;
  }
}