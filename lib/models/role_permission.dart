class RolePermission {
  int? id;
  String? roleId;
  String? memberId;
  String? revoked;
  String? permissions;
  String? pages;
  String? info;
  String? createdAt;
  String? updatedAt;

  RolePermission(
      {this.id,
        this.roleId,
        this.memberId,
        this.revoked,
        this.permissions,
        this.pages,
        this.info,
        this.createdAt,
        this.updatedAt});

  RolePermission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    memberId = json['member_id'];
    revoked = json['revoked'];
    permissions = json['permissions'];
    pages = json['pages'];
    info = json['info'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['member_id'] = this.memberId;
    data['revoked'] = this.revoked;
    data['permissions'] = this.permissions;
    data['pages'] = this.pages;
    data['info'] = this.info;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}