
// import 'package:flutter/cupertino.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DialogService {
  Future<OkCancelResult> error(
      {required String title,
      required String message,
      required BuildContext context}) {
    return showOkAlertDialog(
      context: context,
      title: title,
      message: message,
    );
  }

  Future<OkCancelResult> success(
      {required String title,
      required String message,
      required BuildContext context}) {
    return showOkAlertDialog(
      context: context,
      title: title,
      message: message,
    );
  }

  Future<OkCancelResult> ask(
      {required String title,
      required String message,
      required BuildContext context, String? okLabel, String? cancelLabel}) {
    return showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: okLabel??'Yes',
      cancelLabel: cancelLabel??'No',
    );
  }


  Future<bool> willPopCallback(BuildContext context) async {
    bool returnValue = false;
    DialogService().ask(
        title: 'Exit',
        message: 'Do you want to exit the app',
        context: context,
        okLabel: 'Yes',
        cancelLabel: 'No'
    ).then((value){
      if(value == OkCancelResult.ok){
        SystemNavigator.pop(animated: true);
      }
    }); // return true if the route to be popped
    return Future.value(returnValue);
  }


}
