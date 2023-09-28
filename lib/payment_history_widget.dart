import 'package:cooperativeapp/dio/api_base_helper.dart';
import 'package:cooperativeapp/payment_object.dart';
import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:cooperativeapp/util/widget_society_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'models/society.dart';

class PaymentHistoryWidget extends StatefulWidget {
  @override
  _PaymentHistoryWidgetState createState() => _PaymentHistoryWidgetState();
}

class _PaymentHistoryWidgetState extends State<PaymentHistoryWidget> {
  final numberFormat = new NumberFormat("#,##0", "en_US");
  List<Society> societies = List.empty(growable: true);
  Society selectedSociety = new Society(name: 'Choose Society');
  String displayText = '';
  List<Passbook> passbooks = List.empty(growable: true);
  bool isLoading = false;
  bool isIdAvailable = false;

  DateTime? fromDate;
  DateTime? toDate;

  Future<void> _selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> _selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    displayText = 'Please\nselect a society\nto proceed';
    societies.add(selectedSociety);
    (LocalStorage().getSocieties()).then((value) => initSociety(value));
    super.initState();
  }

  void initSociety(List<Society>? value) {
    setState(() {
      societies.addAll(value ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SocietyDropDown(
                  selectedSociety: selectedSociety,
                  societies: societies,
                  onChangeValue: (newValue) {
                    if (newValue.name == 'Choose Society') {
                      setState(() {
                        passbooks.clear();
                        selectedSociety = newValue;
                        isIdAvailable = false;
                      });
                      return;
                    }
                    setState(() {
                      selectedSociety = newValue;
                      isLoading = true;
                    });
                    (ApiBaseHelper()
                            .getMemberPassbook(selectedSociety.id.toString()))
                        .then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      if (value.success) {
                        passbooks.clear();
                        isIdAvailable = true;
                        setState(() {
                          passbooks.addAll(value.data ?? []);
                          if (passbooks.isEmpty) {
                            setState(() {
                              displayText = 'No Payment History\nAvailable';
                            });
                          }
                        });
                      } else {
                        AppDialogs().handleErrorFromServer(
                            value.statusCode ?? 0, value, context);
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        if (isIdAvailable) buildFilter(),
        Divider(),
        buildBody()
      ]),
    );
  }

//  child: Row(
//  children: [
////                  Container(margin: EdgeInsets.only(right: 8), width: 3, height: 65, color: Colors.grey,),
//  Padding(
//  padding: const EdgeInsets.all(18.0),
//  child: Row(
//  children: [
//  Column(
//  crossAxisAlignment: CrossAxisAlignment.start,
//  children: [
//  Text(jiffy.format('do'),style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//  Text(jiffy.format('EEEE'),style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal)),
//  ],
//  ),
//  Container(margin: EdgeInsets.symmetric(horizontal: 24), width: 1, height: 35, color: Colors.grey.shade400,),
//  Column(
//  crossAxisAlignment: CrossAxisAlignment.start,
//  children: [
//  Text(jiffy.format('MMMM, yyyy'),style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
////                            Text('2021',style: TextStyle(fontSize: 16, )),
//  ],
//  )
//  ],
//  ),
//  )
//  ],
//  ),

  Widget buildFilter() {
    String from = "${fromDate?.toLocal()}".split(' ')[0];
    String to = "${toDate?.toLocal()}".split(' ')[0];
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text("From"),
      GestureDetector(
          onTap: () => _selectDateFrom(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(fromDate != null ? from : 'Select a Date'),
          )),
      Text("To"),
      GestureDetector(
        onTap: () => _selectDateTo(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(toDate != null ? to : 'Select a Date'),
        ),
      ),
      ElevatedButton(
          onPressed: () {
            if (fromDate != null && toDate != null) {
              String Dfrom = "${fromDate!.toLocal()}".split(' ')[0];
              String Dto = "${toDate!.toLocal()}".split(' ')[0];
              (ApiBaseHelper().getMemberPassbookFromTo(
                      selectedSociety.id.toString(),
                      from: Dfrom,
                      to: Dto))
                  .then((value) {
                setState(() {
                  isLoading = false;
                });
                if (value.success) {
                  passbooks.clear();
                  setState(() {
                    passbooks.addAll(value.data ?? []);
                    if (passbooks.isEmpty) {
                      setState(() {
                        displayText = 'No Payment History\nAvailable';
                      });
                    }
                  });
                } else {
                  AppDialogs().handleErrorFromServer(
                      value.statusCode ?? 0, value, context);
                }
              });
            } else {
              AppDialogs().showToast(
                  "Empty Date",
                  'Select a date "from" and "to" date widget to filter',
                  context);
            }
          },
          child: Text("Go!"))
    ]);
  }

  Widget buildBody() {
    if (!isLoading && passbooks.length > 0) {
      return Flexible(
        child: ListView.builder(
            itemCount: passbooks.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DateTime date = parseDateStr(passbooks[index].date!);
              Jiffy jiffy = Jiffy([date.year, date.month, date.day]);
              //Jiffy jiffy = Jiffy([int.parse(dates[0]),int.parse(dates[1]),int.parse(dates[2])]);
              return Column(
                children: <Widget>[
                  ExpansionTile(
                    title: Row(
                      children: [
                        SizedBox(
                          width: 4,
                          height: 40,
                          child: Container(
                            color: Colors.lightBlue,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Container(
                            child: Text(jiffy.format('do MMMM, yyyy'),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ],
                    ),
                    children: <Widget>[
                      _buildExpandableContent(passbooks[index])
                    ],
                  ),
                  Divider(),
                ],
              );
            }),
      );
    } else if (isLoading) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    } else {
      return buildDisplayText();
    }
  }

  DateTime parseDateStr(String dateStr) {
    List<String> list = dateStr.split('/');
    DateTime dateTime =
        DateTime(int.parse(list[2]), int.parse(list[1]), int.parse(list[0]));
    return dateTime;
  }

  Widget buildDisplayText() {
    return Expanded(
        child: Center(
            child: Text(
      displayText,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.blue),
    )));
  }

  _buildExpandableContent(Passbook passbook) {
    List<Widget> items = List.empty(growable: true);
    (passbook.payments ?? []).forEach((element) {
      items.add(Row(
        children: <Widget>[
          Expanded(child: Text(element.name ?? '')),
          _buildText(numberFormat.format(element.credit), 'Cr:'),
          _buildText(numberFormat.format(element.balance), 'Bal:'),
        ],
      ));
    });

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16),
      child: Column(children: items),
    );
  }

  _buildText(String text, String type) {
    return Expanded(
      child: Row(
        children: [
          Text(
            type,
            textAlign: TextAlign.left,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 4, bottom: 4),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black12, width: 2.0)),
              child: Text(
                text,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
