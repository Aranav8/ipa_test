// ignore_for_file: unused_local_variable, file_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/screens/bookings/UploadVehicleImg.dart';
import 'package:http/http.dart' as http;
import '../../data/BookingData.dart';
import '../../data/BookingFlow.dart';
import '../../utils/cred.dart';

class PickupPay extends ConsumerStatefulWidget {
  const PickupPay({Key? key}) : super(key: key);

  @override
  ConsumerState<PickupPay> createState() => _PickupPayState();
}

class _PickupPayState extends ConsumerState<PickupPay> {
  late BookingData data;
  int _amountLeft = 0;
  final _razorpay = Razorpay();

  String order_id = "";

  String _currentPaying = '';
  bool _rentPaid = false;
  bool _depositPaid = false;
  @override
  void initState() {
    data = BookingFlow.selectedBooking!;
    _amountLeft = max(
        0, int.parse(data.securityDeposit!) - int.parse(data.wallet_amount!));
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
    order_id =
        '${DateFormat('ydM').format(DateTime.now())}${Random().nextInt(600000) + 200000}';
    var options = {
      'key': Cred().razorpayKey,
      'amount': '${data.amountLeft!}00',
      'name': 'Ridobiko Solutions Pvt. Ltd.',
      'description': 'Security deposit'
          '',
      'prefill': {'contact': phone, 'email': '$email', 'name': '$name'},
      'notes': {
        'Type': "Remaining Amount",
        'merchant_order_id': order_id,
        'Amount': data.amountLeft!,
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
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
          child: Container(
        color: const Color.fromRGBO(139, 0, 0, 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 1))),
                child: Text(
                  "PAY YOUR PAYMENTS",
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 20 / scaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: const Color.fromRGBO(139, 0, 0, 1))),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.start,
                            children: [
                              Text(
                                "Total rent",
                                style: TextStyle(fontSize: 14 / scaleFactor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 10, top: 10, right: 20, left: 20),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            139, 0, 0, 1))),
                                child: Center(
                                  child: Text(
                                    data.rent!,
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Already paid ",
                                style: TextStyle(fontSize: 14 / scaleFactor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.only(
                                    bottom: 10, top: 10, right: 20, left: 20),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            139, 0, 0, 1))),
                                child: Center(
                                  child: Text(
                                    data.amountPaid!,
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            // direction: Axis.vertical,
                            // alignment:WrapAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Remaining Amount",
                                style: TextStyle(fontSize: 14 / scaleFactor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 10, right: 20, left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              139, 0, 0, 1))),
                                  child: Center(
                                    child: Text(
                                      data.amountLeft!,
                                      style:
                                          TextStyle(fontSize: 14 / scaleFactor),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (data.amountLeft != '0') _pay();
                                },
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
                                          colors: data.amountLeft == '0' ||
                                                  _rentPaid
                                              ? [Colors.grey, Colors.grey]
                                              : [
                                                  const Color.fromRGBO(
                                                      139, 0, 0, 1),
                                                  Colors.red[200]!
                                                ])),
                                  child: Center(
                                    child: Text(
                                      data.amountLeft == '0' || _rentPaid
                                          ? 'Done'
                                          : "Pay remaining amount",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14 / scaleFactor),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Security Deposit",
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: const Color.fromRGBO(139, 0, 0, 1))),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.start,
                            children: [
                              Text(
                                "Applicable deposit",
                                style: TextStyle(fontSize: 14 / scaleFactor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    bottom: 10, top: 10, right: 20, left: 20),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            139, 0, 0, 1))),
                                child: Center(
                                  child: Text(
                                    data.securityDeposit!,
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                " Additional amount ",
                                style: TextStyle(fontSize: 14 / scaleFactor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.only(
                                    bottom: 10, top: 10, right: 20, left: 20),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            139, 0, 0, 1))),
                                child: Center(
                                  child: Text(
                                    '$_amountLeft',
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            // direction: Axis.vertical,
                            // alignment:WrapAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "In wallet",
                                style: TextStyle(fontSize: 14 / scaleFactor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 10, right: 20, left: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              139, 0, 0, 1))),
                                  child: Center(
                                    child: Text(
                                      data.wallet_amount!,
                                      style:
                                          TextStyle(fontSize: 14 / scaleFactor),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_amountLeft != 0) _payDeposit();
                                },
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
                                          colors:
                                              _amountLeft == 0 || _depositPaid
                                                  ? [Colors.grey, Colors.grey]
                                                  : [
                                                      const Color.fromRGBO(
                                                          139, 0, 0, 1),
                                                      Colors.red[200]!
                                                    ])),
                                  child: Center(
                                    child: Text(
                                      _amountLeft == 0 || _depositPaid
                                          ? 'Done'
                                          : "Pay additional amount",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14 / scaleFactor),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if ((_rentPaid && _depositPaid) ||
                            (data.amountLeft == '0' && _amountLeft == 0) ||
                            (_rentPaid && _amountLeft == 0) ||
                            (data.amountLeft == '0' && _depositPaid)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UploadVehicleImg()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'Pay all dues first',
                            style: TextStyle(fontSize: 14 / scaleFactor),
                          )));
                        }
                      },
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
                                  colors: [
                                    const Color.fromRGBO(139, 0, 0, 1),
                                    Colors.red[200]!
                                  ])),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Save & Continue",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15 / scaleFactor),
                                ),
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
        ),
      )),
    );
  }
}
