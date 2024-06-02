// ignore_for_file: prefer_typing_uninitialized_variables, file_names, unused_field, non_constant_identifier_names, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:ridobiko/providers/provider.dart';

class SubLedger extends StatefulWidget {
  final Subscription subscription;
  final VoidCallback onPay;
  final helmetCharge;
  final latePayCharge;
  const SubLedger(this.subscription, this.onPay,
      {Key? key, this.helmetCharge, this.latePayCharge})
      : super(key: key);

  @override
  State<SubLedger> createState() => _SubLedgerState();
}

class _SubLedgerState extends State<SubLedger> {
  var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  bool _ledgerVisible = false;
  void showledger() {
    setState(() {
      _ledgerVisible = !_ledgerVisible;
    });
  }

  String _currentPaying = 'Rent';
  final _razorpay = Razorpay();
  var order_id = '';

  var _payingAmount = 0;
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // _updateData(response);

    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Success')));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Failed')));

    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Extenalwallet')));

    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: widget.subscription.amountLeft == '0'
                ? const Icon(
                    Icons.stop_circle_outlined,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.stop_circle_outlined,
                    color: Colors.red,
                  ),
            title: Text(
              " ${months[int.parse(widget.subscription.pickupDate!.split('-')[1]) - 1]} ${widget.subscription.pickupDate!.split(' ')[0].split('-')[0]}",
              style: TextStyle(fontSize: 14 / scaleFactor),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: () {
              showledger();
            },
          ),
          const Divider(
            thickness: 0.5,
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: _ledgerVisible,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rent",
                      style: TextStyle(fontSize: 14 / scaleFactor),
                    ),
                    Text(
                      "Rs.${widget.subscription.rent}",
                      style: TextStyle(fontSize: 14 / scaleFactor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pickup Date",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                    Text("${widget.subscription.pickupDate}",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Drop Date",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                    Text("${widget.subscription.dropDate}",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Amount Paid",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                    Text("Rs.${widget.subscription.amountPaid}",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Helmet charges",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                    Text("Rs.${widget.helmetCharge}",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Late pay charge",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                    Text("Rs.${widget.latePayCharge}",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Amount Left",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                    Text("Rs.${widget.subscription.amountLeft}",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("GST", style: TextStyle(fontSize: 14 / scaleFactor)),
                    Consumer(builder: (context, ref, child) {
                      final gst =
                          ref.watch(gstProvider.notifier).getGSTPercentage;
                      double rent = (gst / 100) *
                          (double.tryParse(widget.subscription.amountLeft!) ??
                              0);
                      return Text("Rs.${rent.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 14 / scaleFactor));
                    }),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: widget.onPay,
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: widget.subscription.amountLeft == '0'
                                  ? [Colors.grey, Colors.grey]
                                  : [
                                      const Color.fromRGBO(139, 0, 0, 1),
                                      Colors.red[200]!
                                    ])),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer(builder: (context, ref, child) {
                              final gst = ref
                                  .watch(gstProvider.notifier)
                                  .getGSTPercentage;
                              double rent = (1 + gst / 100) *
                                  (double.tryParse(
                                          widget.subscription.amountLeft!) ??
                                      0);
                              return Text(
                                widget.subscription.amountLeft == '0'
                                    ? "PAID"
                                    : "PAY ₹${rent.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14 / scaleFactor),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _pay() async {
  //   _currentPaying='rent';
  //   var prefs=await SharedPreferences.getInstance();
  //   var name=prefs.getString('firstname');
  //   var phone=prefs.getString('mobile');
  //   var email=prefs.getString('email');
  //   var options = {
  //     'key': Cred().razorpayKey,
  //     'amount': '${_payingAmount}00',
  //     'name': 'Ridobiko Solutions Pvt. Ltd.',
  //     'description': 'Security deposit'
  //         '',
  //     'prefill': {
  //       'contact': phone,
  //       'email': '$email',
  //       'name': '$name'
  //     },
  //     'notes': {
  //       'Type': "Remaining Amount",
  //       'merchant_order_id': '$order_id',
  //       'Amount': '${_payingAmount}',
  //       // 'Merchant Email': '${BookingFlow.selectedBike!.vendorEmailId}',
  //     }
  //   };
  //   _razorpay.open(options);
  // }
  // Future<void> _updateData(PaymentSuccessResponse respo) async {
  //   var prefs=await SharedPreferences.getInstance();
  //   var token= prefs.getString('token')??"";
  //   var call=await http.post(Uri.parse('https://www.ridobiko.com/android_app_customer/api/updateAmountRent.php')
  //       ,body: {
  //         'order_id': '$order_id',
  //       },headers: {
  //         'token': token,
  //       }
  //   );
  //   var response =jsonDecode(call.body);
  //   if(response['success']){
  //
  //   }
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response['message']}')));
  // }
}
