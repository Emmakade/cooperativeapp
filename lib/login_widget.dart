import 'package:cooperativeapp/dio/api_base_helper.dart';
import 'package:cooperativeapp/params/auth_param.dart';
import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:cooperativeapp/util/widget_stacked_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/base_response.dart';
import 'models/login_response.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _passwordVisible = false;
  ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    (LocalStorage().getLoginDetails()).then((value) => setUserId(value));
    _passwordVisible = false;
    super.initState();
  }

  void setUserId(LoginResponse? res) {
//    print(jsonEncode(res.toJson().toString()));
    userIdController.text = res?.user?.userid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white.withOpacity(0.1),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    double myheight = MediaQuery.of(context).size.height;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return WillPopScope(
      onWillPop: () async => true,
      child: Builder(builder: (context) {
        return Scaffold(
          body: Builder(builder: (context) {
            return Container(
              height: myheight,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                image: DecorationImage(
                    image: AssetImage("assets/moneyBg.jpg"),
                    opacity: 0.1,
                    fit: BoxFit.cover),
              ),
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: myheight * 0.15,
                      ),
                      if (!isKeyboard) buildLogo(),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 300,
                        margin: EdgeInsets.all(24),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildEmailField(Icon(Icons.person),
                                TextInputType.text, "UserID", ""),
                            buildPasswordField(Icon(Icons.vpn_key),
                                TextInputType.visiblePassword, "Password", ""),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor:
                                            Colors.blue.withOpacity(0.7),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        AppDialogs().onLoadingDialog(context);
                                        (_apiBaseHelper.loginUser(AuthParam(
                                                userid:
                                                    userIdController.value.text,
                                                password: passwordController
                                                    .value.text)))
                                            .then((value) =>
                                                proceedLogin(context, value));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text('Login',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Text(
                        'Ogbomoso Oluwalose Cooperative\nInvestment and Credit Union Limited',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '- Cooperation Leads to Progress -',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  void proceedLogin(BuildContext context, SingleResponse<LoginResponse>? res) {
    Navigator.pop(context);
    if (res?.success ?? false) {
      LocalStorage().saveLoginDetails(res!.data!);
      LocalStorage().saveAuthorization(res.data!.authorization!);
      LocalStorage().saveIsFresh(true);
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      AppDialogs().handleErrorFromServer(res?.statusCode ?? 0, res!, context);
    }
  }

  Widget buildEmailField(
      Icon icon, TextInputType inputType, String text, String value) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
            TextField(
              controller: userIdController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: icon,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ));
  }

  Widget buildPasswordField(
      Icon icon, TextInputType inputType, String text, String value) {
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
              obscureText: !_passwordVisible,
              controller: passwordController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: IconButton(
                    icon: _passwordVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  prefixIcon: icon,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ));
  }

  Widget buildLogo() {
    return ClipOval(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: CircleAvatar(
            radius: 70,
            child: Image.asset(
              'assets/icon.PNG',
              height: 145,
              width: 250,
            )),
      ),
    );
  }
}
