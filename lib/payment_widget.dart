import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cooperativeapp/dio/api_base_helper.dart';
import 'package:cooperativeapp/models/payment.dart';
import 'package:cooperativeapp/util/app_dialogs.dart';
import 'package:cooperativeapp/util/local_storage.dart';
import 'package:cooperativeapp/util/my_color.dart';
import 'package:cooperativeapp/util/uitools.dart';
import 'package:cooperativeapp/util/widget_society_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'models/society.dart';

class PaymentWidget extends StatefulWidget {
  const PaymentWidget({key}) : super(key: key);

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final value = new NumberFormat("#,##0.00", "en_US");
  List<Society> societies = List.empty(growable: true);
  Society selectedSociety = new Society(name: 'Choose Society');
  List<int> yearList = List.empty(growable: true);
  bool isLoading = false, isFiltered = false;
  TextEditingController loanRepaidTEC = new TextEditingController();
  TextEditingController loanInterestTEC = new TextEditingController();
  TextEditingController sharesTEC = new TextEditingController();
  TextEditingController savingsTEC = new TextEditingController();
  TextEditingController buildingFundTEC = new TextEditingController();
  TextEditingController minuteTEC = new TextEditingController();
  MonthlyPaymentResponse? monthlyPaymentResponse;
  double loanRepaid = 0,
      interest = 0,
      shares = 0,
      savings = 0,
      buildingFund = 0,
      minute = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    societies.add(selectedSociety);
    (LocalStorage().getSocieties()).then((value) {
      setState(() {
        societies.addAll(value ?? []);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: AppText(
          'Payment',
          color: MyColor.navy,
          size: 18,
        ),
        iconTheme: const IconThemeData(color: MyColor.navy),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SocietyDropDown(
                  societies: societies,
                  selectedSociety: selectedSociety,
                  onChangeValue: (value) {
                    setState(() {
                      selectedSociety = value;
                      isLoading = true;
                    });
                    loadMonthlyPayment();
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : selectedSociety.name!.contains('Choose Society')
                        ? Center(
                            child: AppText(
                              'Please choose a society',
                              color: Colors.blue,
                            ),
                          )
                        : monthlyPaymentResponse == null
                            ? Container()
                            : _buildPaymentDetails()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadMonthlyPayment() {
    ApiBaseHelper()
        .getMonthlyPayment(selectedSociety.id.toString())
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value.success) {
        setState(() {
          monthlyPaymentResponse = value.data!;
          loanRepaid = monthlyPaymentResponse!.memberPaymentDueList!
              .where((e) => e.name!.toLowerCase().contains('repaid'))
              .first
              .minAmount!
              .toDouble();
          interest = monthlyPaymentResponse!.memberPaymentDueList!
              .where((e) => e.name!.toLowerCase().contains('interest'))
              .first
              .minAmount!
              .toDouble();
          shares = monthlyPaymentResponse!.memberPaymentDueList!
              .where((e) => e.name!.toLowerCase().contains('shares'))
              .first
              .minAmount!
              .toDouble();
          savings = monthlyPaymentResponse!.memberPaymentDueList!
              .where((e) => e.name!.toLowerCase().contains('savings'))
              .first
              .minAmount!
              .toDouble();
          buildingFund = monthlyPaymentResponse!.memberPaymentDueList!
              .where((e) => e.name!.toLowerCase().contains('building'))
              .first
              .minAmount!
              .toDouble();
          minute = monthlyPaymentResponse!.memberPaymentDueList!
              .where((e) => e.name!.toLowerCase().contains('minute'))
              .first
              .minAmount!
              .toDouble();

          loanRepaidTEC.text = loanRepaid.toString();
          loanInterestTEC.text = interest.toString();
          sharesTEC.text = shares.toString();
          savingsTEC.text = savings.toString();
          buildingFundTEC.text = buildingFund.toString();
          minuteTEC.text = minute.toString();
        });
      } else {
        AppDialogs()
            .handleErrorFromServer(value.statusCode ?? 0, value, context);
      }
    });
  }

  void savePayment() {
    List<PaymentParam> params = [];
    params.add(PaymentParam(
        amountPaid: int.parse(loanRepaidTEC.text.split('.')[0]),
        paymentTypeId: 1));
    params.add(PaymentParam(
        amountPaid: int.parse(loanInterestTEC.text.split('.')[0]),
        paymentTypeId: 2));
    params.add(PaymentParam(
        amountPaid: int.parse(sharesTEC.text.split('.')[0]), paymentTypeId: 3));
    params.add(PaymentParam(
        amountPaid: int.parse(savingsTEC.text.split('.')[0]),
        paymentTypeId: 4));
    params.add(PaymentParam(
        amountPaid: int.parse(buildingFundTEC.text.split('.')[0]),
        paymentTypeId: 5));
    params.add(PaymentParam(
        amountPaid: int.parse(minuteTEC.text.split('.')[0]), paymentTypeId: 6));
    SavePaymentParam savePaymentParam = SavePaymentParam(
        societyId: selectedSociety.id.toString(), payments: params);
    AppDialogs().onLoadingDialog(context);
    ApiBaseHelper().savePayment(savePaymentParam).then((value) {
      Navigator.pop(context);
      if (value.success) {
        showPaymentDialog(value.data!);
      } else {
        AppDialogs()
            .handleErrorFromServer(value.statusCode ?? 0, value, context);
      }
    });
  }

  void showPaymentDialog(SavePaymentResponse response) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: AppText('Payment Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextSpan(
                  text1: 'Loan Repaid: ',
                  text2: value.format(response.payments![0].amount),
                  spacing: 4,
                  alignment2: TextAlign.end,
                ),
                AppTextSpan(
                  text1: 'Loan Interest: ',
                  text2: value.format(response.payments![1].amount),
                  spacing: 4,
                  alignment2: TextAlign.end,
                ),
                AppTextSpan(
                  text1: 'Shares: ',
                  text2: value.format(response.payments![2].amount),
                  spacing: 4,
                  alignment2: TextAlign.end,
                ),
                AppTextSpan(
                  text1: 'Savings: ',
                  text2: value.format(response.payments![3].amount),
                  spacing: 4,
                  alignment2: TextAlign.end,
                ),
                AppTextSpan(
                  text1: 'Building Fund: ',
                  text2: value.format(response.payments![4].amount),
                  spacing: 4,
                  alignment2: TextAlign.end,
                ),
                AppTextSpan(
                  text1: 'Minutes: ',
                  text2: value.format(response.payments![5].amount),
                  spacing: 4,
                  alignment2: TextAlign.end,
                ),
                Divider(),
                AppTextSpan(
                  text1: 'Total: ',
                  text2: value.format(response.total),
                  alignment2: TextAlign.end,
                ),
                Divider(),
                AppTextSpan(
                  text1: 'Transaction Fee: ',
                  text2: value.format(response.amountToPay! - response.total!),
                  alignment2: TextAlign.end,
                ),
                Divider(),
                AppTextSpan(
                  text1: 'Amount to Pay: ',
                  text2: value.format(response.amountToPay),
                  alignment2: TextAlign.end,
                ),
                Divider(),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: AppText('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    makePayment(response);
                  },
                  child: AppText('Proceed')),
            ],
          );
        });
  }

  Future<void> makePayment(SavePaymentResponse savePaymentResponse) async {
    var publicKey = savePaymentResponse.payGatewayGenData?.paystackKey ?? '';
    final plugin = PaystackPlugin();
    await plugin.initialize(publicKey: publicKey);

    Charge charge = Charge()
      ..amount = (savePaymentResponse.amountToPay ?? 0) * 100
      ..reference = savePaymentResponse.payGatewayGenData?.reference
      ..accessCode = ''
      ..email = savePaymentResponse.payGatewayGenData?.email;
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );

    if (response.status == true) {
      setState(() {
        isLoading = true;
      });
      ApiBaseHelper().verifyPayment(response.reference ?? '').then((value) {
        setState(() {
          isLoading = false;
        });
        if (value.success) {
          showOkAlertDialog(
                  context: context,
                  title: 'Success',
                  message: 'Payment was successful')
              .then((value) {
            Navigator.pop(context);
          });
        } else {
          AppDialogs().showToast(
              'Error',
              'Payment verification was not successful. If you were debited, please call 09038693378 or email ictsupport@ogbomosooluwalosecicu.com to complain about this.',
              context);
        }
      });
    } else {
      AppDialogs().showToast('Payment Error', response.message, context);
    }

    // var charge = Charge()
    //   ..accessCode = accessCode
    //   ..card = _getCardFromUI();

    // final response = await plugin.chargeCard(context, charge: charge);
    // Use the response
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Payments for ${monthlyPaymentResponse!.identifier}.',
          size: 20,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 16,
        ),
        AppText('Loan Repaid (Min. of $loanRepaid)'),
        AppTextField(
          textEditingController: loanRepaidTEC,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(top: 8),
          hintText: 'Loan Repaid',
        ),
        SizedBox(
          height: 16,
        ),
        AppText('Loan Interest (Min. of $interest)'),
        AppTextField(
          enabled: false,
          textEditingController: loanInterestTEC,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(top: 8),
          hintText: 'Loan Interest',
        ),
        SizedBox(
          height: 16,
        ),
        AppText('Shares (Min. of $shares)'),
        AppTextField(
          textEditingController: sharesTEC,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(top: 8),
          hintText: 'Shares',
        ),
        SizedBox(
          height: 16,
        ),
        AppText('Savings (Min. of $savings)'),
        AppTextField(
          textEditingController: savingsTEC,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(top: 8),
          hintText: 'Savings',
        ),
        SizedBox(
          height: 16,
        ),
        AppText('Building Fund (Min. of $buildingFund)'),
        AppTextField(
          textEditingController: buildingFundTEC,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(top: 8),
          hintText: 'Building Fund',
        ),
        SizedBox(
          height: 16,
        ),
        AppText('Minute (Min. of $minute)'),
        AppTextField(
          enabled: false,
          textEditingController: minuteTEC,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(top: 8),
          hintText: 'Minute',
        ),
        SizedBox(
          height: 16,
        ),
        AppButton(
          onPressed: () {
            savePayment();
          },
          child: CurvedRectBG(
            padding: EdgeInsets.all(16),
            color: Colors.blue,
            radius: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: AppText(
                  'Save and Continue',
                  color: Colors.white,
                  alignment: TextAlign.center,
                )),
              ],
            ),
          ),
        )
      ],
    );
  }
}
