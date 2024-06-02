// ignore_for_file: must_be_immutable, file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously, duplicate_ignore

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridobiko/screens/bookings/MoreDetails.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/controllers/bookings/booking_controller.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:http/http.dart' as http;
import 'package:ridobiko/providers/provider.dart';

import 'widgets/payRemaining.dart';
import '../../utils/cred.dart';
import 'widgets/Ledger.dart';

typedef FutureCallback = Future<void> Function();

class CompletedTb extends ConsumerStatefulWidget {
  List<BookingData> trips;
  FutureCallback getData;
  bool dataAvailable;
  CompletedTb(this.dataAvailable, this.trips, this.getData, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ongoing();
  }
}

// ignore: camel_case_types
class ongoing extends ConsumerState<CompletedTb> {
  var _view = false;
  var _popup;
  String _currentPaying = 'Rent';
  final _razorpay = Razorpay();
  var order_id = '';

  var _payingAmount = 0;
  BookingData? _selectedToExtend;

  var _selectedEndTime = DateTime.now();

  var _selectedEndDate = DateTime.now().add(const Duration(days: 1));

  int _calculatedRent = 0;

  var _pb = false;

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
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
        json.encode({"amount": '${_payingAmount}00', "currency": "INR"});
    request.headers.addAll(headers);
    // ignore: unused_local_variable
    http.StreamedResponse response2 = await request.send();
    if (_currentPaying == 'extend') {
      _createExtendTrip(response);
    } else {
      _updateData(response);
    }
    _getData();
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

  Future<void> _getData() async {
    widget.trips = [];
    final response =
        await ref.read(bookingControllerProvider.notifier).getData(context);

    widget.trips = response[1];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
        floatingActionButton: _pb ? const CircularProgressIndicator() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () {
                return _getData();
              },
              child: ListView.builder(
                  itemCount: widget.trips.length,
                  itemBuilder: (bcontext, pos) {
                    var data = widget.trips[pos];
                    return data.subscription != null &&
                            data.subscription![0].orderId != null
                        ? Container(
                            margin: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                                child: GestureDetector(
                              onTap: () {
                                BookingFlow.selectedBooking = data;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MoreDetails()));
                              },
                              child: Container(
                                // height: 200,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            139, 0, 0, 1))),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        data.transId!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15 / scaleFactor,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Expanded(
                                          child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Text(
                                          data.adminStatus!.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 14 / scaleFactor,
                                              color: data.adminStatus!
                                                          .toLowerCase() ==
                                                      'pending'
                                                  ? Colors.yellow[800]
                                                  : data.adminStatus!
                                                              .toLowerCase() ==
                                                          'confirmed'
                                                      ? Colors.green
                                                      : Colors.redAccent),
                                        ),
                                      ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .do_not_disturb_on_total_silence_sharp,
                                                  color: Colors.redAccent,
                                                ),
                                                Text(data.pickupDate!,
                                                    style: TextStyle(
                                                        fontSize:
                                                            14 / scaleFactor))
                                              ],
                                            ),
                                            Text(
                                              "Pickup Date & Time",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14 / scaleFactor),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .do_not_disturb_on_total_silence_sharp,
                                                  color: Colors.green,
                                                ),
                                                Text(data.dropDate!,
                                                    style: TextStyle(
                                                        fontSize:
                                                            14 / scaleFactor))
                                              ],
                                            ),
                                            Text(
                                              "Drop Date & Time",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14 / scaleFactor),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: CachedNetworkImage(
                                                  imageUrl: data.bikeImage!,
                                                  errorWidget: (a, b, c) =>
                                                      Image.network(
                                                    'https://www.ridobiko.com/images/default.png',
                                                    height: 80,
                                                  ),
                                                  fit: BoxFit.contain,
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              data.bikeName!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15 / scaleFactor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ]),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Divider(
                                    thickness: 0.5,
                                    color: Colors.grey,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          _view = !_view;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          _view
                                              ? const Icon(
                                                  Icons.arrow_downward,
                                                  color: Color.fromRGBO(
                                                      139, 0, 0, 1),
                                                )
                                              : const Icon(
                                                  Icons.arrow_forward,
                                                  color: Color.fromRGBO(
                                                      139, 0, 0, 1),
                                                ),
                                          const SizedBox(height: 20),
                                          Text(
                                            "  View Payment Details",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14 / scaleFactor),
                                          )
                                        ],
                                      )),
                                  Visibility(
                                    visible: _view,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          margin: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Color.fromRGBO(
                                                          139, 0, 0, 1),
                                                      width: 1))),
                                          child: Text(
                                            "PAYMENT LEDGER",
                                            style: TextStyle(
                                                fontSize: 14 / scaleFactor,
                                                color: const Color.fromRGBO(
                                                    139, 0, 0, 1)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 280,
                                          child: ListView.builder(
                                              itemCount:
                                                  data.subscription!.length,
                                              itemBuilder: (context, pos) {
                                                return SubLedger(
                                                    data.subscription![pos],
                                                    () {
                                                  if (data.subscription![pos]
                                                          .amountLeft !=
                                                      '0') {
                                                    _currentPaying = 'rent';
                                                    _payingAmount = int.parse(
                                                        data.subscription![pos]
                                                            .amountLeft!);
                                                    order_id = data
                                                        .subscription![pos]
                                                        .orderId!;
                                                    _pay();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Already Paid')));
                                                  }
                                                });
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            )))
                        : Container(
                            margin: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                                child: GestureDetector(
                              onTap: () {
                                BookingFlow.selectedBooking = data;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MoreDetails()));
                              },
                              child: Container(
                                // height: 200,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            139, 0, 0, 1))),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        data.transId!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15 / scaleFactor,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Expanded(
                                          child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Text(
                                          data.adminStatus!.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 14 / scaleFactor,
                                              color: data.adminStatus!
                                                          .toLowerCase() ==
                                                      'pending'
                                                  ? Colors.yellow[800]
                                                  : data.adminStatus!
                                                              .toLowerCase() ==
                                                          'confirmed'
                                                      ? Colors.green
                                                      : Colors.redAccent),
                                        ),
                                      ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .do_not_disturb_on_total_silence_sharp,
                                                  color: Colors.redAccent,
                                                ),
                                                Text(data.pickupDate!,
                                                    style: TextStyle(
                                                        fontSize:
                                                            14 / scaleFactor))
                                              ],
                                            ),
                                            Text(
                                              "Pickup Date & Time",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14 / scaleFactor),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .do_not_disturb_on_total_silence_sharp,
                                                  color: Colors.green,
                                                ),
                                                Text(data.dropDate!,
                                                    style: TextStyle(
                                                        fontSize:
                                                            14 / scaleFactor))
                                              ],
                                            ),
                                            Text(
                                              "Drop Date & Time",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14 / scaleFactor),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Image.network(
                                                  data.bikeImage!,
                                                  errorBuilder: (a, b, c) =>
                                                      Image.network(
                                                    'https://www.ridobiko.com/images/default.png',
                                                    height: 80,
                                                  ),
                                                  fit: BoxFit.contain,
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              data.bikeName!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15 / scaleFactor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ]),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Visibility(
                                    visible: data.adminStatus == 'Confirmed' ||
                                        data.adminStatus == 'pending',
                                    child: const Divider(
                                      thickness: 0.5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Visibility(
                                    visible: data.adminStatus == 'Confirmed' ||
                                        data.adminStatus == 'pending',
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _selectedToExtend = data;
                                            //_selectedEndDate=DateTime.parse(_selectedToExtend!.dropDate!.split(' ')[0]);
                                            //_selectedEndDate=DateTime.parse(_selectedToExtend!.dropDate!.split(' ')[0]);
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext pcontext) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext
                                                            bcontext,
                                                        void Function(
                                                                void Function())
                                                            setState) {
                                                      _popup = pcontext;
                                                      return Dialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          child: Container(
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                SizedBox(
                                                                  height: 50,
                                                                  child: Stack(
                                                                    children: [
                                                                      Container(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top:
                                                                                  12,
                                                                              bottom:
                                                                                  12),
                                                                          decoration: const BoxDecoration(
                                                                              color: Color.fromRGBO(139, 0, 0, 0.8),
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                                                          child: Container(
                                                                            margin:
                                                                                const EdgeInsets.only(left: 30),
                                                                            child: Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text(
                                                                                  "Extend Your Booking",
                                                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18 / scaleFactor),
                                                                                )),
                                                                          )),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                50,
                                                                            height:
                                                                                50,
                                                                            decoration:
                                                                                const BoxDecoration(color: Color.fromRGBO(139, 0, 0, 1), borderRadius: BorderRadius.only(topRight: Radius.circular(20))),
                                                                            child: const RotationTransition(
                                                                                turns: AlwaysStoppedAnimation(45 / 360),
                                                                                child: Icon(
                                                                                  Icons.add,
                                                                                  size: 30,
                                                                                  color: Colors.white,
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        'Store operational between ${_selectedToExtend?.vendorDetails?.opening ?? '-'} to ${_selectedToExtend?.vendorDetails?.closing ?? '-'}',
                                                                        style: TextStyle(
                                                                            fontSize: 14 /
                                                                                scaleFactor,
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              20),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Text(
                                                                            "Drop Date: ",
                                                                            style: TextStyle(
                                                                                decoration: TextDecoration.underline,
                                                                                color: Colors.grey,
                                                                                fontSize: 15 / scaleFactor),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                45,
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {},
                                                                              child: Directionality(
                                                                                textDirection: TextDirection.ltr,
                                                                                child: GestureDetector(
                                                                                  onTap: () async {
                                                                                    _selectEndDate(bcontext);
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                                    child: Text(_selectedEndDate.toString().split(' ')[0], style: TextStyle(fontSize: 14 / scaleFactor)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Text(
                                                                            "Drop Time: ",
                                                                            style: TextStyle(
                                                                                decoration: TextDecoration.underline,
                                                                                color: Colors.grey,
                                                                                fontSize: 15 / scaleFactor),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                45,
                                                                          ),
                                                                          Flexible(
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {},
                                                                              child: Directionality(
                                                                                textDirection: TextDirection.ltr,
                                                                                child: GestureDetector(
                                                                                  onTap: () async {
                                                                                    _selectEndTime(bcontext);
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                                    child: Text("   ${_selectedEndTime.toString().split(' ')[1].substring(0, 8)}   ", style: TextStyle(fontSize: 14 / scaleFactor)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Container(
                                                                              padding: const EdgeInsets.all(10),
                                                                              width: 90,
                                                                              decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                                              child: Center(
                                                                                child: Consumer(
                                                                                  builder: (context, ref, child) {
                                                                                    final gst = ref.watch(gstProvider.notifier).getGSTPercentage;
                                                                                    double rent = _calculatedRent * (1 + gst / 100);
                                                                                    return Text('₹${rent.toStringAsFixed(2)}', style: TextStyle(fontSize: 14 / scaleFactor));
                                                                                  },
                                                                                ),
                                                                              )),
                                                                          const SizedBox(
                                                                            width:
                                                                                20,
                                                                          ),
                                                                          ElevatedButton(
                                                                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                                                                              onPressed: () {
                                                                                _calculateRent();
                                                                              },
                                                                              child: Text(
                                                                                "Calculate Rent",
                                                                                style: TextStyle(color: Colors.white, fontSize: 15 / scaleFactor),
                                                                              )),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Card(
                                                                    elevation:
                                                                        5,
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              10.0),
                                                                          gradient: LinearGradient(
                                                                              begin: Alignment.topLeft,
                                                                              end: Alignment.bottomRight,
                                                                              colors: [
                                                                                const Color.fromRGBO(139, 0, 0, 1),
                                                                                Colors.red[200]!
                                                                              ])),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Proceed Extend Booking",
                                                                              style: TextStyle(color: Colors.white, fontSize: 15 / scaleFactor),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ));
                                                    },
                                                  );
                                                });
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.arrow_forward,
                                                color: Color.fromRGBO(
                                                    139, 0, 0, 1),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                "Extend Booking",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14 / scaleFactor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Visibility(
                                          visible: data.amountLeft != "0",
                                          child: InkWell(
                                            onTap: () {
                                              showBottomSheet(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                        side: BorderSide(
                                                          color: Colors.grey,
                                                          width: 3,
                                                        )),
                                                context: context,
                                                builder: (context) {
                                                  return SizedBox(
                                                    height: 320,
                                                    child: PayRemainingWidget(
                                                        data),
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  color: Color.fromRGBO(
                                                      139, 0, 0, 1),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  "Pay Remaining",
                                                  style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            )));
                  }),
            ),
            widget.dataAvailable && widget.trips.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(139, 0, 0, 1),
                    ),
                  )
                : Align(
                    child: Visibility(
                      visible: widget.dataAvailable == false,
                      child: Container(
                        alignment: Alignment.center,
                        width: 300,
                        child: Text(
                          'No Completed Booking Found !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 19 / scaleFactor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
          ],
        ));
  }

  Future<void> _pay() async {
    var name = ref.read(userProvider)!.firstname;
    var phone = ref.read(userProvider)!.mobile;
    var email = ref.read(userProvider)!.email;
    var amt = _payingAmount;
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
      // 'amount': '${_payingAmount}00',
      'amount': payInString,
      'name': 'Ridobiko Solutions Pvt. Ltd.',
      'description': 'Security deposit'
          '',
      'prefill': {'contact': phone, 'email': '$email', 'name': '$name'},
      'notes': {
        // 'Type': "Remaining Amount",
        'merchant_order_id': order_id,
        // 'order_id': '${_selectedToExtend!.transId}',
        'drop_date':
            '${_selectedEndDate.toString().split(' ')[0]} ${_selectedEndTime.toString().split(' ')[1]}',
        'Amount': '$_payingAmount',
        'TotalPayingAAmount': pay.toStringAsFixed(2),
        'customer_mobile': phone,
        'type': _currentPaying == 'rent' ? 3 : 5,
        'gst': gstAmount.toStringAsFixed(2),
        // 'Merchant Email': '${BookingFlow.selectedBike!.vendorEmailId}',
      }
    };
    _razorpay.open(options);
  }

  Future<void> _selectEndDate(BuildContext bcontext) async {
    showCupertinoModalPopup(
        context: bcontext,
        builder: (builder) => CupertinoActionSheet(
              actions: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    minimumDate: DateTime.now().add(const Duration(days: 1)),
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime:
                        DateTime.now().add(const Duration(days: 1)),
                    onDateTimeChanged: (dateTime) {
                      _selectedEndDate = dateTime;
                      setState(() {});
                    },
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(bcontext);
                  _selectEndTime(bcontext);
                },
                child: const Text("Done"),
              ),
            ));
  }

  Future<void> _selectEndTime(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) => CupertinoActionSheet(
              actions: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: _selectedEndTime,
                    onDateTimeChanged: (dateTime) {
                      int openingHour = int.tryParse(_selectedToExtend
                                  ?.vendorDetails?.opening
                                  ?.split(':')[0] ??
                              '') ??
                          8;
                      int closingHour = int.tryParse(_selectedToExtend
                                  ?.vendorDetails?.closing
                                  ?.split(':')[0] ??
                              '') ??
                          20;
                      int openingMin = int.tryParse(_selectedToExtend
                                  ?.vendorDetails?.opening
                                  ?.split(':')[1] ??
                              '') ??
                          8;
                      int closingMin = int.tryParse(_selectedToExtend
                                  ?.vendorDetails?.closing
                                  ?.split(':')[1] ??
                              '') ??
                          20;
                      int staring = openingHour * 60 + openingMin;
                      int closing = closingHour * 60 + closingMin;
                      int now = dateTime.hour * 60 + dateTime.minute;
                      if (now >= staring && closing >= now) {
                        setState(() {
                          _selectedEndTime = dateTime;
                        });
                      }
                    },
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(_popup);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext pcontext) {
                        return StatefulBuilder(
                          builder: (BuildContext bcontext,
                              void Function(void Function()) setState) {
                            _popup = pcontext;
                            return Dialog(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: Stack(
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    top: 12, bottom: 12),
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        139, 0, 0, 0.8),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20))),
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30),
                                                  child: const Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "Extend Your Booking",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 18),
                                                      )),
                                                )),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          139, 0, 0, 1),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  child:
                                                      const RotationTransition(
                                                          turns:
                                                              AlwaysStoppedAnimation(
                                                                  45 / 360),
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 30,
                                                            color: Colors.white,
                                                          )),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Store operational between ${_selectedToExtend?.vendorDetails?.opening ?? '-'} to ${_selectedToExtend?.vendorDetails?.closing ?? '-'}',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text(
                                                  "Drop Date: ",
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                                const SizedBox(
                                                  width: 45,
                                                ),
                                                Flexible(
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Directionality(
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            _selectEndDate(
                                                                bcontext);
                                                          },
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: Text(
                                                                  _selectedEndDate
                                                                      .toString()
                                                                      .split(
                                                                          ' ')[0])),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text(
                                                  "Drop Time: ",
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                                const SizedBox(
                                                  width: 45,
                                                ),
                                                Flexible(
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Directionality(
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          _selectEndTime(
                                                              bcontext);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          10))),
                                                          child: Text(
                                                              "   ${_selectedEndTime.toString().split(' ')[1].substring(0, 8)}   "),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: Center(
                                                      child: Consumer(
                                                        builder: (context, ref,
                                                            child) {
                                                          final gst = ref
                                                              .watch(gstProvider
                                                                  .notifier)
                                                              .getGSTPercentage;
                                                          double rent =
                                                              _calculatedRent *
                                                                  (1 +
                                                                      gst /
                                                                          100);
                                                          return Text(
                                                              '₹${rent.toStringAsFixed(2)}');
                                                        },
                                                      ),
                                                    )),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .redAccent)),
                                                    onPressed: () {
                                                      _calculateRent();
                                                    },
                                                    child: const Text(
                                                      "Calculate Rent",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Card(
                                          elevation: 5,
                                          margin: const EdgeInsets.all(8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      const Color.fromRGBO(
                                                          139, 0, 0, 1),
                                                      Colors.red[200]!
                                                    ])),
                                            child: const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Proceed Extend Booking",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        );
                      });
                },
                child: const Text("Done"),
              ),
            ));
    // CupertinoDatePicker(
    //   onDateTimeChanged: (dateTime){
    //
    //   },);
  }

  Future<void> _updateData(PaymentSuccessResponse respo) async {
    setState(() {
      _pb = true;
    });
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
    setState(() {
      _pb = false;
    });
    var response = jsonDecode(call.body);
    if (response['success']) {}
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${response['message']}')));
  }

  Future<void> _createExtendTrip(PaymentSuccessResponse respo) async {
    setState(() {
      _pb = true;
    });
    String token = ref.read(userProvider)!.token!;

    var call = await http.post(
        Uri.parse('${Constants().url}android_app_customer/api/extendTrip.php'),
        body: {
          'order_id': '${_selectedToExtend!.transId}',
          'drop_date':
              '${_selectedEndDate.toString().split(' ')[0]} ${_selectedEndTime.toString().split(' ')[1]}',
          'rent': _calculatedRent.toString(),
        },
        headers: {
          'token': token,
        });
    setState(() {
      _pb = false;
    });
    var response = jsonDecode(call.body);
    if (response['success']) {
      Navigator.pop(_popup);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${response['message']}')));
  }

  Future<void> _calculateRent() async {
    setState(() {
      _pb = true;
    });
    String token = ref.read(userProvider)!.token!;

    var call = await http.post(
        Uri.parse('${Constants().url}android_app_customer/api/extendRent.php'),
        body: {
          'bike_id': '${_selectedToExtend!.bikesId}',
          'drop_date':
              '${_selectedEndDate.toString().split(' ')[0]} ${_selectedEndTime.toString().split(' ')[1]}',
          'pickup_date': '${_selectedToExtend!.dropDate}',
        },
        headers: {
          'token': token,
        });
    setState(() {
      _pb = false;
    });
    var response = jsonDecode(call.body);
    if (response['success']) {
      response['data']['rent'].runtimeType == int
          ? _calculatedRent = response['data']['rent']
          : _calculatedRent = (response['data']['rent'] as double).round();
      Navigator.pop(_popup);
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext pcontext) {
            return StatefulBuilder(
              builder: (BuildContext bcontext,
                  void Function(void Function()) setState) {
                _popup = pcontext;
                return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Stack(
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 12, bottom: 12),
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(139, 0, 0, 0.8),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 30),
                                      child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Extend Your Booking",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18),
                                          )),
                                    )),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          color: Color.fromRGBO(139, 0, 0, 1),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20))),
                                      child: const RotationTransition(
                                          turns:
                                              AlwaysStoppedAnimation(45 / 360),
                                          child: Icon(
                                            Icons.add,
                                            size: 30,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  'Store operational between ${_selectedToExtend?.vendorDetails?.opening ?? '-'} to ${_selectedToExtend?.vendorDetails?.closing ?? '-'}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      "Drop Date: ",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.grey,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 45,
                                    ),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: GestureDetector(
                                              onTap: () async {
                                                _selectEndDate(bcontext);
                                              },
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10))),
                                                  child: Text(_selectedEndDate
                                                      .toString()
                                                      .split(' ')[0])),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      "Drop Time: ",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.grey,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 45,
                                    ),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: GestureDetector(
                                            onTap: () async {
                                              _selectEndTime(bcontext);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Text(
                                                  "   ${_selectedEndTime.toString().split(' ')[1].substring(0, 8)}   "),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        width: 90,
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: Consumer(
                                            builder: (context, ref, child) {
                                              final gst = ref
                                                  .watch(gstProvider.notifier)
                                                  .getGSTPercentage;
                                              double rent = _calculatedRent *
                                                  (1 + gst / 100);
                                              return Text(
                                                  '₹${rent.toStringAsFixed(2)}');
                                            },
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.redAccent)),
                                        onPressed: () {
                                          _calculateRent();
                                        },
                                        child: const Text(
                                          "Calculate Rent",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              _currentPaying = 'extend';
                              _payingAmount = _calculatedRent;
                              order_id = _selectedToExtend!.transId!;
                              _pay();
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
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Proceed Extend Booking",
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
                    ));
              },
            );
          });
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${response['message']}')));
  }
}
