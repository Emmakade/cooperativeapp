class Member {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? passport;
  String? gender;
  String? canPay;
  String? registerBy;
  String? createdAt;
  String? updatedAt;

  Member(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.passport,
        this.gender,
        this.canPay,
        this.registerBy,
        this.createdAt,
        this.updatedAt});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    passport = json['passport'];
    gender = json['gender'];
    canPay = json['can_pay'];
    registerBy = json['register_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['passport'] = this.passport;
    data['gender'] = this.gender;
    data['can_pay'] = this.canPay;
    data['register_by'] = this.registerBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}