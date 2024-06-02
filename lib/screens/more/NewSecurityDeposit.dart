// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, non_constant_identifier_names, file_names, unused_local_variable, prefer_adjacent_string_concatenation

import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ridobiko/providers/provider.dart';

import 'package:ridobiko/screens/rental/MyHomePage.dart';
import 'package:ridobiko/screens/more/widgets/RatingDailog.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/security_deposit_data.dart';
import 'package:ridobiko/utils/cred.dart';

// ignore: must_be_immutable
class NewSecurityDepoPB extends ConsumerStatefulWidget {
  int? bikeDeposit;
  NewSecurityDepoPB([this.bikeDeposit]);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewSecurityDepoPBState();
}

class _NewSecurityDepoPBState extends ConsumerState<NewSecurityDepoPB> {
  var searchController = TextEditingController();
  final _amountController = TextEditingController();
  final List<SecurityDepositData> _previosTransactions = [];
  String order_id = '';
  final _razorpay = Razorpay();
  final _accIfsc = TextEditingController();
  final _accNo = TextEditingController();
  final _accName = TextEditingController();
  String accName = '';
  String accNum = '';
  String ifsc = '';
  bool firstRefund = false;
  bool usePreviousAccountDetailForRefund = true;
  bool isLoading = false;
  @override
  void initState() {
    refresh();
    _getSecurityDeposit();
    setState(() {
      isLoading = false;
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var headers = {
      'Authorization':
          'Basic cnpwX2xpdmVfd3dwR3pkSTJHRFdTMjk6SUkyOUQ4cEdNR0xCWVdHWm44cWdvMlBx',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.razorpay.com/v1/payments/${response.paymentId}/capture'));
    request.body = json
        .encode({"amount": '${_amountController.text}00', "currency": "INR"});
    request.headers.addAll(headers);
    http.StreamedResponse response2 = await request.send();
    _addAmount(response);
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

  Future<void> refresh() async {
    searchController.text = '';
    String token = ref.read(userProvider)!.token!;
    await ref.read(securityDepositDataProvider.notifier).fetch(token);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          isLoading ? const CircularProgressIndicator() : null,
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await refresh();
        },
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SizedBox(
              height: size.height,
              child: Column(
                children: [
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xffF9FBFF),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.7),
                          blurRadius: 16,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color.fromRGBO(139, 0, 0, 1),
                          elevation: 0,
                          actions: [
                            IconButton(
                              onPressed: () async {
                                await refresh();
                              },
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: Color.fromRGBO(139, 0, 0, 1),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 100,
                                            margin: const EdgeInsets.only(
                                                top: 20, bottom: 30),
                                            child: SvgPicture.asset(
                                                "assets/images/securityimg.svg"),
                                          ),
                                          Text(
                                            "Security Deposit",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20 / scaleFactor),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "◉ This is refundable security deposit .",
                                              style: TextStyle(
                                                  fontSize: 14 / scaleFactor,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "◉ Deposit amount will be refunded into your account with  in 24-48 hours of vehicle drop.",
                                              style: TextStyle(
                                                  fontSize: 14 / scaleFactor,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "◉ 2% will be deducted as payment gateway charges.",
                                              style: TextStyle(
                                                  fontSize: 14 / scaleFactor,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.rule_folder_sharp,
                                color: Color(0xFF8B0000),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                int current = DateTime.now().month;
                                int last = (prefs.getInt('rating_box') ?? -1);
                                prefs.setInt('rating_box', -1);
                                if (current != last) {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (context) {
                                      return const RatingDailog();
                                    },
                                  );
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyHomePage()),
                                      (route) => false);
                                  if (!BookingFlow.fromMore) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Congratulation... Your bike is booked you can check more details in Booking section.')));
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.home,
                                color: Color.fromRGBO(139, 0, 0, 1),
                              ),
                              label: Text(
                                'Home',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: const Color.fromRGBO(139, 0, 0, 1),
                                    fontSize: 17 / scaleFactor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Consumer(
                                builder: (context, ref, child) {
                                  var bal = ref.watch(
                                      securityDepositDataProvider
                                          .select((value) => value.balance));
                                  debugPrint(
                                      '######### Deposit ${widget.bikeDeposit}');
                                  if (widget.bikeDeposit != null) {
                                    bal = max(0, widget.bikeDeposit! - bal);
                                    _amountController.text = bal.toString();
                                    if (kDebugMode) {
                                      print('######### Deposit here reached');
                                    }
                                  }
                                  return RichText(
                                    text: TextSpan(
                                      text: '₹',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 48,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(text: bal.toString()),
                                        TextSpan(
                                          text: '.00',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 40 / scaleFactor,
                                            color:
                                                Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Text(
                                widget.bikeDeposit != null
                                    ? 'Required more to book bike'
                                    : 'Available on your deposit',
                                style: TextStyle(
                                    fontSize: 14 / scaleFactor,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  textStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16 / scaleFactor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  fixedSize: Size(size.width * .4, 50),
                                  backgroundColor:
                                      const Color.fromRGBO(139, 0, 0, 1),
                                ),
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      // <-- SEE HERE
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (BuildContext bcontext) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: 20,
                                            right: 20,
                                            left: 20,
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/money.svg",
                                              height: 70,
                                              width: 70,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 30, bottom: 30),
                                              child: TextField(
                                                // enabled: false,
                                                controller: _amountController,

                                                decoration: InputDecoration(
                                                    icon: SvgPicture.asset(
                                                      "assets/images/priceicon.svg",
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    hintText:
                                                        'Enter Amount in ₹ ',
                                                    hintStyle: TextStyle(
                                                        fontSize:
                                                            14 / scaleFactor,
                                                        color: Colors.black),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 0.5),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10))),
                                                    border: InputBorder.none,
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey[200]!,
                                                            width: 0.5),
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    labelStyle: TextStyle(
                                                      fontSize:
                                                          17 / scaleFactor,
                                                      color: Colors.black,
                                                    ),
                                                    fillColor: Colors.white,
                                                    filled: true),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                obscureText: false,
                                              ),
                                            ),
                                            Text(
                                              textAlign: TextAlign.justify,
                                              'Note: Prefer to pay through UPI. If you pay via Paytm Wallet or any other option, 2% or more will be deducted as payment gateway charges ',
                                              style: TextStyle(
                                                  fontSize: 15 / scaleFactor,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (_amountController
                                                    .text.isNotEmpty) {
                                                  paytmPay();
                                                  // _pay();
                                                  Navigator.pop(bcontext);
                                                }
                                                // Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileVerify()));
                                              },
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 30, bottom: 30),
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                        const Color.fromRGBO(
                                                            139, 0, 0, 1),
                                                        Colors.red[200]!
                                                      ])),
                                                  child: Center(
                                                    child: Text(
                                                      'Proceed',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              15 / scaleFactor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                label: Text('Deposit',
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor)),
                                icon: const Icon(Icons.currency_rupee_sharp),
                              ),
                              if (widget.bikeDeposit == null)
                                const SizedBox(width: 25),
                              if (widget.bikeDeposit == null)
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    textStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    fixedSize: Size(size.width * .4, 50),
                                    backgroundColor:
                                        const Color.fromRGBO(139, 0, 0, 1),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        // <-- SEE HERE
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      builder: (BuildContext vcontext) {
                                        return Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10,
                                              10,
                                              10,
                                              (MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom +
                                                  10)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Card(
                                                margin:
                                                    const EdgeInsets.all(12),
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        139, 0, 0, 1),
                                                    width: 0.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                // elevation: 5,
                                                child: StatefulBuilder(builder:
                                                    (context, newState) {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Center(
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    20,
                                                                    20,
                                                                    20,
                                                                    10),
                                                            child:
                                                                Directionality(
                                                                    textDirection: ui
                                                                        .TextDirection
                                                                        .ltr,
                                                                    // textDirection:
                                                                    //     TextDirection.LTR,
                                                                    child:
                                                                        TextField(
                                                                      enabled:
                                                                          !usePreviousAccountDetailForRefund,
                                                                      controller:
                                                                          _accName,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      decoration: InputDecoration(
                                                                          prefixIcon: const Icon(Icons
                                                                              .person),
                                                                          labelStyle: TextStyle(
                                                                              fontSize: 14 /
                                                                                  scaleFactor,
                                                                              color: Colors
                                                                                  .grey),
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 14 /
                                                                                  scaleFactor,
                                                                              color: Colors
                                                                                  .grey),
                                                                          enabledBorder: const OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                          border: InputBorder.none,
                                                                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                          labelText: "Account holder name",
                                                                          hintText: "Enter name"),
                                                                    ))),
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child:
                                                                Directionality(
                                                                    textDirection: ui
                                                                        .TextDirection
                                                                        .ltr,
                                                                    child:
                                                                        TextField(
                                                                      enabled:
                                                                          !usePreviousAccountDetailForRefund,
                                                                      controller:
                                                                          _accNo,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      decoration: InputDecoration(
                                                                          prefixIcon: const Icon(Icons
                                                                              .account_balance),
                                                                          labelStyle: TextStyle(
                                                                              fontSize: 14 /
                                                                                  scaleFactor,
                                                                              color: Colors
                                                                                  .grey),
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 14 /
                                                                                  scaleFactor,
                                                                              color: Colors
                                                                                  .grey),
                                                                          enabledBorder: const OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                          border: InputBorder.none,
                                                                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                          labelText: "Account Number",
                                                                          hintText: "Enter Account Number"),
                                                                    ))),
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child:
                                                                Directionality(
                                                                    textDirection: ui
                                                                        .TextDirection
                                                                        .ltr,
                                                                    child:
                                                                        TextField(
                                                                      enabled:
                                                                          !usePreviousAccountDetailForRefund,
                                                                      controller:
                                                                          _accIfsc,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      decoration: InputDecoration(
                                                                          prefixIcon: const Icon(Icons
                                                                              .confirmation_number_outlined),
                                                                          labelStyle: TextStyle(
                                                                              fontSize: 14 /
                                                                                  scaleFactor,
                                                                              color: Colors
                                                                                  .grey),
                                                                          hintStyle: TextStyle(
                                                                              fontSize: 14 /
                                                                                  scaleFactor,
                                                                              color: Colors
                                                                                  .grey),
                                                                          enabledBorder: const OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.grey, width: 0.5),
                                                                              borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                          border: InputBorder.none,
                                                                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                          labelText: "IFSC Code",
                                                                          hintText: "Enter IFSC Code"),
                                                                    ))),
                                                      ),
                                                      if (!firstRefund)
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child:
                                                                Directionality(
                                                              textDirection: ui
                                                                  .TextDirection
                                                                  .ltr,
                                                              child: Card(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  side:
                                                                      const BorderSide(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            139,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          20),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                          'Use previous account for refund',
                                                                          style:
                                                                              TextStyle(fontSize: 14 / scaleFactor)),
                                                                      const Spacer(),
                                                                      Switch(
                                                                        activeColor: const Color
                                                                            .fromRGBO(
                                                                            139,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                        value:
                                                                            usePreviousAccountDetailForRefund,
                                                                        onChanged:
                                                                            (v) {
                                                                          usePreviousAccountDetailForRefund =
                                                                              v;
                                                                          if (v) {
                                                                            usePrevious();
                                                                          } else {
                                                                            useNew();
                                                                          }
                                                                          newState(
                                                                              () {});
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                }),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (_accIfsc
                                                          .text.isNotEmpty &&
                                                      _accNo.text.isNotEmpty) {
                                                    _verifyAccount();
                                                  }
                                                  // Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileVerify()));
                                                },
                                                child: Container(
                                                    height: 60,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              const Color
                                                                  .fromRGBO(
                                                                  139, 0, 0, 1),
                                                              Colors.red[200]!
                                                            ])),
                                                    child: Center(
                                                      child: Text(
                                                        'Verify',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15 /
                                                                scaleFactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  label: Text('Withdraw',
                                      style: TextStyle(
                                          fontSize: 14 / scaleFactor)),
                                  icon: const Icon(Icons.send_outlined),
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final txnList = ref.watch(securityDepositDataProvider
                            .select((value) => value.transactions));
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'History',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 20 / scaleFactor,
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: size.width * .6,
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: (v) {
                                        setState(() {});
                                      },
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 10,
                                        ),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color.fromRGBO(139, 0, 0, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            (txnList.isEmpty)
                                ? Center(
                                    child: Container(
                                      width: 250,
                                      margin: const EdgeInsets.only(
                                          top: 20, bottom: 30),
                                      child: SvgPicture.asset(
                                          "assets/images/securityimg.svg"),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: txnList.length,
                                    itemBuilder: (context, index) {
                                      final data = txnList.elementAt(index);
                                      if (kDebugMode) {
                                        print("######### ${data.txnType} ");
                                      }
                                      final isRefund = data.txnType!
                                              .contains('Refund') ||
                                          data.txnType!.contains('Deduction');
                                      if (kDebugMode) {
                                        print(isRefund);
                                      }
                                      bool flag1 = data.amount
                                              ?.toLowerCase()
                                              .contains(
                                                  searchController.text) ??
                                          false;
                                      bool flag2 = data.paymentMode
                                              ?.toLowerCase()
                                              .contains(
                                                  searchController.text) ??
                                          false;
                                      bool flag3 = data.ridobikoOrderId
                                              ?.toLowerCase()
                                              .contains(
                                                  searchController.text) ??
                                          false;
                                      bool flag4 = data.transId
                                              ?.toLowerCase()
                                              .contains(
                                                  searchController.text) ??
                                          false;
                                      bool flag5 = data.txnType
                                              ?.toLowerCase()
                                              .contains(
                                                  searchController.text) ??
                                          false;
                                      if (flag1 ||
                                          flag2 ||
                                          flag3 ||
                                          flag4 ||
                                          flag5) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) => Card(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                data.txnType
                                                                        ?.toUpperCase() ??
                                                                    '',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 24 /
                                                                      scaleFactor,
                                                                  color: Colors
                                                                      .indigo,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_downward_rounded,
                                                                  color: Colors
                                                                      .indigo,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                isRefund
                                                                    ? "- ₹${data.amount!}"
                                                                    : '₹${data.amount!}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 25 /
                                                                      scaleFactor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: isRefund
                                                                      ? Colors
                                                                          .redAccent
                                                                      : Colors
                                                                          .green,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Date: ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18 /
                                                                                scaleFactor,
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    data.transDate!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: 18 /
                                                                          scaleFactor,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
/*                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  const Text(
                                                                    "Modified on :",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    data.modifiedOn!,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),*/
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Transaction id : ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18 /
                                                                                scaleFactor,
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    data.ridobikoOrderId!
                                                                        .toUpperCase(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: 18 /
                                                                          scaleFactor,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Comment : ",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18 / scaleFactor,
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child:
                                                                          Text(
                                                                        data.comment!,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18 / scaleFactor,
                                                                          color:
                                                                              Colors.black54,
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const Divider(
                                                                thickness: 0.5,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Status: ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18 /
                                                                                scaleFactor,
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    data.status!,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: 18 /
                                                                          scaleFactor,
                                                                      color: Colors
                                                                          .black54,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              visualDensity:
                                                  const VisualDensity(
                                                      vertical: -2),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 0),
                                              leading: CircleAvatar(
                                                radius: 21,
                                                backgroundColor: !isRefund
                                                    ? Colors.blue.shade200
                                                    : Colors.red.shade200,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      Colors.white70,
                                                  child: Center(
                                                    child: Icon(
                                                      isRefund
                                                          ? Icons
                                                              .call_made_rounded
                                                          : Icons
                                                              .call_received_rounded,
                                                      size: 30,
                                                      color: !isRefund
                                                          ? Colors.blue.shade300
                                                          : Colors.red.shade300,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    data.txnType ?? '',
                                                    style: GoogleFonts.poppins(
                                                      fontSize:
                                                          18 / scaleFactor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                    ),
                                                  ),
                                                  Text(
                                                    isRefund
                                                        ? "- ₹${data.amount!}"
                                                        : '+ ₹${data.amount!}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          18 / scaleFactor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isRefund
                                                          ? Colors.black
                                                              .withOpacity(0.7)
                                                          : Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      data.transDate.toString(),
                                                      style: TextStyle(
                                                          fontSize: 14 /
                                                              scaleFactor)),
                                                  Text('${data.status}',
                                                      style: TextStyle(
                                                          fontSize: 14 /
                                                              scaleFactor)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width - 70,
                                              child: const Divider(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void usePrevious() {
    _accNo.value = TextEditingValue(
      text: accNum,
      selection: TextSelection.fromPosition(
        TextPosition(offset: accNum.length),
      ),
    );
    _accName.value = TextEditingValue(
      text: accName,
      selection: TextSelection.fromPosition(
        TextPosition(offset: accName.length),
      ),
    );
    _accIfsc.value = TextEditingValue(
      text: ifsc,
      selection: TextSelection.fromPosition(
        TextPosition(offset: ifsc.length),
      ),
    );
  }

  void useNew() {
    _accNo.value = TextEditingValue(
      text: '',
      selection: TextSelection.fromPosition(
        const TextPosition(offset: 0),
      ),
    );
    _accName.value = TextEditingValue(
      text: '',
      selection: TextSelection.fromPosition(
        const TextPosition(offset: 0),
      ),
    );
    _accIfsc.value = TextEditingValue(
      text: '',
      selection: TextSelection.fromPosition(
        const TextPosition(offset: 0),
      ),
    );
  }

  Future<void> _getSecurityDeposit() async {
    setState(() {
      isLoading = true;
    });
    String token = ref.read(userProvider)!.token!;

    var call = await http.post(
        Uri.parse(
            '${Constants().url}android_app_customer/api/getWalletDetails.php'),
        headers: {
          'token': token,
        });
    var response = jsonDecode(call.body);
    if (response['success']) {
      if (response['data'] != null) {
        for (var data in response['data']['wallet_transaction']) {
          _previosTransactions.add(SecurityDepositData.fromJson(data));
        }
        accName = response['data']['account_name'] ?? '';
        accNum = response['data']['account_no'] ?? '';
        ifsc = response['data']['ifsc'] ?? '';
        if (accNum.isEmpty) {
          usePreviousAccountDetailForRefund = false;
          firstRefund = true;
        } else if (accName.isEmpty) {
          usePreviousAccountDetailForRefund = false;
          firstRefund = true;
        } else if (ifsc.isEmpty) {
          usePreviousAccountDetailForRefund = false;
          firstRefund = true;
        }
        usePrevious();
        setState(() {
          isLoading = false;
        });
        return;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> paytmPay() async {
    String token = ref.read(userProvider)!.token!;

    String amount = _amountController.text;

    var response = await http.post(
      Uri.parse(
          '${Constants().url}android_app_customer/api/paytm/initiateTransaction.php'),
      headers: {
        'token': token,
      },
      body: {
        'AMOUNT': _amountController.text,
        'MID': Cred().paytmMID,
      },
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 200 || body['body']['resultStatus'] == 'S') {
      String orderId = body['order_id'] ?? '';
      String txnToken = body['body']['txnToken'] ?? '';
      await AllInOneSdk.startTransaction(
        Cred().paytmMID, // MID
        orderId, // Order_id
        amount, // Amount
        txnToken, // Transaction Token
        'https://securegw${Cred().isLive ? '' : '-stage'}.paytm.in/theia/paytmCallback?ORDER_ID=$orderId', // Callback URL
        Cred().isLive ? false : true, // isStaging
        true, // restrictAppInvoke
      ).then((value) async {
        if (value == null) return;
        setState(() {});
        String token = ref.read(userProvider)!.token!;

        var call = await http.post(
          Uri.parse(
              '${Constants().url}android_app_customer/api/addSecurityAmount.php'),
          body: {
            'trans_date': value['TXNDATE'] ?? '',
            'payment_mode': value['GATEWAYNAME'] ?? '',
            'amount': value['TXNAMOUNT'] ?? '',
            'trans_id': value['TXNID'] ?? '',
            'ridobiko_order_id': value['ORDERID'],
          },
          headers: {
            'token': token,
          },
        );
        var response = jsonDecode(call.body);
        //print(response);
        if (response['success']) {
          _getSecurityDeposit();
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response['message']}')));
      }).catchError((onError) {
        if (onError is PlatformException) {
          setState(() {
            String result =
                onError.message ?? '' + " \n  " + onError.details.toString();
            //print(result);
          });
        } else {
          setState(() {
            String result = onError.toString();
            //print(result);
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Server Error')));
    }
    refresh();
  }

  Future<void> pay() async {
    var prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('firstname');
    var phone = prefs.getString('mobile');
    var email = prefs.getString('email');
    order_id =
        'w${'${intl.DateFormat('ydM').format(DateTime.now())}${phone?.substring(6)}'.substring(2)}';
    var options = {
      'key': Cred().razorpayKey,
      'amount': '${_amountController.text}00',
      'name': 'Ridobiko Solutions Pvt. Ltd.',
      'description': 'Security deposit'
          '',
      'prefill': {'contact': phone, 'email': '$email', 'name': '$name'},
      'notes': {
        // 'Type': "Security Deposit",
        'merchant_order_id': order_id,
        'amount': _amountController.text,
        'type': 4,
        'customer_mobile': phone,
        // 'Merchant Email': '${BookingFlow.selectedBike!.vendorEmailId}',
      }
    };
    _razorpay.open(options);
  }

  void _addAmount(PaymentSuccessResponse? respo) async {
    String token = ref.read(userProvider)!.token!;

    var call = await http.post(
        Uri.parse(
            '${Constants().url}android_app_customer/api/addSecurityAmount.php'),
        body: {
          'trans_date': DateTime.now().toString(),
          'payment_mode': 'UPI',
          'amount': _amountController.text,
          'trans_id': respo!.orderId ?? 'Testing',
          'ridobiko_order_id': order_id,
        },
        headers: {
          'token': token,
        });
    var response = jsonDecode(call.body);
    if (response['success']) {
      _getSecurityDeposit();
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${response['message']}')));
  }

  void _verifyAccount() async {
    Navigator.pop(context);
    setState(() {});
    String token = ref.read(userProvider)!.token!;

    var call = await http.post(
        Uri.parse(
            '${Constants().url}android_app_customer/api/setRefundRequest.php'),
        body: {
          'account_name': _accName.text,
          'account_number': _accNo.text,
          'ifsc': _accIfsc.text,
          'save_account': usePreviousAccountDetailForRefund ? '0' : '1',
        },
        headers: {
          'token': token,
        });
    var response = jsonDecode(call.body);
    //print(response);
    setState(() {});
    _accIfsc.value;
    if (response['success']) {
      final prefs = await SharedPreferences.getInstance();
      int current = DateTime.now().month;
      int last = prefs.getInt('rating_box') ?? -1;
      if (current != last) {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (context) {
              return const RatingDailog();
            });
      }
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${response['message']}')));
    refresh();
  }
}
