import 'package:cooperativeapp/dio/api_base_helper.dart';
import 'package:cooperativeapp/models/member.dart';
import 'package:cooperativeapp/models/society_members.dart';
import 'package:cooperativeapp/params/loan_request_param.dart';
import 'package:cooperativeapp/select_guarantor_listview.dart';
import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:cooperativeapp/util/my_color.dart';
import 'package:cooperativeapp/util/widget_society_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/society.dart';

class RequestLoanWidget extends StatefulWidget {
  @override
  _RequestLoanWidgetState createState() => _RequestLoanWidgetState();
}

class _RequestLoanWidgetState extends State<RequestLoanWidget> {
  List<Society> societies = List.empty(growable: true);
  Society selectedSociety = new Society(name: 'Choose Society');
  List<Member> selectedGuarantors = List.empty(growable: true);
  List<Member> guarantors = List.empty(growable: true);
  double amount = 0.0;
  String purpose = '', amountErrorText = '', purposeErrorText = '';
  TextEditingController amountController = new TextEditingController(),
      purposeController = new TextEditingController();
  late BuildContext sContext;

  @override
  void initState() {
    // TODO: implement initState
    societies.add(selectedSociety);
    (LocalStorage().getSocieties()).then((value) {
      setState(() {
        societies.addAll(value ?? []);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Loan Request',
          style: TextStyle(color: MyColor.navy, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: MyColor.navy),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(
                    'Request for a loan here',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SocietyDropDown(
                        onChangeValue: (newValue) {
                          setState(() {
                            selectedSociety = newValue;
                          });
                          if (selectedSociety.name == 'Choose Society') return;
                          AppDialogs().onLoadingDialog(context);
                          (ApiBaseHelper().getSocietyMembers(
                                  selectedSociety.id.toString()))
                              .then((value) {
                            if (value.success) {
                              List<int> ids = List.empty(growable: true);
                              for (SocietyMember s in value.data ?? []) {
                                ids.add(int.parse(s.memberId ?? ''));
                              }
                              (ApiBaseHelper().getManyMembers(ids))
                                  .then((value) {
                                if (value.success) {
                                  setState(() {
                                    guarantors.addAll(value.data ?? []);
                                  });
                                }
                              });
                            }
                            Navigator.pop(context);
                          });
                        },
                        selectedSociety: selectedSociety,
                        societies: societies,
                      ),
                    ),
                  ],
                ),
                buildSingleLine(
                    null, TextInputType.number, 'Amount', amountController),
                buildMultiLine(null, TextInputType.text, 'Purpose of Request',
                    purposeController),
                buildActivityItem('Select Guarantors', Colors.blue),
                Wrap(
                  spacing: 8,
                  runSpacing: -7,
                  children: _buildChipWrap(selectedGuarantors),
                ),
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
                            elevation: 0,
                          ),
                          onPressed: () {
                            requestLoan();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 0),
                            child: Text(
                              'Send Request',
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
        ),
      ),
    );
  }

  Widget buildSingleLine(Icon? icon, TextInputType inputType, String text,
      TextEditingController controller) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 12),
                  prefixText: '\u20A6 ',
                  prefixIcon: icon,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  errorText: amountErrorText,
                  fillColor: Colors.grey[200],
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ));
  }

  Widget buildMultiLine(Icon? icon, TextInputType inputType, String text,
      TextEditingController controller) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 4,
              controller: controller,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
                  prefixIcon: icon,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  errorText: purposeErrorText,
                  fillColor: Colors.grey[200],
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ));
  }

  Widget buildInputChip(Member guarantor) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: InputChip(
        avatar: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.indigoAccent,
            child: guarantor.passport == ''
                ? Icon(Icons.person)
                : ClipOval(
                    child: Image.network(
                      guarantor.passport ?? '',
                      height: 32,
                      width: 32,
                      scale: 1,
                      fit: BoxFit.cover,
                      errorBuilder: (context, exception, stackTrace) {
                        return ClipOval(
                            child: Image.asset(
                          'assets/default_female_avatar.png',
                          fit: BoxFit.cover,
                        ));
                      },
                    ),
                  )),
        label: Text(guarantor.name ?? ''),
        selected: false,
        selectedColor: Colors.red,
        onDeleted: () {
          setState(() {
            selectedGuarantors.remove(guarantor);
          });
        },
      ),
    );
  }

  Widget buildActivityItem(String text, Color color) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              ),
              onPressed: () async {
                if (selectedSociety.name == 'Choose Society')
                  AppDialogs().showToast(
                      'Error', 'Please Select Society First', context);
                else {
                  List<Member> selectedList = await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => _modalBottomSheet(),
                  );
                  if (selectedList.isEmpty) return;
                  selectedGuarantors.clear();
                  setState(() {
                    selectedGuarantors.addAll(selectedList);
                  });
                }
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      text.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_up, color: color)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modalBottomSheet() {
    return Wrap(
      children: <Widget>[
        Container(
            color: Color(0xFF737373),
            //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 24),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0))),
                child: GuarantorsListView(guarantors)))
      ],
    );
  }

  _buildChipWrap(List<Member> guarantors) {
    List<Widget> list = [];
    guarantors.forEach((guarantor) {
      list.add(buildInputChip(guarantor));
    });
    return list;
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  bool _isNumeric(String result) {
    if (result.isEmpty) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  void requestLoan() {
    setState(() {
      amountErrorText = '';
      purposeErrorText = '';
    });
    if (amountController.text.isEmpty ||
        purposeController.text.isEmpty ||
        !_isNumeric(amountController.text) ||
        selectedGuarantors.length != 4) {
      if (amountController.text.isEmpty) {
        setState(() {
          amountErrorText = 'Amount field cannot be empty or 0.0';
        });
      } else if (!_isNumeric(amountController.text)) {
        setState(() {
          amountErrorText = 'Amount must be a number or decimal value';
        });
      } else if (purposeController.text.isEmpty) {
        setState(() {
          purposeErrorText = 'Purpose field cannot be empty';
        });
      } else {
        AppDialogs().showToast(
            'Error', 'Please Select Exactly 4 Guarantors to Proceed', context);
      }
    } else {
      AppDialogs().onLoadingDialog(context);
      LoanRequestParam param = new LoanRequestParam();
      param.societyId = selectedSociety.id!;
      param.amountRequested = double.parse(amountController.text);
      param.purpose = purposeController.text;
      List<int> ids = List.empty(growable: true);
      if (selectedGuarantors.isNotEmpty) {
        selectedGuarantors.forEach((e) {
          ids.add(e.id!);
        });
      }
      param.guarantorIds = ids;
      (ApiBaseHelper().saveLoan(param)).then((value) async {
        // print('RESULT NOW:    ' + value.msg??'');
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
      purposeController.text = '';
      amountController.text = '';
      selectedGuarantors.clear();
      //selectedSociety = new Society(name: 'Choose Society');
    });
  }
}
