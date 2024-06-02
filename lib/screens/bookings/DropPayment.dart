// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/screens/rental/MyHomePage.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/self_drop_data.dart';

import '../../data/BookingData.dart';
import '../../utils/cred.dart';

class DropPayment extends ConsumerStatefulWidget {
  const DropPayment({Key? key}) : super(key: key);

  @override
  ConsumerState<DropPayment> createState() => _DropPaymentState();
}

class _DropPaymentState extends ConsumerState<DropPayment> {
  BookingData data = BookingFlow.selectedBooking!;
  var helmetCharge = 0;
  var _total = 0;
  var _helmetAtDrop = 1;
  final _other = TextEditingController();

  var _extended = 0;

  var _pb = false;
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    if (data.tripDetails?.noOfHelmets == '1') {
      if (SelfDropData.helmentfront == null &&
          SelfDropData.helmentleft == null) {
        helmetCharge = 500;
      }
    } else {
      if (SelfDropData.helmentfront == null) {
        helmetCharge += 500;
      } else {
        _helmetAtDrop = 1;
      }
      if (SelfDropData.helmentleft == null) {
        helmetCharge += 500;
      } else {
        _helmetAtDrop += 1;
      }
    }
    _other.text = data.tripDetails!.otherCharge == '-'
        ? "0"
        : data.tripDetails!.otherCharge.toString();
    if (DateTime.now()
            .difference(DateTime.parse(
                data.dropDate!.split(" ")[0].split('-')[2] +
                    data.dropDate!.split(" ")[0].split('-')[1] +
                    data.dropDate!.split(" ")[0].split('-')[0]))
            .inDays >
        0) {
      _extended = (DateTime.now()
              .difference(DateTime.parse(
                  data.dropDate!.split(" ")[0].split('-')[2] +
                      data.dropDate!.split(" ")[0].split('-')[1] +
                      data.dropDate!.split(" ")[0].split('-')[0]))
              .inDays *
          int.parse(data.rent!));
      _total = _extended;
    }
    _total += helmetCharge;
    _total += int.parse(SelfDropData.extraKmCharge!);

    super.initState();
  }

  final _razorpay = Razorpay();

  String order_id = "";

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _updateDataBase();
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
    var name = ref.read(userProvider)!.firstname;
    var phone = ref.read(userProvider)!.mobile;
    var email = ref.read(userProvider)!.email;
    order_id =
        '${DateFormat('ydM').format(DateTime.now())}${Random().nextInt(600000) + 200000}';
    var options = {
      'key': Cred().razorpayKey,
      'amount': '${_total}00',
      'name': 'Ridobiko Solutions Pvt. Ltd.',
      'description': 'Security deposit'
          '',
      'prefill': {'contact': phone, 'email': '$email', 'name': '$name'},
      'notes': {
        'Type': "Drop Amount",
        'merchant_order_id': order_id,
        'Amount': '$_total',
        // 'Merchant Email': '${BookingFlow.selectedBike!.vendorEmailId}',
      }
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _pb ? const CircularProgressIndicator() : null,
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
                child: const Text(
                  "PAY YOUR PAYMENTS",
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 20,
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
                      height: 10,
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
                            const Text("Additional KM charges "),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 30, left: 30),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(139, 0, 0, 1))),
                              child: Center(
                                child: Text(
                                  "₹ ${SelfDropData.extraKmCharge}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        )),
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
                            const Text("Helmet damage cost "),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 30, left: 30),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(139, 0, 0, 1))),
                              child: Center(
                                child: Text(
                                  "₹ $helmetCharge",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        )),
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
                            const Text("Vehicle damage cost "),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(139, 0, 0, 1))),
                              child: Center(
                                child: SizedBox(
                                  width: 60,
                                  height: 40,
                                  child: TextField(
                                    onSubmitted: (text) {
                                      _total += int.parse(text);
                                      setState(() {});
                                    },
                                    enabled:
                                        data.tripDetails!.otherCharge == '-',
                                    keyboardType: TextInputType.number,
                                    controller: _other,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
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
                            const Text("Extended days cost "),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 30, left: 30),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(139, 0, 0, 1))),
                              child: Center(
                                child: Text(
                                  "₹ $_extended",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        )),
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
                            const Text("Total Amount"),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 20, left: 20),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(
                                      color:
                                          const Color.fromRGBO(139, 0, 0, 1))),
                              child: Center(
                                child: Text(
                                  "Rs $_total",
                                  style: const TextStyle(
                                      color: Color.fromRGBO(139, 0, 0, 1)),
                                ),
                              ),
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_total == 0) {
                          _updateDataBase();
                          return;
                        }
                        _pay();
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelfDrop()));
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
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Proceed Self Drop",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
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

  Future<void> _updateDataBase() async {
    setState(() {
      _pb = true;
    });
    String token = ref.read(userProvider)!.token!;

    var headers = {'token': token};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${Constants().url}android_app_customer/api/setSelfDrop.php'));
    request.fields.addAll({
      'order_id': data.transId ?? "NA",
      'bike_id': data.bikesId ?? "NA",
      'no_of_helmets_drop': _helmetAtDrop.toString(),
      'KM_meter_drop': SelfDropData.kmAtDrop ?? 'NA',
      'extra_km_charge': helmetCharge.toString(),
      'km_charge_apply': '1',
      'charges_confirmed': _total.toString(),
      'id_returned': '1',
    });
    request.files.add(await http.MultipartFile.fromPath('bike_left_drop',
        SelfDropData.left == null ? "" : SelfDropData.left!.path));
    request.files.add(await http.MultipartFile.fromPath('bike_right_drop',
        SelfDropData.right == null ? "" : SelfDropData.right!.path));
    request.files.add(await http.MultipartFile.fromPath('bike_front_drop',
        SelfDropData.front == null ? "" : SelfDropData.front!.path));
    request.files.add(await http.MultipartFile.fromPath('bike_back_drop',
        SelfDropData.back == null ? "" : SelfDropData.back!.path));
    // request.files.add(await http.MultipartFile.fromPath('bike_with_customer', SelfDropData.withCustomer==null?"":SelfDropData.withCustomer!.path));
    request.files.add(await http.MultipartFile.fromPath('bike_fuel_meter_drop',
        SelfDropData.fuelMeter == null ? "" : SelfDropData.fuelMeter!.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    setState(() {
      _pb = false;
    });
    if (response.statusCode == 200) {
      var res = jsonDecode(await response.stream.bytesToString());
      if (res['success']) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const MyHomePage()),
            (route) => false);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res['message'])));
    } else {
      //print(response.reasonPhrase);
    }
  }
}
