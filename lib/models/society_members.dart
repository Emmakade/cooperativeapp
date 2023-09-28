class SocietyMember {
  int? id;
  String? memberId;
  String? societyId;
  String? deleted;
  String? passport;
  String? createdAt;
  String? updatedAt;

  SocietyMember(
      {this.id,
        this.memberId,
        this.societyId,
        this.deleted,
        this.passport,
        this.createdAt,
        this.updatedAt});

  SocietyMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['member_id'];
    societyId = json['society_id'];
    deleted = json['deleted'];
    passport = json['passport'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['member_id'] = this.memberId;
    data['society_id'] = this.societyId;
    data['deleted'] = this.deleted;
    data['passport'] = this.passport;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


class MemberSociety {
  int? id;
  int? societyId;
  int? memberId;
  String? createdAt;
  String? updatedAt;

  MemberSociety(
      {this.id, this.societyId, this.memberId, this.createdAt, this.updatedAt});

  MemberSociety.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    societyId = json['society_id'];
    memberId = json['member_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['society_id'] = this.societyId;
    data['member_id'] = this.memberId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}