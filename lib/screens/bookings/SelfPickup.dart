// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ridobiko/screens/bookings/PickupPay.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:ridobiko/data/BookingFlow.dart';

class SelfPickup extends StatefulWidget {
  const SelfPickup({Key? key}) : super(key: key);

  @override
  State<SelfPickup> createState() => _SelfPickupState();
}

class _SelfPickupState extends State<SelfPickup> {
  BookingData data = BookingFlow.selectedBooking!;

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          // title: Align(alignment: Alignment.centerRight,child: Text('STEP 2/3',style: TextStyle(color: Colors.grey,fontSize: 15))),
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              })),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: SvgPicture.asset("assets/images/mobile.svg"),
                ),
                Text(
                  "SELF PICKUP",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20 / scaleFactor),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        right: 30, left: 30, top: 10, bottom: 30),
                    child: Text(
                      "You need to verify your information please submit the data bellow to process your application",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey, fontSize: 14 / scaleFactor),
                    )),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                    "SELF PICKUP IN 3 SIMPLE STEPS",
                    style: TextStyle(
                      letterSpacing: 1,
                      color: Colors.black,
                      fontSize: 13 / scaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>PickupPay()));
                    },
                    leading: Image.asset("assets/images/NUmber-step-1.png"),
                    title: Text(
                      'Pay Your Payments',
                      style: TextStyle(
                          color: Colors.grey[800], fontSize: 14 / scaleFactor),
                    )),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadVehicleImg()));
                    },
                    leading: Image.asset("assets/images/NUmber-step-2.png"),
                    title: Text(
                      ' Upload Pickup Details',
                      style: TextStyle(
                          color: Colors.grey[800], fontSize: 14 / scaleFactor),
                    )),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadHelmetImg()));
                    },
                    leading: Image.asset("assets/images/NUmber-step-3.png"),
                    title: Text(
                      'Upload Helmet Images',
                      style: TextStyle(
                          color: Colors.grey[800], fontSize: 14 / scaleFactor),
                    )),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    // _updateDataBase();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PickupPay()));
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
                              "Proceed To Complete  Self Pickup",
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
        ),
      ),
    );
  }

  // Future<void> _updateDataBase() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token') ?? "";
  //   var headers = {'token': token};
  //   var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(
  //           'https://www.ridobiko.com/android_app_customer/api/setSelfPickup.php'));
  //   request.fields.addAll({
  //     'order_id': data.transId!,
  //     'no_of_helmets': data.tripDetails!.noOfHelmets!,
  //     'KM_meter_pickup': data.tripDetails!.kMMeterPickup!,
  //     'destination': data.tripDetails!.destination!,
  //     'purpose': data.tripDetails!.purpose!,
  //     'id_collected': data.tripDetails!.idCollected!,
  //     'fuel_meter_reading': SelfPickupData.kmAtPickup!,
  //   });
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'bike_left', SelfPickupData.left!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'bike_right', SelfPickupData.right!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'bike_front', SelfPickupData.front!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'bike_back', SelfPickupData.back!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'bike_with_customer', SelfPickupData.withCustomer!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'bike_fuel_meter', SelfPickupData.fuelMeter!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'helmet_front_1', SelfPickupData.pickhelmentfront!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'helmet_back_1', SelfPickupData.pickhelmentback!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'helmet_front_2', SelfPickupData.pickhelmentleft!.path));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'helmet_back_2', SelfPickupData.pickhelmentright!.path));
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     //print(await response.stream.bytesToString());
  //   } else {
  //     //print(response.reasonPhrase);
  //   }
  // }
}
