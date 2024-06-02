// ignore_for_file: must_be_immutable, unused_field, unused_local_variable, file_names, prefer_final_fields, non_constant_identifier_names, use_build_context_synchronously, unused_element

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/providers/provider.dart';
import 'package:http/http.dart' as http;
import '../../../../../data/BookingData.dart';
import '../../../utils/cred.dart';

class PayRemainingWidget extends ConsumerStatefulWidget {
  BookingData bookingData;
  PayRemainingWidget(this.bookingData, {Key? key}) : super(key: key);

  @override
  ConsumerState<PayRemainingWidget> createState() => _PickupPayState();
}

class _PickupPayState extends ConsumerState<PayRemainingWidget> {
  late BookingData data;
  int _amountLeft = 0;
  final _razorpay = Razorpay();

  String order_id = "";

  var _currentBalance = 'Loaading ... Please wait';

  String _currentPaying = '';
  bool _rentPaid = false;
  bool _depositPaid = false;
  @override
  void initState() {
    data = widget.bookingData;
    _amountLeft = max(
        0,
        int.parse(data.securityDeposit!.isEmpty ? '0' : data.securityDeposit!) -
            int.parse(data.wallet_amount!.isEmpty ? '0' : data.wallet_amount!));
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_currentPaying == 'rent') {
      var headers = {
        'Authorization':
            'Basic cnpwX2xpdmVfd3dwR3pkSTJHRFdTMjk6SUkyOUQ4cEdNR0xCWVdHWm44cWdvMlBx',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://api.razorpay.com/v1/payments/${response.paymentId}/capture'));
      request.body =
          json.encode({"amount": '${data.amountLeft!}00', "currency": "INR"});
      request.headers.addAll(headers);
      http.StreamedResponse response2 = await request.send();
      _updateData(response);
      _rentPaid = true;
    } else {
      var headers = {
        'Authorization':
            'Basic cnpwX2xpdmVfd3dwR3pkSTJHRFdTMjk6SUkyOUQ4cEdNR0xCWVdHWm44cWdvMlBx',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://api.razorpay.com/v1/payments/${response.paymentId}/capture'));
      request.body =
          json.encode({"amount": '${_amountLeft}00', "currency": "INR"});
      request.headers.addAll(headers);
      http.StreamedResponse response2 = await request.send();
      _depositPaid = true;
      data.wallet_amount =
          (_amountLeft + int.parse(data.wallet_amount!)).toString();
      _updateDataDeposit(response);
    }
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

  Future<void> _pay() async {
    _currentPaying = 'rent';
    var name = ref.read(userProvider)!.firstname;
    var phone = ref.read(userProvider)!.mobile;
    var email = ref.read(userProvider)!.email;
    // order_id =
    //     '${DateFormat('ydM').format(DateTime.now())}${Random().nextInt(600000) + 200000}';
    order_id = data.transId!;

    var amt = double.tryParse(data.amountLeft!) ?? 0;
    final gstRate = ref.read(gstProvider.notifier).getGSTPercentage;

    final gstAmount = amt * gstRate / 100.0;
    var pay = amt + gstAmount;
    var payInPaisa = pay * 100;
    var payInString = payInPaisa.toStringAsFixed(2);
    if (payInString.contains('.')) {
      payInString = payInString.substring(0, payInString.indexOf('.'));
    }
    if (kDebugMode) {
      print(payInString);
    }
    var options = {
      'key': Cred().razorpayKey,
      'amount': payInString,
      'name': 'Ridobiko Solutions Pvt. Ltd.',
      'description': 'Security deposit'
          '',
      'prefill': {'contact': phone, 'email': '$email', 'name': '$name'},
      'notes': {
        // 'Type': "Remaining Amount",
        'merchant_order_id': order_id,
        'Amount': data.amountLeft!,
        'type': 3,
        'customer_mobile': phone,
        'gst': gstAmount.toStringAsFixed(2),
        // 'Merchant Email': '${BookingFlow.selectedBike!.vendorEmailId}',
      }
    };
    _razorpay.open(options);
  }

  Future<void> _payDeposit() async {
    _currentPaying = 'deposit';
    var name = ref.read(userProvider)!.firstname;
    var phone = ref.read(userProvider)!.mobile;
    var email = ref.read(userProvider)!.email;
    order_id =
        '${DateFormat('ydM').format(DateTime.now())}${Random().nextInt(600000) + 200000}';
    var options = {
      'key': Cred().razorpayKey,
      'amount': '${_amountLeft}00',
      'name': 'Ridobiko Solutions Pvt. Ltd.',
      'description': 'Security deposit'
          '',
      'prefill': {'contact': phone, 'email': '$email', 'name': '$name'},
      'notes': {
        'Type': "Security Deposit",
        'merchant_order_id': order_id,
        'Amount': data.amountLeft!,
        // 'Merchant Email': '${BookingFlow.selectedBike!.vendorEmailId}',
      }
    };
    _razorpay.open(options);
  }

  Future<void> _updateData(PaymentSuccessResponse respo) async {
    String token = ref.read(userProvider)!.token!;

    var call = await http.post(
        Uri.parse(
            '${Constants().url}android_app_customer/api/updateAmountRent.php'),
        body: {
          'order_id': order_id,
        },
        headers: {
          'token': token,
        });
    var response = jsonDecode(call.body);
    if (response['success']) {}
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${response['message']}')));
    setState(() {});
  }

  Future<void> _updateDataDeposit(PaymentSuccessResponse respo) async {
    String token = ref.read(userProvider)!.token!;

    var call = await http.post(
        Uri.parse(
            '${Constants().url}android_app_customer/api/updateAmountDeposit.php'),
        body: {
          'wallet_amount': '$_amountLeft',
          'TXN_ID': '${respo.orderId}',
        },
        headers: {
          'token': token,
        });
    var response = jsonDecode(call.body);
    if (response['success']) {
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadVehicleImg()));
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${response['message']}')));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
      margin: const EdgeInsets.only(top: 30),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Rent",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18 / scaleFactor,
              decoration: TextDecoration.underline),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: const Color.fromRGBO(139, 0, 0, 1))),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.start,
                children: [
                  Text("Total rent",
                      style: TextStyle(fontSize: 14 / scaleFactor)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 10, right: 20, left: 20),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            color: const Color.fromRGBO(139, 0, 0, 1))),
                    child: Center(
                      child: Text(data.rent!,
                          style: TextStyle(fontSize: 14 / scaleFactor)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Already paid ",
                      style: TextStyle(fontSize: 14 / scaleFactor)),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 10, right: 20, left: 20),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            color: const Color.fromRGBO(139, 0, 0, 1))),
                    child: Center(
                      child: Text(data.amountPaid!,
                          style: TextStyle(fontSize: 14 / scaleFactor)),
                    ),
                  )
                ],
              ),
              Column(
                // direction: Axis.vertical,
                // alignment:WrapAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Remaining Amount",
                      style: TextStyle(fontSize: 14 / scaleFactor)),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.only(
                              bottom: 10, top: 10, right: 20, left: 20),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color: const Color.fromRGBO(139, 0, 0, 1))),
                          child: Center(
                            child: Text('₹${data.amountLeft!}',
                                style: TextStyle(fontSize: 14 / scaleFactor)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Consumer(
                        builder: (context, ref, child) {
                          double d = ref
                              .watch(gstProvider.notifier)
                              .getGSTPercentage
                            ..toStringAsFixed(0);
                          double intAmt =
                              double.tryParse(data.amountLeft!) ?? 0;
                          double pay = d * intAmt / 100;
                          return Text(
                            '+ ₹${pay.toStringAsFixed(2)} GST',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14 / scaleFactor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (data.amountLeft != '0') {
                        await _pay();
                      }
                      Navigator.pop(context);
                    },
                    onLongPress: () {},
                    child: Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(
                          bottom: 10, top: 10, right: 20, left: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: data.amountLeft == '0' || _rentPaid
                                  ? [Colors.grey, Colors.grey]
                                  : [
                                      const Color.fromRGBO(139, 0, 0, 1),
                                      Colors.red[200]!
                                    ])),
                      child: Center(
                        child: Builder(builder: (context) {
                          double d = ref
                              .watch(gstProvider.notifier)
                              .getGSTPercentage
                            ..toStringAsFixed(0);
                          double intAmt =
                              double.tryParse(data.amountLeft!) ?? 0;
                          double pay = (1 + d / 100) * intAmt;
                          return Text(
                            data.amountLeft == '0' || _rentPaid
                                ? 'Done'
                                : "Pay ₹${pay.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 14 / scaleFactor,
                                color: Colors.white),
                          );
                        }),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const Spacer()
      ]),
    );
  }
}
