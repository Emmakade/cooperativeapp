class AuthParam {
  late String userid;
  late String password;

  AuthParam({required this.userid, required this.password});

  AuthParam.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['password'] = this.password;
    return data;
  }
}