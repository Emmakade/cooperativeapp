import 'package:cooperativeapp/dio/api_base_helper.dart';
import 'package:cooperativeapp/params/change_password_param.dart';
import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangePasswordWidget extends StatefulWidget {
  @override
  _ChangePasswordWidgetState createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  bool oldVisible = false, newVisible = false, confirmNewVisible = false;
  String oldPwdErrorText = '', newPwdErrorText = '', confirmPwdErrorText = '';
  TextEditingController oldPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmNewPwdController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
//    (LocalStorage().getLoginDetails()).then((value) =>
//        setUserId(value)
//    );
    oldVisible = false;
    newVisible = false;
    confirmNewVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Theme.of(context).primaryColor,
    //     statusBarBrightness: Brightness.light,
    //     statusBarIconBrightness: Brightness.light,
    //     systemNavigationBarColor: Colors.black,
    //     systemNavigationBarIconBrightness: Brightness.light));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark),
          iconTheme: const IconThemeData(color: MyColor.navy),
          title: Text(
            'Change Password',
            style: TextStyle(color: MyColor.navy, fontSize: 18),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                buildPasswordField(
                    null,
                    TextInputType.text,
                    'Old Password',
                    oldPwdErrorText,
                    oldPwdController,
                    oldVisible,
                    IconButton(
                      icon: oldVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          oldVisible = !oldVisible;
                        });
                      },
                    )),
                buildPasswordField(
                    null,
                    TextInputType.text,
                    'New Password',
                    newPwdErrorText,
                    newPwdController,
                    newVisible,
                    IconButton(
                      icon: newVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          newVisible = !newVisible;
                        });
                      },
                    )),
                buildPasswordField(
                    null,
                    TextInputType.text,
                    'Confirm New Password',
                    confirmPwdErrorText,
                    confirmNewPwdController,
                    confirmNewVisible,
                    IconButton(
                      icon: confirmNewVisible
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          confirmNewVisible = !confirmNewVisible;
                        });
                      },
                    )),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.blue,
                              elevation: 0),
                          onPressed: () {
                            changePassword();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 0),
                            child: Text(
                              'Change Password',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )));
  }

  void changePassword() {
    setState(() {
      oldPwdErrorText = '';
      newPwdErrorText = '';
      confirmPwdErrorText = '';
    });
    if (oldPwdController.text.isEmpty ||
        newPwdController.text.isEmpty ||
        confirmNewPwdController.text.isEmpty) {
      if (oldPwdController.text.isEmpty) {
        setState(() {
          oldPwdErrorText = 'This field cannot be empty';
        });
      } else if (newPwdController.text.isEmpty) {
        setState(() {
          newPwdErrorText = 'This field cannot be empty';
        });
      } else if (confirmNewPwdController.text.isEmpty) {
        setState(() {
          confirmPwdErrorText = 'This field cannot be empty';
        });
      }
    } else if (newPwdController.text != confirmNewPwdController.text) {
      AppDialogs().showToast('Error', 'New password does not match', context);
    } else {
      AppDialogs().onLoadingDialog(context);
      ChangePasswordParam param = new ChangePasswordParam();
      param.oldPsd = oldPwdController.text;
      param.newPsd = newPwdController.text;
      param.cfmPsd = confirmNewPwdController.text;
      (ApiBaseHelper().changePassword(param)).then((value) async {
        Navigator.pop(context);
        () async {
          await Future.delayed(Duration.zero);
          if (value.success) {
            clearScreen();
            AppDialogs().showToast('Success', value.msg ?? '', context);
          } else {
            AppDialogs()
                .handleErrorFromServer(value.statusCode ?? 0, value, context);
          }
        }();
      });
    }
  }

  void clearScreen() {
    setState(() {
      oldPwdController.text = '';
      newPwdController.text = '';
      confirmNewPwdController.text = '';
    });
  }

  Widget buildPasswordField(
      Icon? icon,
      TextInputType inputType,
      String text,
      String errorText,
      TextEditingController controller,
      bool visible,
      IconButton iconButton) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            TextFormField(
//              validator: (String value) {
//                if (value.trim().isEmpty) {
//                  return 'Password is required';
//                }
//              },
              obscureText: !visible,
              controller: controller,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: iconButton,
                  prefixIcon: icon,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  errorText: errorText,
                  fillColor: Colors.grey[200],
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ));
  }
}
