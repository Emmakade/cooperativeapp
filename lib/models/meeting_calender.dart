class MeetingDate {
  String? societyId;
  String? meetingDate;
  int? id;
  String? year;

  MeetingDate({this.societyId, this.meetingDate, this.id, this.year});

  MeetingDate.fromJson(Map<String, dynamic> json) {
    societyId = json['society_id'];
    meetingDate = json['meeting_date'];
    id = json['id'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['society_id'] = this.societyId;
    data['meeting_date'] = this.meetingDate;
    data['id'] = this.id;
    data['year'] = this.year;
    return data;
  }
}