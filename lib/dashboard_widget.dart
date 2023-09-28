import 'dart:convert';
import 'package:cooperativeapp/loan.dart';
import 'package:cooperativeapp/models/meeting_calender.dart';
import 'package:cooperativeapp/models/society_members.dart';

import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/my_color.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:cooperativeapp/calender_carousel.dart';
import 'package:cooperativeapp/swipe_widget.dart';
import 'package:cooperativeapp/dio/api_base_helper.dart';
import 'package:cooperativeapp/models/society.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'models/login_response.dart';
import 'models/member.dart';

class DashboardWidget extends StatefulWidget {
  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
  String welcomeStr = 'Hi, ',
      assetSocietyName = '',
      loanSocietyName = '',
      nextDate11 = '',
      nextDate12 = '',
      nextDate21 = '',
      nextDate22 = '';
  Member _member = new Member();
  PageController controller = PageController();
  dynamic asset = 0.0;
  dynamic loanBal = 0.0;
  int id = 0;
  var currentPageValue = 0.0;
  late LoginResponse loginResponse;
  List<Society> _listSocieties = new List.empty(growable: true);
  List<Asset> assets = new List.empty(growable: true);
  List<Loan> loans = new List.empty(growable: true);
  List<PopupMenuEntry> societyPopMenu = new List.empty(growable: true);
  bool isLoading = true;
  List<MeetingDate> meetingDates = List.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

//    getSocietiesFromServer().then((value){
//
//      final Map<String, dynamic> data = new Map<String, dynamic>();
//      if (this._listSocieties != null) {
//        data['societies'] =
//            this._listSocieties.map((v) => v.toJson()).toList();
//      }
//      LocalStorage().saveSocieties(jsonEncode(data));
//
//      DateTime date = DateTime.now();
//      Jiffy jiffy = Jiffy([date.year, date.month, date.day]).startOf(Units.HOUR);
//      setState(() {
//        nextDate11 = jiffy.format('do');
//        nextDate12 = jiffy.format('EEEE');
//        nextDate21 = jiffy.format('MMMM, yyyy');
//        nextDate22 = '(Odokoto Ifeoluwa 1)'+'\n'+'20 days to go';
//      });
//      _listSocieties.forEach((e){
//        societyPopMenu.add(PopupMenuItem(
//            child: Text(e.name), value: 1));
//      });
//    });

    (LocalStorage().getLoginDetails()).then((value) {
      setState(() {
        loginResponse = value!;
      });
      (LocalStorage().getIsFresh()).then((freshValue) {
//        print(freshValue);
        AppDialogs().onLoadingDialog(context);
        if (freshValue ?? true) {
          getFromServer().then((value) {
            setDashboard().then((value) {
              Navigator.pop(context);
            });
          });
        } else {
          getFromLocalStorage().then((value) {
            setDashboard().then((value) {
              Navigator.pop(context);
            });
          });
        }
      });
    });
  }

  Future<void> getFromServer() async {
    if (loginResponse != null) {
      await getMemberFromServer().then((value) async {
//          print('Member Done');
        await getSocietiesFromServer().then((value) async {
//            print('Societies Done');
          await getAssetsFromServer().then((value) async {
//              print('Assets Done');
            await getLoansFromServer().then((value) async {
//                print('Loans Done');
              await getDatesFromServer().then((value) async {
//                  print('Meeting Dates Done');
                () async {
                  await Future.delayed(Duration(seconds: 10));
                  dashboardToJson();
                }();
              });
            });
          });
        });
      });
    } else {
      () async {
        await Future.delayed(Duration.zero);
        AppDialogs().showToast('Error', "Empty Response", context);
      }();
    }
  }

  Future<void> getAssetsFromServer() async {
    _listSocieties.forEach((element) async {
      await ApiBaseHelper().getTotalAsset(element.id.toString()).then((value) {
        if (value.success) {
          () async {
            await Future.delayed(Duration.zero);
            assets.add(new Asset(
                amount: double.parse(value.data.toString()),
                societyId: element.id.toString()));
          }();
        }
      });
    });
  }

  Future<void> getMemberFromServer() async {
    await (ApiBaseHelper().getUserDetails(loginResponse.user?.memberId ?? ''))
        .then((value) {
      if (value.success) {
        setState(() {
          _member = value.data!;
        });
      } else {
        AppDialogs()
            .handleErrorFromServer(value.statusCode ?? 0, value, context);
      }
    });
  }

  Future<void> getSocietiesFromServer() async {
    await (ApiBaseHelper().getUserSocieties()).then((value) async {
      if (value.success) {
        List<int> ids = List.empty(growable: true);
        for (SocietyMember element in value.data ?? []) {
          ids.add(int.parse(element.societyId!));
        }
        await (ApiBaseHelper().getManySocieties(ids)).then((value) {
          if (value.success) {
//            print('Societies Done');
            setState(() {
              _listSocieties.addAll(value.data ?? []);
            });
          } else {
            AppDialogs()
                .handleErrorFromServer(value.statusCode ?? 0, value, context);
          }
        });
      } else {
        AppDialogs()
            .handleErrorFromServer(value.statusCode ?? 0, value, context);
      }
    });
  }

  Future<void> getLoansFromServer() async {
    _listSocieties.forEach((element) async {
      await ApiBaseHelper()
          .getCurrentLoanBal(_member.id.toString(), element.id.toString())
          .then((value) {
        if (value.success) {
          () async {
            await Future.delayed(Duration.zero);
            loans.add(new Loan(
                amount: double.parse(value.data.toString()),
                societyId: element.id.toString()));
          }();
        }
      });
    });
  }

  Future<void> getDatesFromServer() async {
    if (_listSocieties.length > 0) {
      DateTime today = new DateTime.now();
      for (Society society in _listSocieties) {
        await (ApiBaseHelper().getMeetingCalender(
                society.id.toString(), today.year.toString()))
            .then((value) {
          if (value.success) {
            meetingDates.addAll(value.data ?? []);
          }
        });
      }
    }
  }

  Future<void> getFromLocalStorage() async {
    _listSocieties.clear();
    assets.clear();
    loans.clear();
    meetingDates.clear();
    await LocalStorage().getMember().then((value) async {
//      print('Member: '+ value.name);
      setState(() {
        _member = value!;
      });

      await LocalStorage().getSocieties().then((value) async {
//        print('Societies: '+ value.first.name);
        setState(() {
          _listSocieties.addAll(value ?? []);
        });

        await LocalStorage().getAssets().then((value) async {
//          print('Assets: '+value.first.amount.toString());
          setState(() {
            assets.addAll(value ?? []);
          });

          await LocalStorage().getMeetingDates().then((value) async {
//              print('MeetingDates: '+value.first.meetingDate);
            setState(() {
              meetingDates.addAll(value ?? []);
            });

            await LocalStorage().getLoans().then((value) async {
//                print('Loans: '+value.first.amount.toString());
              setState(() {
                loans.addAll(value ?? []);
              });
            });
          });
        });
      });
    });
  }

  Future<void> dashboardToJson() async {
    LocalStorage().saveMember(_member);

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['societies'] = this._listSocieties.map((v) => v.toJson()).toList();
    LocalStorage().saveSocieties(jsonEncode(data));

    final Map<String, dynamic> dataLoan = new Map<String, dynamic>();
    dataLoan['loans'] = this.loans.map((v) => v.toJson()).toList();
    LocalStorage().saveLoans(jsonEncode(dataLoan));

    final Map<String, dynamic> dataAssets = new Map<String, dynamic>();
    dataAssets['assets'] = this.assets.map((v) => v.toJson()).toList();
    LocalStorage().saveAssets(jsonEncode(dataAssets));

    final Map<String, dynamic> dataMeetingDates = new Map<String, dynamic>();
    dataMeetingDates['meetingDates'] =
        this.meetingDates.map((v) => v.toJson()).toList();
    LocalStorage().saveMeetingDates(jsonEncode(dataMeetingDates));

    LocalStorage().saveIsFresh(false);
  }

  void setNextMeetingDates() {
    if (meetingDates.isNotEmpty &&
        meetingDates
            .where((element) =>
                parseDateStr(element.meetingDate!).isAfter(DateTime.now()))
            .isNotEmpty) {
      meetingDates.retainWhere((element) =>
          parseDateStr(element.meetingDate!).isAfter(DateTime.now()));
      meetingDates.sort((a, b) =>
          parseDateStr(a.meetingDate!).compareTo(parseDateStr(b.meetingDate!)));

      MeetingDate meetingDate = meetingDates.elementAt(0);
      DateTime date = parseDateStr(meetingDate.meetingDate!);
      final differenceInDays = date.difference(DateTime.now()).inDays;
      Jiffy jiffy =
          Jiffy([date.year, date.month, date.day]).startOf(Units.HOUR);
      setState(() {
        nextDate11 = jiffy.format('do');
        nextDate12 = jiffy.format('EEEE');
        nextDate21 = jiffy.format('MMMM, yyyy');
        nextDate22 = '' +
            (_listSocieties
                    .firstWhere((element) =>
                        element.id.toString() == meetingDate.societyId)
                    .name ??
                '') +
            '\n' +
            differenceInDays.toString() +
            ' days to go';
      });
    } else {
      setState(() {
        nextDate21 = 'No Next Meeting For this Year';
      });
    }
  }

  Future<void> setDashboard() async {
    setState(() {
//      print('Setting...');
      welcomeStr = welcomeStr + _member.name!;
      loanSocietyName = _listSocieties.first.name!;
      assetSocietyName = _listSocieties.first.name!;
      if (loans.isEmpty) {
        loanBal = 0.0;
      } else {
        loanBal = loans.first.amount;
      }

      if (assets.isEmpty) {
        asset = 0.0;
      } else {
        asset = assets.first.amount;
      }
    });
    setNextMeetingDates();
    _listSocieties.forEach((e) {
      societyPopMenu.add(PopupMenuItem(child: Text(e.name ?? ''), value: e.id));
    });
  }

  DateTime parseDateStr(String dateStr) {
    String subString = dateStr.substring(0, dateStr.indexOf(' '));
    var ints = subString.split('-');
    return DateTime(int.parse(ints[0]), int.parse(ints[1]), int.parse(ints[2]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Padding(
            padding: EdgeInsets.only(left: 7),
            child: Text(
              ' ' + welcomeStr,
              style: TextStyle(
                color: MyColor.navy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark),
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: MyColor.navy),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.info,
                ),
                onPressed: () {
                  bottomSheetContact();
                }),
            IconButton(
                icon: Icon(
                  Icons.logout,
                ),
                onPressed: () {
                  AppDialogs().showLogoutAlertDialog(context);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.grey[50],
            padding: EdgeInsets.all(16),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomCenter,
            //       colors: <Color>[Colors.white, Colors.grey[100]!]),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SwipeWidget(
                  AssetCard: buildAssetCard(),
                  LoanCard: buildLoanCard(),
                ),

                SizedBox(
                  height: 5,
                ),
                buildSubtitle(' Activities'),
                buildActivityItem("Meeting Calender", Colors.grey[100]!,
                    "assets/cal-icon.png", 0),
                //buildActivityItem("Guarantors Request", Colors.red, 1),
                buildActivityItem("Request Loan", Colors.grey[100]!,
                    "assets/loan-icon.png", 2),
                buildActivityItem("Make Payment", Colors.grey[100]!,
                    "assets/pay-icon.png", 3),
                SizedBox(
                  height: 15,
                ),
                buildSubtitle('  Next Meeting Date'),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                    ),
                    elevation: 10,
                    color: MyColor.navy,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 35.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: !nextDate21
                                .toLowerCase()
                                .contains('no next meeting'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/cal-icon.png",
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(nextDate11,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ],
                                ),
                                Text(nextDate12,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: !nextDate21
                                  .toLowerCase()
                                  .contains('no next meeting'),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 24),
                                width: 1,
                                height: 36,
                                color: Colors.white,
                              )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(nextDate21,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Visibility(
                                    visible: !nextDate21
                                        .toLowerCase()
                                        .contains('no next meeting'),
                                    child: Text(nextDate22,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubtitle(String txt) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        txt,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildAssetCard() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              // gradient: LinearGradient(
              //     colors: <Color>[Colors.deepPurple, Colors.lightBlueAccent]),
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(1, 3))
              ]),
          padding: EdgeInsets.fromLTRB(20, 28, 16, 28),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Total Asset/Savings',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      '\u20A6' + numberFormat.format(asset),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('(' + assetSocietyName + ')',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) =>
                    _showAssetPopMenu(details.globalPosition, societyPopMenu),
                child: Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {}),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLoanCard() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              // gradient: LinearGradient(
              //     colors: <Color>[Colors.black87, Colors.blueGrey]),
              color: MyColor.navy,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(1, 3))
              ]),
          padding: EdgeInsets.fromLTRB(20, 28, 16, 28),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Loan Balance',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      '\u20A6' + numberFormat.format(loanBal),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('(' + loanSocietyName + ')',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              GestureDetector(
                onTapDown: (TapDownDetails details) =>
                    _showLoanPopMenu(details.globalPosition, societyPopMenu),
                child: Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {}),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildActivityItem(String text, Color color, String img, int id) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: color),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              ),
              onPressed: () {
                navigate(id);
              },
              child: Row(
                children: <Widget>[
                  Image.asset(
                    img,
                    width: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      text.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_right, color: Colors.blue)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  navigate(int id) async {
    if (id == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CarouselCalender()));
    } else if (id == 1) {
    } else if (id == 2) {
      Navigator.pushNamed(context, '/requestloan');
    } else if (id == 3) {
      Navigator.pushNamed(context, '/payment');
    }
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: 'cardNumber',
      cvc: 'cvv',
      expiryMonth: 2,
      expiryYear: 2030,
    );
  }

  _showAssetPopMenu(Offset offset, List<PopupMenuEntry> pop) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 10000000, 0),
      items: pop,
      elevation: 5.0,
    ).then<void>((value) {
      if (value == null) return;
      setState(() {
        assetSocietyName =
            _listSocieties.firstWhere((element) => element.id == value).name ??
                '';
        asset = assets
            .firstWhere((element) => element.societyId == value.toString())
            .amount;
      });
    });
  }

  _showLoanPopMenu(Offset offset, List<PopupMenuEntry> pop) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 10000000, 0),
      items: pop,
      elevation: 5.0,
    ).then<void>((value) {
      if (value == null) return;
      setState(() {
        loanSocietyName =
            _listSocieties.firstWhere((element) => element.id == value).name ??
                '';
        loanBal = loans
            .firstWhere((element) => element.societyId == value.toString())
            .amount;
      });
    });
  }

  void bottomSheetContact() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(children: <Widget>[
          Container(
              color: Color(0xFF737373),
              child: new Container(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        height: 24,
                      ),
                      Text(
                        'Contact Us through:',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                          ),
                          Text('    +234 903 8693 378  | +234 706 6806 055')
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.email, size: 14),
                          Text('    info@ogbomosooluwalosecicu.com.ng')
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'App Version: v1.1.0',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '\u00a9 Ogbomoso Oluwalose C.I.C.U Ltd., ' +
                            DateTime.now().year.toString(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      Divider(
                        height: 24,
                      ),
                      Text(
                        'Developed by Hallmark Digital Solutions',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],
                  )))
        ]);
      },
    );
  }
}
