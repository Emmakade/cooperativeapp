import 'authorization.dart';
import 'user.dart';
import 'role_permission.dart';

class LoginResponse {
  Authorization? authorization;
  User? user;
  RolePermission? rolePermission;

  LoginResponse({this.authorization, this.user, this.rolePermission});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    authorization = json['authorization'] != null
        ? new Authorization.fromJson(json['authorization'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    rolePermission = json['rolePermission'] != null
        ? new RolePermission.fromJson(json['rolePermission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.authorization != null) {
      data['authorization'] = this.authorization?.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    if (this.rolePermission != null) {
      data['rolePermission'] = this.rolePermission?.toJson();
    }
    return data;
  }
}