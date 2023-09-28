import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cooperativeapp/dialog_service.dart';
import 'package:cooperativeapp/guarantor_request.dart';
import 'package:cooperativeapp/history_widget.dart';
import 'package:cooperativeapp/profile_widget.dart';
import 'package:cooperativeapp/util/my_color.dart';
import 'package:flutter/material.dart';
import 'package:cooperativeapp/dashboard_widget.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //String _title = "Dashboard";
  int _currentIndex = 0;
  final screens = [
    DashboardWidget(),
    GuarantorRequestWidget(),
    HistoryWidget(),
    ProfileWidget()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPopCallback(context),
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (value) => setState(
              () => _currentIndex = value,
            ),
            elevation: 20,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.black26,
            unselectedLabelStyle: TextStyle(color: Colors.black38),
            selectedItemColor: Colors.blue,
            selectedIconTheme: IconThemeData(color: Colors.blue),
            unselectedIconTheme: IconThemeData(color: Colors.black38),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  label: 'Dashboard',
                  icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  label: 'Requests', icon: Icon(Icons.receipt)),
              BottomNavigationBarItem(
                  label: 'History', icon: Icon(Icons.history)),
              BottomNavigationBarItem(
                  label: 'Profile', icon: Icon(Icons.person)),
            ],
          ),
        ),
//          body: SafeArea(child: _children[_currentIndex]) // This trailing comma makes auto-formatting nicer for build methods.
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Future<bool> willPopCallback(BuildContext context) async {
    bool returnValue = false;
    DialogService()
        .ask(
            title: 'Exit',
            message: 'Do you want to exit the app',
            context: context,
            okLabel: 'Yes',
            cancelLabel: 'No')
        .then((value) {
      if (value == OkCancelResult.ok) {
        SystemNavigator.pop(animated: true);
      }
    }); // return true if the route to be popped
    return Future.value(returnValue);
  }
}
