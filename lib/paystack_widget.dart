import 'package:cooperativeapp/util/uitools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_paystack/flutter_paystack.dart';


class PaystackWidget extends StatefulWidget {
  final double amount;
  const PaystackWidget({Key? key, required this.amount}) : super(key: key);

  @override
  State<PaystackWidget> createState() => _PaystackWidgetState();
}

class _PaystackWidgetState extends State<PaystackWidget> {
  var publicKey = '[YOUR_PAYSTACK_PUBLIC_KEY]';
  // final plugin = PaystackPlugin.platformInfo.;
  final plugin = PaystackPlugin();
  final numberFormat = new NumberFormat("#,##0.00", "en_US");
  bool loading = false;


  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText('Your card will be charged:', size: 12),
                AppText('₦${numberFormat.format(widget.amount)}', size: 24, fontWeight: FontWeight.bold,),
                Divider(height: 24,),
                AppText(
                  'Enter card details to pay:', fontWeight: FontWeight.bold,),
                SizedBox(height: 8,),
                AppTextField(
                    hintText: 'Card Number',
                    title: 'Card Number',
                    textInputType: TextInputType.number,
                    autoFocus: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                      FilteringTextInputFormatter.digitsOnly
                    ]
                ),
                SizedBox(height: 8,),
                AppTextField(
                    hintText: 'CVV',
                    title: 'CVV',
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly
                    ]
                ),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                          hintText: 'Expiry Month',
                          title: 'Expiry Month',
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                            FilteringTextInputFormatter.digitsOnly
                          ]
                      ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: AppTextField(
                          hintText: 'Expiry Year',
                          title: 'Expiry Year',
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                            FilteringTextInputFormatter.digitsOnly
                          ]
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    radius: 8,
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        loading = !loading;
                      });
                    },
                    padding: EdgeInsets.all(16),
                    child: loading?SizedBox(
                      width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)
                    ):
                    AppText(
                      'Pay', alignment: TextAlign.center, color: Colors.white,),
                  ),
                )
              ],
            ),
          ),
      );
  }





}
