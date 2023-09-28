class ChangePasswordParam {
  String? oldPsd;
  String? newPsd;
  String? cfmPsd;

  ChangePasswordParam(
      {this.oldPsd, this.newPsd, this.cfmPsd});

  ChangePasswordParam.fromJson(Map<String, dynamic> json) {
    oldPsd = json['old_psd'];
    newPsd = json['new_psd'];
    cfmPsd = json['cfm_psd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_psd'] = this.oldPsd;
    data['new_psd'] = this.newPsd;
    data['cfm_psd'] = this.cfmPsd;
    return data;
  }
}