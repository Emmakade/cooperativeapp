import 'dart:convert';

import 'package:cooperativeapp/loan.dart';
import 'package:cooperativeapp/models/authorization.dart';
import 'package:cooperativeapp/models/login_response.dart';
import 'package:cooperativeapp/models/meeting_calender.dart';
import 'package:cooperativeapp/models/member.dart';
import 'package:cooperativeapp/models/society.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  void saveLoginDetails(LoginResponse response) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String login = jsonEncode(response);
    sharedPreferences.setString('login', login);
  }

  void saveMember(Member member) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String login = jsonEncode(member);
    sharedPreferences.setString('memberDetails', login);
  }

  Future<Member?> getMember() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? login = sharedPreferences.getString('memberDetails');
    return login==null?null:Member.fromJson(jsonDecode(login));
  }

  void saveAuthorization(Authorization authorization) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String login = jsonEncode(authorization);
    sharedPreferences.setString('authorization', login);
  }

  void saveSocieties(String listSocieties) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //String login = jsonEncode(authorization);
    sharedPreferences.setString('societies', listSocieties);
  }

  void saveLoans(String list) async {
//    print('LOAN LIST: '+list);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('loans', list);
  }

  void saveAssets(String list) async {
//    print('ASSETS LIST: '+list);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('assets', list);
  }

  void saveMeetingDates(String list) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('meetingDates', list);
  }

  Future<List<Asset>?> getAssets() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? str = sharedPreferences.getString('assets');
    if(str == null) return null;
    Map map  = jsonDecode(str);
    List<Asset> list = new List.empty(growable: true);
    if (map['assets'] != null) {
      map['assets'].forEach((v) {
        list.add(new Asset.fromJson(v));
      });
    }
    return list;
  }

  Future<List<MeetingDate>?> getMeetingDates() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? str = sharedPreferences.getString('meetingDates');
    if(str == null) return null;
    Map map  = jsonDecode(str);
    List<MeetingDate> list = new List.empty(growable: true);
    if (map['meetingDates'] != null) {
      map['meetingDates'].forEach((v) {
        list.add(new MeetingDate.fromJson(v));
      });
    }
    return list;
  }

  Future<List<Loan>?> getLoans() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? str = sharedPreferences.getString('loans');
    if(str == null) return null;
    Map map  = jsonDecode(str);
    List<Loan> list = new List.empty(growable: true);
    if (map['loans'] != null) {
      map['loans'].forEach((v) {
        list.add(new Loan.fromJson(v));
      });
    }
    return list;
  }

  Future<List<Society>?> getSocieties() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? societies = sharedPreferences.getString('societies');
    if(societies == null) return null;
    Map societiesMap  = jsonDecode(societies);
    List<Society> list = new List.empty(growable: true);
    if (societiesMap['societies'] != null) {
      societiesMap['societies'].forEach((v) {
        list.add(new Society.fromJson(v));
      });
    }
    return list;
  }

  Future<LoginResponse?> getLoginDetails() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? login = sharedPreferences.getString('login');
    return login == null?null:LoginResponse.fromJson(jsonDecode(login));
  }

  Future<Authorization?> getAuthorization() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? auth = sharedPreferences.getString('authorization');
    return auth==null?null:Authorization.fromJson(jsonDecode(auth));
  }

  void saveIsFresh(bool isFresh) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('isFresh', isFresh);
  }

  Future<bool?> getIsFresh() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isFresh');
  }

}