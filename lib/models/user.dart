class User {
  int? id;
  String? userid;
  bool? active;
  bool? changePsd;
  String? memberId;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.userid,
        this.active,
        this.changePsd,
        this.memberId,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    active = json['active'];
    changePsd = json['change_psd'];
    memberId = json['member_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userid'] = this.userid;
    data['active'] = this.active;
    data['change_psd'] = this.changePsd;
    data['member_id'] = this.memberId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
