import 'package:cooperativeapp/models/login_response.dart';
import 'package:cooperativeapp/models/member.dart';
import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/change_password_widget.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:cooperativeapp/util/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/society.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late LoginResponse loginResponse;
  late Member member;
  String name = '',
      email = '',
      phoneNo = '',
      address = '',
      passport = '',
      gender = '',
      societiesStr = '';

  @override
  void initState() {
    // TODO: implement initState
//    (LocalStorage().getLoginDetails()).then((value) =>
//        print(value.authorization.token));

    LocalStorage().getMember().then((value) {
      if (value != null) {
        initData(value);
      } else {
        () async {
          await Future.delayed(Duration.zero);
          AppDialogs().showTimeoutDialog(context);
        }();
      }
    });
    super.initState();
  }

  void initData(Member mMember) {
    setState(() {
      member = mMember;
      name = member.name ?? '';
      email = member.email ?? '';
      passport = member.passport ?? '';
      phoneNo = member.phone ?? '';
      address = member.address ?? '';
      gender = member.gender ?? "";
    });
    LocalStorage().getSocieties().then((value) => setSocieties(value ?? []));
  }

  void setSocieties(List<Society> societies) {
    String str = '';

    if (societies.isNotEmpty) {
      for (final society in societies) {
        if (society == societies.last) {
          str = str + society.name! + ".";
        } else {
          str = str + society.name! + ", ";
        }
      }
    }
    setState(() {
      societiesStr = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: MyColor.navy,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: SizedBox(
              height: 150,
              child: AppBar(
                backgroundColor: MyColor.navy,
                //shadowColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: MyColor.navy,
                    statusBarIconBrightness: Brightness.light),
                title: Text(
                  'Profile',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                automaticallyImplyLeading: false,
                actions: [
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.logout),
                          onPressed: () {
                            AppDialogs().showLogoutAlertDialog(context);
                          }),
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePasswordWidget()));
                          },
                          padding: EdgeInsets.all(0),
                          child: Text(
                            'Change\nPassword',
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 75,
            left: (MediaQuery.of(context).size.width / 2) - 70,
            child: Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 10.0,
                ),
              ),
              child: CircleAvatar(
                  radius: 70,
//                backgroundImage: NetworkImage('assets/moneyBg.jpg'),
                  backgroundColor: Colors.indigoAccent,
                  child: passport == ''
                      ? Icon(Icons.person)
                      : ClipOval(
                          child: Image.network(
                            passport,
                            height: 150,
                            width: 150,
                            scale: 1,
                            fit: BoxFit.cover,
                            errorBuilder: (context, exception, stackTrace) {
                              return ClipOval(
                                  child: Image.asset(
                                'assets/default_female_avatar.png',
                                fit: BoxFit.contain,
                              ));
                            },
                          ),
                        )),
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 220, 16, 16),
              child: buildBody(),
            ),
          ),
        ],
      ),
    );
  }

//  Widget circularImage(){
//    return CircleAvatar(
//      radius: 45,
//      child: ClipRRect(
//        borderRadius: BorderRadius.circular(45),
//        child: CachedNetworkImage(
//          imageUrl: this.strImageURL,
//          placeholder: new CircularProgressIndicator(),
//          errorWidget: new Icon(Icons.error),
//        ),
//      ),
//    );
//  }

  Widget buildBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                buildSingleLine(
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 20,
                    ),
                    TextInputType.text,
                    "Full Name",
                    name),
                buildSingleLine(
                    Icon(
                      Icons.email,
                      color: Colors.blue,
                      size: 20,
                    ),
                    TextInputType.emailAddress,
                    "Email",
                    email),
                buildSingleLine(
                    Icon(
                      Icons.phone,
                      color: Colors.blue,
                      size: 20,
                    ),
                    TextInputType.phone,
                    "Phone Number",
                    phoneNo),
                buildSingleLine(
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 20,
                    ),
                    TextInputType.phone,
                    "Gender",
                    gender),
                buildSingleLine(
                    Icon(
                      Icons.location_city,
                      color: Colors.blue,
                      size: 20,
                    ),
                    TextInputType.multiline,
                    "Residential Address",
                    address),
                buildSingleLine(
                    Icon(
                      Icons.people,
                      color: Colors.blue,
                      size: 20,
                    ),
                    TextInputType.multiline,
                    "Societies",
                    societiesStr),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSingleLine(
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
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: MyColor.navy),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey[200]),
              child: Row(
                children: [
                  icon,
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                      child: Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ))
                ],
              ),
            ),
          ],
        ));
  }

  Widget buildMultiLine(
      Icon icon, TextInputType inputType, String text, String value) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
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
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 3,
              controller: TextEditingController(text: value),
              decoration: InputDecoration(
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
}
