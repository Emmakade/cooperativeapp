import 'package:cooperativeapp/loan_history_widget.dart';
import 'package:cooperativeapp/payment_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:cooperativeapp/util/my_color.dart';
import 'package:flutter/services.dart';

class HistoryWidget extends StatefulWidget {
  @override
  _RequestsWidgetState createState() => _RequestsWidgetState();
}

class _RequestsWidgetState extends State<HistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark),
            title: Text('History',
                style: TextStyle(
                    fontSize: 18,
                    color: MyColor.navy,
                    fontWeight: FontWeight.bold)),
            automaticallyImplyLeading: false,
            bottom: TabBar(
              //  indicator: BoxDecoration(
              //    color: Colors.lightBlueAccent
              //  ),
              indicatorColor: MyColor.navy,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: 16),
              labelColor: MyColor.navy,
              tabs: <Widget>[
                Tab(text: 'Passbook'),
                Tab(text: 'Loans'),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              PaymentHistoryWidget(),
              //              LoanHistoryWidget(),
              LoanHistoryWidget(),
            ],
          ),
        ));
  }
}
