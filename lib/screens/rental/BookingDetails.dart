// ignore_for_file: unused_import, use_build_context_synchronously, file_names, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ridobiko/core/Constants.dart';
import 'package:ridobiko/screens/rental/ProfileVerify.dart';
import 'package:ridobiko/screens/bookings/ViewUploadImages.dart';
import 'package:ridobiko/data/invoice.dart';
import 'package:ridobiko/controllers/auth/auth_controller.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:ridobiko/data/GST.dart';
import 'package:ridobiko/data/coupon.dart';
import 'package:ridobiko/main.dart';
import 'package:ridobiko/screens/rental/BikePolicies.dart';
import 'package:ridobiko/screens/rental/CouponsScreen.dart';
import 'package:ridobiko/screens/more/DocumentUpload.dart';
import 'package:ridobiko/screens/rental/Profile.dart';
import 'package:ridobiko/screens/rental/SearchScreen.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/screens/rental/widgets/Spinner.dart';
import 'package:http/http.dart' as http;
import 'package:ridobiko/utils/cred.dart';
import 'package:ridobiko/utils/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ridobiko/providers/provider.dart';
import 'MyHomePage.dart';

// ignore: must_be_immutable
class Booking extends ConsumerStatefulWidget {
  BikeData? data = BikeData();
  Booking(this.data, {super.key});
  Booking.withoutData({super.key});
  @override
  ConsumerState<Booking> createState() => _BookingState();
}

class _BookingState extends ConsumerState<Booking> {
  bool isloading = true;
  bool payFull = true;
  bool value = false;
  late BikeData data;
  late double totalGST;
  final _razorpay = Razorpay();
  var amount = 0.0;
  var _helmetCharge = 0;

  bool _helmet1Selected = true;
  bool _helmet2Selected = false;
  var _depostiCheck = false;
  var _termsCheck = false;
  var valueDeposit = false;
  // ignore: non_constant_identifier_names
  var order_id = '';
  // ignore: prefer_final_fields
  String _pamentMode = '';
  bool _pb = false;

  int couponIndex = 0;
  List<CouponModel> couponsList = [];
  bool couponSelected = false;
  double netPayable = 0;
  double discount = 0;

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getCoupons();
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
    request.body =
        json.encode({"amount": amount.toInt().toString(), "currency": "INR"});
    request.headers.addAll(headers);
    // ignore: unused_local_variable
    http.StreamedResponse response2 = await request.send();
    setState(() {
      _pb = true;
    });
    if (BookingFlow.selectedBikeSubs != null) {
      _createTripSubs();
    } else {
      _createTrip();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Toast(context, "Failed to create the trip");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Toast(context, 'Extenalwallet');
  }

  @override
  Widget build(BuildContext context) {
    totalGST = ref.watch(gstProvider.notifier).getGSTPercentage;
    if (kDebugMode) {
      print('Total GST in build method: $totalGST');
    }
    data = widget.data!;
    if (BookingFlow.selectedBikeSubs != null) {
      var subsData = BookingFlow.selectedBikeSubs!;
      data = BikeData();
      data.bikeName = subsData.bikeName;
      data.bikeImage = subsData.bikeImage;
      data.bikeId = subsData.bikeId;
      data.vendorEmailId = subsData.vendorEmailId;
      if (BookingFlow.duration == '1') {
        data.actualRent = subsData.rent1Month;
      } else if (BookingFlow.duration == '2') {
        data.actualRent = subsData.rent2Month!;
      } else if (BookingFlow.duration == '3') {
        data.actualRent = subsData.rent3Month!;
      } else if (BookingFlow.duration == '6') {
        data.actualRent = subsData.rent6Month!;
      } else if (BookingFlow.duration == '12') {
        data.actualRent = subsData.rent12Month!;
      }
      data.locality = subsData.locality;
      data.kmLimit = subsData.kmLimitMonth ?? "";
      data.deposit = subsData.deposit ?? "";
      data.speedLimit = subsData.speedLimit ?? "";
      data.helmetAdditional = subsData.helmetAdditional ?? "";
      data.helmetCharge = subsData.helmetCharge ?? "";
    }

    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    // _createTripSubs();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                      (route) => false);
                },
                child: const Icon(
                  Icons.home,
                  size: 28,
                )),
          ),
          PopupMenuButton<int>(
            enabled: true,
            onSelected: (value) {
              if (value == 1) {
                launchUrlString('${Constants().url}Terms.php');
              } else if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BikePolicies()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                padding: const EdgeInsets.all(10),
                value: 1,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Policies",
                        style: TextStyle(fontSize: 14 / scaleFactor))),
              ),
              PopupMenuItem(
                padding: const EdgeInsets.all(10),
                value: 2,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Bike Policies",
                        style: TextStyle(fontSize: 14 / scaleFactor))),
              ),
            ],
            offset: const Offset(0, 10),
            elevation: 5,
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(139, 0, 0, 1),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(children: [
        Container(
          // padding: EdgeInsets.only(right: 10,left: 10),
          margin: const EdgeInsets.only(bottom: 60),
          color: Colors.grey[200],
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(children: [
                  Container(
                    alignment: Alignment.topCenter,
                    height: 300,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              data.bikeName!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25 / scaleFactor,
                                  fontWeight: FontWeight.bold),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.black54,
                            ),
                            Text(
                              ' Area :',
                              style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  color: Colors.grey[400]),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Flexible(
                              child: Text(
                                ' ${data.locality}',
                                style: TextStyle(
                                    fontSize: 14 / scaleFactor,
                                    color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Image.network(
                              data.bikeImage!,
                              height: 130,
                              errorBuilder: (c, o, s) {
                                return Image.network(
                                  '${Constants().url}images/default.png',
                                  height: 100,
                                );
                              },
                            )),
                      ],
                    ),
                  ),
                  Card(
                    margin:
                        const EdgeInsets.only(top: 260, right: 10, left: 10),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    // color: Colors.white,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      // height: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Km Limit',
                                    style: TextStyle(
                                        color:
                                            const Color.fromRGBO(139, 0, 0, 1),
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${data.kmLimit!} Km",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Speed Limit',
                                    style: TextStyle(
                                        color:
                                            const Color.fromRGBO(139, 0, 0, 1),
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '${data.speedLimit} kmh',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Deposit',
                                    style: TextStyle(
                                        color:
                                            const Color.fromRGBO(139, 0, 0, 1),
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '₹ ${data.deposit}',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Extra KM Cost',
                                    style: TextStyle(
                                        color:
                                            const Color.fromRGBO(139, 0, 0, 1),
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '₹${data.extraKM}',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14 / scaleFactor,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Helmets',
                                style: TextStyle(
                                    fontSize: 15 / scaleFactor,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(139, 0, 0, 1)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _helmet1Selected = true;
                                  _helmet2Selected = false;
                                  _helmetCharge = 0;
                                  setState(() {});
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: _helmet1Selected
                                            ? const Color.fromRGBO(139, 0, 0, 1)
                                            : Colors.grey[400],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        '01',
                                        style: TextStyle(
                                            fontSize: 14 / scaleFactor,
                                            color: _helmet1Selected
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _helmet2Selected = true;
                                  _helmet1Selected = false;
                                  if (data.helmetAdditional == '1' ||
                                      data.helmetAdditional == 'Y') {
                                    if (kDebugMode) {
                                      print(data.helmetCharge);
                                    }
                                    _helmetCharge =
                                        int.parse(data.helmetCharge!);
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: _helmet2Selected
                                          ? const Color.fromRGBO(139, 0, 0, 1)
                                          : Colors.grey[400],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      '02',
                                      style: TextStyle(
                                          fontSize: 14 / scaleFactor,
                                          color: _helmet2Selected
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500),
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
                ]),
                const SizedBox(height: 20),
                if (couponsList.isNotEmpty)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            const Flexible(child: Divider(thickness: 1)),
                            Text(
                              ' SAVING CORNER ',
                              style: TextStyle(
                                  fontSize: 14 / scaleFactor, letterSpacing: 3),
                            ),
                            const Flexible(child: Divider(thickness: 1)),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 10,
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          child: SizedBox(
                            child: ListTile(
                              minLeadingWidth: 0,
                              contentPadding: const EdgeInsets.all(0),
                              visualDensity: const VisualDensity(
                                  vertical: -4, horizontal: 0),
                              leading: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Icon(
                                  couponSelected
                                      ? Icons.discount
                                      : Icons.discount_outlined,
                                  color: couponSelected ? Colors.green : null,
                                  size: 25,
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Save ${couponsList[couponIndex].amount.toString().contains('%') ? '' : '₹'}${couponsList[couponIndex].amount} on this order',
                                        style: TextStyle(
                                            fontSize: 14 / scaleFactor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Code : ${couponsList[couponIndex].coupon.toUpperCase()}',
                                        style: TextStyle(
                                            fontSize: 14 / scaleFactor,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            var selected =
                                                couponsList[couponIndex];
                                            bool isAppicable = true;
                                            if (selected.used >=
                                                selected.maxCount) {
                                              isAppicable = false;
                                            }
                                            double rent = double.parse(
                                                    data.actualRent ?? '0') +
                                                _helmetCharge;
                                            if (selected.startPrice > rent) {
                                              isAppicable = false;
                                            }
                                            if (!isAppicable) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Offer Not Applicable')));
                                              return;
                                            }
                                            couponSelected = !couponSelected;
                                            if (couponSelected) {
                                              if (selected.amount > rent) {
                                                discount = rent;
                                              } else {
                                                discount = selected.amount;
                                              }
                                              netPayable = rent - discount;
                                            } else {
                                              discount = 0;
                                              netPayable = rent;
                                            }
                                            setState(() {});
                                            if (couponSelected) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                      milliseconds: 1500),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 100,
                                                      horizontal: 40),
                                                  elevation: 20,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  content: SizedBox(
                                                    height: 150,
                                                    width: 200,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Image.asset(
                                                              'assets/images/coupon.jpg'),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          'COUPON APPLIED',
                                                          style: GoogleFonts
                                                              .fredoka(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.blueGrey,
                                                            fontSize: 20 /
                                                                scaleFactor,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          'You saved ${couponsList[couponIndex].amount.toString().contains('%') ? '' : '₹'}${couponsList[couponIndex].amount}',
                                                          style: GoogleFonts
                                                              .fredoka(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.green,
                                                            fontSize: 20 /
                                                                scaleFactor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(
                                            couponSelected ? 'REMOVE' : 'APPLY',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14 / scaleFactor,
                                                color: Colors.red),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          'VIEW MORE',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12 / scaleFactor,
                                              color: const Color.fromARGB(
                                                  255, 158, 158, 158)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                if (couponsList.isNotEmpty) {
                                  int val = await Navigator.push(
                                        context,
                                        PageTransition(
                                          child: CouponScreen(couponsList),
                                          childCurrent: widget,
                                          type: PageTransitionType.rightToLeft,
                                          duration:
                                              const Duration(milliseconds: 600),
                                          alignment: Alignment.center,
                                        ),
                                      ) ??
                                      -1;
                                  if (val != couponIndex && val != -1) {
                                    setState(() {
                                      couponIndex = val;
                                      couponSelected = false;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      const Flexible(child: Divider(thickness: 1)),
                      Text(
                        ' BILL SUMMARY ',
                        style: TextStyle(
                            fontSize: 14 / scaleFactor, letterSpacing: 4),
                      ),
                      const Flexible(child: Divider(thickness: 1)),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 10,
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18 / scaleFactor),
                                  ),
                                  Text(
                                    'include Base fee and Helmet charge',
                                    style: TextStyle(
                                        fontSize: 14 / scaleFactor,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              Builder(builder: (context) {
                                return Text(
                                  '₹${int.parse(data.actualRent!) + _helmetCharge}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18 / scaleFactor),
                                );
                              }),
                            ],
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final gstObject = ref.read(gstProvider);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    Widget tile(String title, String value) =>
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16 / scaleFactor,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                                Text(
                                                  '$value%',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16 / scaleFactor,
                                                    color: Colors.black
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'GST Summary',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18 / scaleFactor),
                                          ),
                                          if (gstObject.isGSTApplicable)
                                            tile(
                                                'GST',
                                                gstObject.gst
                                                    .toInt()
                                                    .toString()),
                                          if (gstObject.isCGSTApplicable)
                                            tile(
                                                'CGST',
                                                gstObject.cgst
                                                    .toInt()
                                                    .toString()),
                                          if (gstObject.isSGSTApplicable)
                                            tile(
                                                'SGST',
                                                gstObject.sgst
                                                    .toInt()
                                                    .toString()),
                                          GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'OKAY',
                                                  style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.badge_rounded,
                                      size: 16,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'GST',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16 / scaleFactor,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.info_outline_rounded,
                                      size: 16,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                    const Spacer(),
                                    Builder(builder: (context) {
                                      var gst = (int.parse(data.actualRent!) +
                                              _helmetCharge -
                                              (couponSelected ? discount : 0)) *
                                          (totalGST / 100.0);
                                      return Text(
                                        '₹${gst.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16 / scaleFactor,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Visibility(
                          visible: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delivery_dining,
                                  size: 18,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Delivery fee',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16 / scaleFactor,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Visibility(
                                  visible: false,
                                  child: Icon(
                                    Icons.info_outline_rounded,
                                    size: 16,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '₹0',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16 / scaleFactor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(thickness: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Grand Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16 / scaleFactor),
                              ),
                              Builder(builder: (context) {
                                final grandTotal =
                                    (double.parse(data.actualRent!) +
                                            _helmetCharge) *
                                        (1 + (totalGST / 100.0));
                                return Text(
                                  '₹${grandTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16 / scaleFactor),
                                );
                              }),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: couponSelected,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Coupon',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16 / scaleFactor,
                                      color: Colors.green),
                                ),
                                Text(
                                  '- ₹${discount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16 / scaleFactor,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: couponSelected,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Net Payable',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16 / scaleFactor),
                                ),
                                Builder(builder: (context) {
                                  final netPayable =
                                      (int.parse(data.actualRent!) +
                                              _helmetCharge -
                                              (couponSelected ? discount : 0)) *
                                          (1 + (totalGST / 100.0));
                                  return Text(
                                    '₹ ${netPayable.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16 / scaleFactor),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 10, bottom: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Terms & conditions',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 25 / scaleFactor),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                  child: Spinner(text: "t&c"),
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        value: _depostiCheck,
                        // ignore: avoid_types_as_parameter_names
                        onChanged: (num) {
                          _depostiCheck = num!;
                          setState(() {});
                        }),
                    Text(
                        "Security deposit amount need to be \nadded in wallet during pickup",
                        style: TextStyle(fontSize: 14 / scaleFactor))
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      value: _termsCheck,
                      onChanged: (val) {
                        _termsCheck = val!;
                        setState(() {});
                      },
                    ),
                    Text("I have read and accept all ",
                        style: TextStyle(fontSize: 14 / scaleFactor)),
                    GestureDetector(
                      onTap: () {
                        launchUrlString("${Constants().url}Terms.php");
                      },
                      child: Text(
                        "Term & Conditions",
                        style: TextStyle(
                          fontSize: 14 / scaleFactor,
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
        // if (false)
        Positioned(
          bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: Builder(builder: (context) {
            return StatefulBuilder(
              builder: (context, newState) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  height: 80,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: DropdownButton(
                            isExpanded: true,
                            value: payFull ? 0 : 1,
                            items: [
                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                  'Pay Now',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14 / scaleFactor,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Pay 20%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14 / scaleFactor,
                                    )),
                              ),
                            ],
                            onChanged: (value) =>
                                newState(() => payFull = value == 0),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: !isloading && _depostiCheck && _termsCheck
                                  ? Colors.transparent
                                  : Colors.redAccent,
                            ),
                          ),
                          color: !isloading && _depostiCheck && _termsCheck
                              ? Colors.redAccent
                              : Colors.white,
                          child: ListTile(
                            onTap: () async {
                              if (isloading) return;
                              if (!_termsCheck) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please check terms and conditions first.')));
                                return;
                              }
                              if (!_depostiCheck) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Please check security deposit section.')));
                                return;
                              }
                              _pay();
                            },
                            visualDensity: const VisualDensity(vertical: -3),
                            title: Builder(builder: (context) {
                              var netPayable = (int.parse(data.actualRent!) +
                                      _helmetCharge -
                                      (couponSelected ? discount : 0)) *
                                  (1 + (totalGST / 100.0)) *
                                  (payFull ? 1 : 0.2);
                              return Text(
                                '₹${netPayable.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  color:
                                      !isloading && _depostiCheck && _termsCheck
                                          ? Colors.white
                                          : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }),
                            subtitle: Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                  color:
                                      !isloading && _depostiCheck && _termsCheck
                                          ? Colors.white
                                          : Colors.red),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Payment',
                                  style: TextStyle(
                                    fontSize: 16 / scaleFactor,
                                    color: !isloading &&
                                            _depostiCheck &&
                                            _termsCheck
                                        ? Colors.white
                                        : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color:
                                      !isloading && _depostiCheck && _termsCheck
                                          ? Colors.white
                                          : Colors.red,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ]),
    );
  }

  bool paid20 = false;

  Future<void> _pay() async {
    double subtotal = double.parse(data.actualRent!) + _helmetCharge;
    double base = subtotal - (couponSelected ? discount : 0);
    double gst = base * (totalGST / 100.0);
    double total = base + gst;

    final amountPaid = payFull ? subtotal : subtotal * 0.2;
    final amountLeft = subtotal - amountPaid;

    final amountPaidActual = payFull ? total : total * 0.2;
    //final amountLeftActual = total - amountPaid;

    final gstPaid = payFull ? gst : gst * 0.2;
    var payInPaisa = amountPaidActual * 100;

    String payInString = payInPaisa.toStringAsFixed(2);
    if (payInString.contains('.')) {
      payInString = payInString.substring(0, payInString.indexOf('.'));
    }
    if (kDebugMode) {
      print(payInString);
    }
    var name = ref.read(userProvider)!.firstname;
    var phone = ref.read(userProvider)!.mobile;
    var email = ref.read(userProvider)!.email;
    order_id =
        '${DateFormat('ydM').format(DateTime.now())}${Random().nextInt(6000) + 2000}';
    if (BookingFlow.selectedBikeSubs != null) {
      order_id += 'M1';
    }

    var customerDetail =
        "{'customer_email_id': '$email','customer_name': '$name','customer_mobile': '$phone','web': '2', 'gst': '${gstPaid.toStringAsFixed(2)}', 'helmet': '$_helmetCharge'}";
    var bookingDetail = BookingFlow.selectedBikeSubs != null
        ? "{'bikes_id': '${data.bikeId}','rent': '${data.actualRent}','pickup_date': '${BookingFlow.pickup_date}','month': '${BookingFlow.duration}','vendor_email_id': '${data.vendorEmailId}','amount_left': '${amountLeft.toStringAsFixed(2)}','amount_paid': '${amountPaid.toStringAsFixed(2)}'}"
        : "{'bikes_id': '${data.bikeId}','rent': '${data.actualRent}','pickup_date': '${BookingFlow.pickup_date}','drop_date': '${BookingFlow.drop_date}','vendor_email_id': '${data.vendorEmailId}','amount_left': '${amountLeft.toStringAsFixed(2)}','amount_paid': '${amountPaid.toStringAsFixed(2)}'}";
    var paymentDetail =
        "{'trans_id': '$order_id','payment_mode': '$_pamentMode','booking': 'payment done','ridobiko_points_used': '0','discount': '${couponSelected ? discount : '0'}','coupon_code': '${couponSelected ? couponsList[couponIndex].coupon : ''}'}";
    var homeDelivery =
        "{'homedelivery_contact_name': '','homedelivery_house_no': '','homedelivery_landmark': '','homedelivery_area': '','homedelivery_latitude': '','homedelivery_longitude': '','homedelivery_delivery_location': ''}";
    var options = {
      'key': Cred().razorpayKey,
      // 'amount': '${true ? total : payInString}',
      'amount': payInString,
      'name': 'Ridobiko Solutios Pvt. Ltd.',
      'description': 'Pay ${payFull ? '100%' : '20%'} for ${data.bikeName}',
      "status": "processed",
      'image': data.bikeImage,
      'prefill': {'contact': phone, 'email': email, 'name': name},
      'notes': {
        'customerDetail': customerDetail,
        'bookingDetail': bookingDetail,
        'paymentDetail': paymentDetail,
        'homedelivery': homeDelivery,
        'merchant_order_id': order_id,
        'type': BookingFlow.selectedBikeSubs != null ? 2 : 1,
        'customer_mobile': phone,
      }
    };
    _razorpay.open(options);
  }

  void _createTrip() async {
    double subtotal = double.parse(data.actualRent!) + _helmetCharge;
    double base = subtotal + (couponSelected ? discount : 0);
    double gst = base * (totalGST / 100.0);
    double total = base + gst;

    final amountPaid = payFull ? subtotal : subtotal * 0.2;
    final amountLeft = subtotal - amountPaid;
    final gstPaid = payFull ? gst : gst * 0.2;
    var payInPaisa = total * 100;
    String payInString = payInPaisa.toStringAsFixed(2);
    if (payInString.contains('.')) {
      payInString = payInString.substring(0, payInString.indexOf('.'));
    }
    var name = ref.read(userProvider)!.firstname;
    var phone = ref.read(userProvider)!.mobile;
    var email = ref.read(userProvider)!.email;
    var token = ref.read(userProvider)!.token!;
    var call = await http.post(
        Uri.parse('${Constants().url}android_app_customer/api/createTrip.php'),
        body: {
          'bookedon': DateTime.now().toString(),
          'pickup_date': BookingFlow.pickup_date,
          'drop_date': BookingFlow.drop_date,
          'trans_id': order_id,
          'vendor_email_id': data.vendorEmailId,
          'customer_email_id': email,
          'customer_name': name,
          'web': '2',
          'customer_mobile': phone,
          'bikes_id': data.bikeId,
          'rent': data.actualRent,
          'gst': gstPaid.toStringAsFixed(2),
          'helmet_charge': _helmetCharge.toString(),
          'payment_mode': _pamentMode,
          'amount_left': amountLeft.toStringAsFixed(2),
          'amount_paid': amountPaid.toStringAsFixed(2),
          'booking': 'payment done',
          'ridobiko_points_used': '0',
          'discount': '${couponSelected ? discount : '0'}',
          'coupon_code': couponSelected ? couponsList[couponIndex].coupon : '',
          'homedelivery_contact_name': '',
          'homedelivery_house_no': '',
          'homedelivery_landmark': '',
          'homedelivery_area': '',
          'homedelivery_latitude': '',
          'homedelivery_longitude': '',
          'homedelivery_delivery_location': '',
        },
        headers: {
          'token': token,
        });
    var response = jsonDecode(call.body);
    if (response['success']) {
      if (kDebugMode) {
        print('working');
      }
      _openPostBooking();
    } else {
      if (kDebugMode) {
        print('failed');
      }
    }
    Toast(context, '${response['message']}');
  }

  void _createTripSubs() async {
    double subtotal = double.parse(data.actualRent!) + _helmetCharge;
    double base = subtotal + (couponSelected ? discount : 0);
    double gst = base * (totalGST / 100.0);
    double total = base + gst;

    final amountPaid = payFull ? subtotal : subtotal * 0.2;
    final amountLeft = subtotal - amountPaid;
    final gstPaid = payFull ? gst : gst * 0.2;
    var payInPaisa = total * 100;
    String payInString = payInPaisa.toStringAsFixed(2);
    if (payInString.contains('.')) {
      payInString = payInString.substring(0, payInString.indexOf('.'));
    }

    var name = ref.read(userProvider)!.firstname;
    var phone = ref.read(userProvider)!.mobile;
    var email = ref.read(userProvider)!.email;
    var token = ref.read(userProvider)!.token!;
    // final val = int.parse(data.actualRent!) + _helmetCharge;
    // var dropDate =
    //     DateTime.parse(BookingFlow.pickup_date!).add(const Duration(days: 30));
    var call = await http.post(
        Uri.parse(
            '${Constants().url}android_app_customer/api/createSubscriptionTrip.php'),
        body: {
          'pickup_date': BookingFlow.pickup_date,
          'month': BookingFlow.duration.toString(),
          'trans_id': order_id,
          'vendor_email_id': data.vendorEmailId,
          'customer_email_id': email,
          'customer_name': name,
          'web': '2',
          'customer_mobile': phone,
          'bikes_id': data.bikeId,
          'gst': gstPaid.toStringAsFixed(2),
          'helmet_charge': _helmetCharge.toString(),
          'rent': data.actualRent,
          'payment_mode': _pamentMode,
          // 'amount_left': '$_amountLeft',
          // 'amount_paid': '$_amountPaid',
          'amount_left': amountLeft.toStringAsFixed(2),
          'amount_paid': amountPaid.toStringAsFixed(2),
          'booking': 'payment done',
          'ridobiko_points_used': '0',
          'discount': '${couponSelected ? discount : '0'}',
          'coupon_code': couponSelected ? couponsList[couponIndex].coupon : '',
          'homedelivery_contact_name': '',
          'homedelivery_house_no': '',
          'homedelivery_landmark': '',
          'homedelivery_area': '',
          'homedelivery_latitude': '',
          'homedelivery_longitude': '',
          'homedelivery_delivery_location': '',
        },
        headers: {
          'token': token,
        });
    var response = jsonDecode(call.body);
    if (response['success']) {
      setState(() {
        _pb = false;
      });
      _openPostBooking();
    }
    Toast(context, '${response['message']}');
  }

  Future<void> createTripSubs2(int itr) async {
    order_id =
        '${DateFormat('ydM').format(DateTime.now())}${Random().nextInt(6000) + 2000}';
    if (BookingFlow.selectedBikeSubs != null) {
      if (BookingFlow.duration == '1') {
        order_id += 'M1';
      } else if (BookingFlow.duration == '2') {
        order_id += 'M2';
      } else if (BookingFlow.duration == '3') {
        order_id += 'M3';
      } else if (BookingFlow.duration == '6') {
        order_id += 'M6';
      } else if (BookingFlow.duration == '12') {
        order_id += 'M12';
      }
    }
    var name = ref.read(userProvider)!.firstname;
    var phone = ref.read(userProvider)!.mobile;
    var email = ref.read(userProvider)!.email;
    var token = ref.read(userProvider)!.token!;
    var pickupDate =
        DateTime.parse(BookingFlow.pickup_date!).add(Duration(days: itr * 31));
    var dropDate = DateTime.parse(BookingFlow.pickup_date!)
        .add(Duration(days: (itr + 1) * 30));
    var call = await http.post(
        Uri.parse('${Constants().url}android_app_customer/api/createTrip.php'),
        body: {
          'bookedon': DateTime.now().toString(),
          'pickup_date': pickupDate.toString(),
          'drop_date': dropDate.toString(),
          'trans_id': order_id,
          'vendor_email_id': data.vendorEmailId,
          'customer_email_id': email,
          'customer_name': name,
          'web': '2',
          'customer_mobile': phone,
          'bikes_id': data.bikeId,
          'rent': data.actualRent,
          'payment_mode': 'NA',
          'amount_left': '${data.actualRent}',
          'amount_paid': '0',
          'booking': 'payment not done',
          'ridobiko_points_used': '0',
          'discount': '${couponSelected ? discount : '0'}',
          'coupon_code': couponSelected ? couponsList[couponIndex].coupon : '',
          'homedelivery_contact_name': '',
          'homedelivery_house_no': '',
          'homedelivery_landmark': '',
          'homedelivery_area': '',
          'homedelivery_latitude': '',
          'homedelivery_longitude': '',
          'homedelivery_delivery_location': '',
        },
        headers: {
          'token': token,
        });
    var response = jsonDecode(call.body);
    if (response['success']) {}
  }

  void _openPostBooking() {
    Navigator.push(context,
        MaterialPageRoute(builder: (builder) => const ProfileVerify()));
  }

  Future<void> getCoupons() async {
    var token = ref.read(userProvider)!.token;
    try {
      var res = await http.post(
        Uri.parse('${Constants().url}android_app_customer/api/getCoupons.php'),
        headers: {
          'token': token!,
        },
        body: {
          'city': BookingFlow.city,
        },
      );
      if (kDebugMode) {
        print("########## Coupun Data : : ${res.body}");
      }
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body)['data'] as List;
        couponsList = [];
        for (var entry in data) {
          couponsList.add(CouponModel.fromMap(entry));
        }
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      isloading = false;
    });
  }
}
