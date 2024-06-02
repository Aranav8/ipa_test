// ignore_for_file: camel_case_types, file_names, avoid_renaming_method_parameters

import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ridobiko/screens/bookings/PDF.dart';
import 'package:ridobiko/screens/bookings/SelfDrop.dart';
import 'package:ridobiko/screens/bookings/SelfPickup.dart';
import 'package:ridobiko/screens/bookings/VehicleDocuments.dart';
import 'package:ridobiko/screens/bookings/ViewUploadImages.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';

String? bookingdatevalue;
String? pickupdatevalue;
String? dropdatevalue;
String? invoiceorderno;

class MoreDetails extends StatefulWidget {
  const MoreDetails({super.key});

  @override
  State<StatefulWidget> createState() {
    return moreDetails();
  }
}

class moreDetails extends State {
  late BookingData data;
  BikeData? bookingflow = BikeData();
  var _selfPickup = false;
  var _dropVisible = false;
  bool _uploadedImages = false;
  String? gstamount;
  @override
  void initState() {
    data = BookingFlow.selectedBooking!;
    if (kDebugMode) {
      print(data.invoices);
    }
    calctime();
    if (data.adminStatus!.toLowerCase() == 'confirmed' &&
        data.tripDetails!.orderId == "") {
      _selfPickup = true;
    }
    if (data.tripPictures!.bikeFrontDrop!.contains('default')) {
      _dropVisible = false;
    }
    if (data.adminStatus!.toLowerCase() == 'confirmed' &&
        data.tripDetails!.orderId != "") {
      _uploadedImages = true;
    }
    setState(() {});
    data.tripDetails ??= TripDetails.fromJson(jsonDecode('{}'));

    bookingdatevalue = "";
    for (int i = 0; i < data.bookedon!.length; i++) {
      if (data.bookedon![i] != ' ') {
        bookingdatevalue = (bookingdatevalue! + data.bookedon![i].toString());
      } else {
        break;
      }
    }

    pickupdatevalue = "";
    for (int i = 0; i < data.pickupDate!.length; i++) {
      if (data.pickupDate![i] != ' ') {
        pickupdatevalue = (pickupdatevalue! + data.pickupDate![i].toString());
      } else {
        break;
      }
    }

    dropdatevalue = "";
    for (int i = 0; i < data.dropDate!.length; i++) {
      if (data.dropDate![i] != ' ') {
        dropdatevalue = (dropdatevalue! + data.dropDate![i].toString());
      } else {
        break;
      }
    }
    invoiceorderno = "";
    for (int i = 0; i < data.transId!.length; i++) {
      if (data.transId![i] != '/') {
        invoiceorderno = invoiceorderno! + data.transId![i];
      }
    }
    var gstpercent = 18;
    if (gstpercent == 0) {
      gstamount = '-';
    } else {
      gstamount =
          (int.parse(data.rent!) + (int.parse(data.rent!) * gstpercent) / 100)
              .toString();
    }
    super.initState();
  }

  var pickuptime = DateTime.now().microsecondsSinceEpoch;
  var droptime = DateTime.now().microsecondsSinceEpoch;
  var nowtime = DateTime.now().microsecondsSinceEpoch;

  void calctime() {
    if (data.pickupDate != null) {
      pickuptime = DateFormat('dd-MM-yyyy hh:mm')
          .parse(data.pickupDate!)
          .microsecondsSinceEpoch;
    }
    if (data.dropDate != null) {
      droptime = DateFormat('dd-MM-yyyy hh:mm')
          .parse(data.dropDate!)
          .microsecondsSinceEpoch;
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<int>(
            enabled: true,
            onSelected: (value) {
              if (value == 1) {
                launchUrlString('https://www.ridobiko.com/Terms.php');
              } else if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewImgaes()),
                );
              } else if (value == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VehicleDocuments(data.vehicleDocument),
                  ),
                );
              } else if (value == 4) {
                if (kDebugMode) {
                  print(data.invoices.runtimeType);
                }
                if (data.invoices is! List || data.invoices == []) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No invoice found')));
                } else {
                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PDF(data.invoices)),
                    );
                  } on Exception catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                }
              }
            },
            itemBuilder: (builder) => [
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
                enabled: _uploadedImages,
                value: 2,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("View uploaded images",
                        style: TextStyle(fontSize: 14 / scaleFactor))),
              ),
              PopupMenuItem(
                enabled: pickuptime < nowtime && droptime > nowtime,
                padding: const EdgeInsets.all(10),
                value: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Vehicle Documents",
                      style: TextStyle(fontSize: 14 / scaleFactor)),
                ),
              ),
              PopupMenuItem(
                padding: const EdgeInsets.all(10),
                value: 4,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("View Invoice",
                      style: TextStyle(fontSize: 14 / scaleFactor)),
                ),
                onTap: () async {},
              ),
            ],
            offset: const Offset(0, 10),
            color: Colors.white,
            elevation: 5,
          ),
        ],
        elevation: 0,
        backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: 300,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                data.bikeName!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25 / scaleFactor,
                                    fontWeight: FontWeight.bold),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 20,
                                color: Colors.black54,
                              ),
                              Text(
                                ', Area:',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14 / scaleFactor),
                              ),
                              Text(
                                data.vendorDetails!.formArea ?? "",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14 / scaleFactor),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: CachedNetworkImage(
                              imageUrl: data.bikeImage!,
                              width: 150,
                              errorWidget: (a, b, c) => Image.network(
                                'https://www.ridobiko.com/images/default.png',
                                height: 150,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin:
                          const EdgeInsets.only(top: 250, right: 10, left: 10),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      // color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, right: 30, left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Duration',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18 / scaleFactor),
                                )),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "${max(DateTime.parse(data.dropDate!.split(" ")[0].split('-')[2] + data.dropDate!.split(" ")[0].split('-')[1] + data.dropDate!.split(" ")[0].split('-')[0]).difference(DateTime.parse(data.pickupDate!.split(" ")[0].split('-')[2] + data.pickupDate!.split(" ")[0].split('-')[1] + data.pickupDate!.split(" ")[0].split('-')[0])).inDays, 1)} Days",
                                          style: TextStyle(
                                              fontSize: 18 / scaleFactor,
                                              color: Colors.black),
                                        )))
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Quantity',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18 / scaleFactor),
                                )),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '1',
                                          style: TextStyle(
                                              fontSize: 18 / scaleFactor,
                                              color: Colors.black),
                                        )))
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Rent',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18 / scaleFactor),
                                )),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '₹ ${data.rent!}',
                                          style: TextStyle(
                                              fontSize: 18 / scaleFactor,
                                              color: Colors.black),
                                        )))
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Total',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18 / scaleFactor,
                                      fontWeight: FontWeight.bold),
                                )),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '₹ ${data.rent!}',
                                          style: TextStyle(
                                              fontSize: 18 / scaleFactor,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                'Inclusive of taxes & insurance',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15 / scaleFactor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: data.adminStatus!.toLowerCase() == 'confirmed',
                    child: Card(
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 10,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.person,
                              size: 30,
                              color: Color.fromRGBO(139, 0, 0, 1),
                            ),
                            // SizedBox(width: 10,),
                            Text(data.vendorDetails!.name!,
                                style: TextStyle(fontSize: 14 / scaleFactor)),

                            // SizedBox(width: 20,),
                            GestureDetector(
                                onTap: () async {
                                  var url = Uri.parse(
                                      "tel:+91${data.vendorDetails!.mobile}");
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Image.asset(
                                  "assets/images/btncall.png",
                                  height: 30,
                                )),
                            // SizedBox(width: 10,),
                            Text(data.vendorDetails!.mobile!,
                                style: TextStyle(fontSize: 14 / scaleFactor)),

                            // SizedBox(width: 20,),
                            GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(
                                      data.vendorDetails!.mapAddress!));
                                },
                                child: Image.asset(
                                  "assets/images/google.png",
                                  height: 30,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: _selfPickup,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SelfPickup()));
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
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Self Pickup",
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
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Visibility(
                            visible: _dropVisible,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SelfDrop()));
                              },
                              child: Card(
                                elevation: 5,
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color.fromRGBO(139, 0, 0, 1),
                                            Colors.red[200]!
                                          ])),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Self Drop",
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
                      Visibility(
                        visible: _uploadedImages,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImgaes()),
                            );
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
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "View Uploaded Images",
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
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
