import 'dart:async';

import 'package:cooperativeapp/models/base_response.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  void onLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        //var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: width - 215),
          child: Container(
            padding: EdgeInsets.all(16),
            child: new CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void showToast(String title, String msg, BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLogoutAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/login');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Do you wish to logout this account?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  handleErrorFromServer(int code, BaseResponse response, BuildContext context) {
    if (code == 403) {
      AppDialogs().showTimeoutDialog(context);
    } else {
      AppDialogs().showToast('Error', response.msg ?? '', context);
    }
  }

  showTimeoutDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        title: Text("Session Timeout"), content: TimeoutDialogContent());

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class TimeoutDialogContent extends StatefulWidget {
  @override
  _TimeoutDialogContentState createState() => _TimeoutDialogContentState();
}

class _TimeoutDialogContentState extends State<TimeoutDialogContent> {
  int timeSecs = 0;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: RichText(
                text: TextSpan(
                    text:
                        'Sorry, your current session is up, and for security reasons, you have to re-login in ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                  TextSpan(
                      text: _start.toString() + ' seconds\n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ])),
          ),
        ],
      ),
    );
  }

  late Timer _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
