import 'package:cooperativeapp/models/loan_payment_history.dart';
import 'package:cooperativeapp/models/loan_request.dart';
import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:cooperativeapp/util/widget_society_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'dio/api_base_helper.dart';
import 'models/base_response.dart';
import 'models/guarantor.dart';
import 'models/member.dart';
import 'models/society.dart';

class LoanHistoryWidget extends StatefulWidget {
  @override
  _LoanHistoryWidgetState createState() => _LoanHistoryWidgetState();
}

class _LoanHistoryWidgetState extends State<LoanHistoryWidget> {
  List<Society> societies = List.empty(growable: true);
  Society _selectedSocietyValue = new Society(name: 'Choose Society');
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
  List<LoanRequest> loanRequests = List.empty(growable: true);
  List<LoanRequest> filteredList = List.empty(growable: true);
  ApiBaseHelper apiBaseHelper = new ApiBaseHelper();
  bool isLoading = true;

  List<TextStyle> textStyles = [
    TextStyle(color: Colors.green),
    TextStyle(color: Colors.black),
    TextStyle(color: Colors.grey[500])
  ];

  void initState() {
    // TODO: implement initState
//    societyNames.add('Choose Society');
    societies.add(_selectedSocietyValue);
    (LocalStorage().getSocieties()).then((value) => initSociety(value));
    super.initState();
  }

  void initSociety(List<Society>? value) {
    setState(() {
      societies.addAll(value ?? []);
    });
    (apiBaseHelper.getLoanRequests()).then((value) => initData(value));
  }

  void initData(ListResponse<LoanRequest> response) {
    setState(() {
      isLoading = false;
    });
    print('Response: ' + (response.msg ?? ''));
    if (response.success) {
      setState(() {
        loanRequests.addAll(response.data!);
        filteredList.addAll(response.data!);
      });
    } else {
      AppDialogs()
          .handleErrorFromServer(response.statusCode ?? 0, response, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: SocietyDropDown(
                      selectedSociety: _selectedSocietyValue,
                      societies: societies,
                      onChangeValue: (newValue) {
                        setState(() {
                          _selectedSocietyValue = newValue;
                        });
                        if (_selectedSocietyValue.name == 'Choose Society')
                          return;
                        setState(() {
                          filteredList.addAll(loanRequests.where((element) =>
                              element.societyId == _selectedSocietyValue.id));
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          isLoading
              ? Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: loanRequests.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime =
                            DateTime.parse(loanRequests[index].updatedAt!);
                        Jiffy jiffy = new Jiffy(
                            [dateTime.year, dateTime.month, dateTime.day]);
                        return Column(
                          children: <Widget>[
                            GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                _showPopMenu(details.globalPosition, index);
                              },
                              child: ListTile(
                                leading: SizedBox(
                                  width: 4,
                                  child: Container(
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                title: Text(
                                  "\u20A6" +
                                      numberFormat.format(
                                          loanRequests[index].amountRequested),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text((societies.firstWhere((e) =>
                                        e.id ==
                                        loanRequests[index].societyId)).name! +
                                    " (" +
                                    loanRequests[index]
                                        .interestRate
                                        .toString() +
                                    "% per month)"),
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    getStatusIcon(loanRequests[index].status!),
                                    Text(
                                      jiffy.format('dd/MM/yy'),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    )
                                  ],
                                ),
                                minLeadingWidth: 10,
                              ),
                            ),
                            Divider()
                          ],
                        );
                      }),
                )
        ],
      ),
    );
  }

  Icon getStatusIcon(String status) {
    if (status == 'granted') {
      return Icon(Icons.done, color: Colors.green);
    } else if (status == 'pending') {
      return Icon(Icons.hourglass_full, color: Colors.orange);
    } else {
      return Icon(Icons.close, color: Colors.grey[500]);
    }
  }

  void showToast(String msg, BuildContext context) {
    //i am not sure of the snackbar i corrected here
    Scaffold.of(context)
        .showBottomSheet((context) => (SnackBar(content: Text(msg))));
  }

  Widget _bottomSheetViewHistory(int index) {
    return Wrap(children: <Widget>[
      Container(
          color: Color(0xFF737373),
          child: new Container(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(0.0),
                      topRight: const Radius.circular(0.0))),
              child: ViewHistory(id: loanRequests[index].id.toString())))
    ]);
  }

  Widget _bottomSheetViewGuarantor(int index) {
    return Wrap(
      children: <Widget>[
        Container(
            color: Color(0xFF737373),
            child: new Container(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(0.0),
                        topRight: const Radius.circular(0.0))),
                child: ViewGuarantors(
                    id: loanRequests[index].id.toString(),
                    societyId: loanRequests[index].societyId)))
      ],
    );
  }

  _showPopMenu(Offset offset, int index) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 10000000, 0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          child: Text('View History'),
          value: 1,
        ),
        PopupMenuItem(
          child: Text('View Guarantors'),
          value: 2,
        ),
      ],
      elevation: 5.0,
    ).then<void>((value) async {
      if (value == 1) {
        int option = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => _bottomSheetViewHistory(index),
        );
      } else if (value == 2) {
        int option = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => _bottomSheetViewGuarantor(index),
        );
      }
    });
  }
}

class ViewHistory extends StatefulWidget {
  final String id;
  ViewHistory({required this.id});
  @override
  _ViewHistoryState createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
  LoanPaymentHistory? paymentHistory = new LoanPaymentHistory();
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState

    (ApiBaseHelper().getLoanPaymentHistory(widget.id)).then((value) {
      if (value.success) {
        setState(() {
          isLoading = false;
          paymentHistory = value.data;
        });
      } else {
        AppDialogs()
            .handleErrorFromServer(value.statusCode ?? 0, value, context);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Loan Payment History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(),
        isLoading
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : body(),
      ],
    ));
  }

  Widget body() {
    return Column(
      children: [
        Container(
          height: 400,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: paymentHistory?.history?.length ?? 0,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        parseDate(
                            paymentHistory?.history![index].createdAt ?? ''),
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      ),
                      trailing: Text(
                        "\u20A6" +
                            numberFormat.format(double.parse(
                                paymentHistory?.history?[index].amountPaid ??
                                    '0')),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Divider()
                  ],
                );
              }),
        ),
        Column(
          children: [
            ListTile(
              title: Text(
                'Total Loan:',
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                  "\u20A6" + numberFormat.format(paymentHistory?.amountGiven),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            ListTile(
              title: Text(
                'Total Paid:',
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                  "\u20A6" +
                      numberFormat
                          .format(paymentHistory?.totalLoanAmountRepaid),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            ListTile(
              title: Text(
                'Balance: ',
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                  "\u20A6" +
                      numberFormat
                          .format(paymentHistory?.totalLoanAmountRemaining),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ],
        ),
      ],
    );
  }

  String parseDate(String date) {
    print(date);
    var parsedDate = DateTime.parse(date);
    return parsedDate.day.toString() +
        '/' +
        parsedDate.month.toString() +
        '/' +
        parsedDate.year.toString();
  }
}

class ViewGuarantors extends StatefulWidget {
  final String id;
  final int societyId;
  ViewGuarantors({required this.id, required this.societyId});
  @override
  _ViewGuarantorsState createState() => _ViewGuarantorsState();
}

class _ViewGuarantorsState extends State<ViewGuarantors> {
  List<Guarantor> guarantors = List.empty(growable: true);
  List<Member> members = List.empty(growable: true);
  List<Society> societies = List.empty(growable: true);
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    (ApiBaseHelper().getLoanGuarantors(widget.id)).then((value) {
      if (value.success) {
        List<int> ids = List.empty(growable: true);
        for (Guarantor guarantor in value.data ?? []) {
          ids.add(int.parse(guarantor.memberId!));
        }
        (ApiBaseHelper().getManyMembers(ids)).then((value) {
          if (value.success) {
            setState(() {
              members.addAll(value.data ?? []);
              this.isLoading = false;
            });
          } else {
            setState(() {
              this.isLoading = false;
            });
            AppDialogs()
                .handleErrorFromServer(value.statusCode ?? 0, value, context);
          }
        });
        setState(() {
          guarantors.addAll(value.data ?? []);
        });
      }
    });

    (LocalStorage().getSocieties()).then((value) {
      setState(() {
        societies.addAll(value ?? []);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Guarantors List',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          Divider(),
          isLoading
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: 400,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: guarantors.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Ink(
                            //color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.indigoAccent,
                                      child: members[index].passport == ''
                                          ? Icon(Icons.person)
                                          : ClipOval(
                                              clipBehavior: Clip.hardEdge,
                                              child: Image.network(
                                                members[index].passport ?? '',
                                                height: 48,
                                                width: 48,
                                                scale: 1,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context,
                                                    exception, stackTrace) {
                                                  return ClipOval(
                                                      child: Image.asset(
                                                    'assets/default_female_avatar.png',
                                                    fit: BoxFit.cover,
                                                  ));
                                                },
                                              ),
                                            )),
                                  title: Text(members[index].name!,
                                      style: getTextStyle(
                                          guarantors[index].status!)),
                                  subtitle: Text(
                                      societies
                                          .firstWhere((element) =>
                                              element.id == widget.societyId)
                                          .name!,
                                      style: getTextStyle(
                                          guarantors[index].status!)),
                                  contentPadding: EdgeInsets.all(0),
                                  trailing:
                                      getStatusIcon(guarantors[index].status!),
                                ),
                                Divider()
                              ],
                            ),
                          ),
                        );
                      }),
                )
        ],
      ),
    );
  }

  String parseDate(String date) {
    var parsedDate = DateTime.parse(date);
    return parsedDate.day.toString() +
        '/' +
        parsedDate.month.toString() +
        '/' +
        parsedDate.year.toString();
  }

  Icon getStatusIcon(String status) {
    if (status == 'accepted') {
      return Icon(Icons.done, color: Colors.green);
    } else if (status == 'pending') {
      return Icon(Icons.hourglass_full, color: Colors.black);
    } else {
      return Icon(Icons.close, color: Colors.grey[500]);
    }
  }

  Color getColor(String status) {
    if (status == 'accepted') {
      return Colors.greenAccent;
    } else if (status == 'rejected') {
      return Colors.grey.shade200;
    } else {
      return Colors.yellow;
    }
  }

  TextStyle getTextStyle(String status) {
    if (status == 'accepted') {
      return TextStyle(color: Colors.black);
    } else if (status == 'rejected') {
      return TextStyle(color: Colors.grey[500]);
    } else {
      return TextStyle(color: Colors.green);
    }
  }
}
