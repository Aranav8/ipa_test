// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ridobiko/screens/bookings/UploadDropVehicle.dart';

import '../../data/BookingData.dart';
import '../../data/BookingFlow.dart';

class SelfDrop extends StatefulWidget {
  const SelfDrop({Key? key}) : super(key: key);

  @override
  State<SelfDrop> createState() => _SelfDropState();
}

class _SelfDropState extends State<SelfDrop> {
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
                  "SELF DROP",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20 / scaleFactor),
                ),
                const Padding(
                    padding: EdgeInsets.only(
                        right: 30, left: 30, top: 10, bottom: 30),
                    child: Text(
                      "You need to verify your information please submit the data bellow to process your application",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey[200],
                  ),
                  child: Text(
                    "SELF DROP IN 3 SIMPLE STEPS",
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UploadDropVehicle()));
                    },
                    leading: Image.asset("assets/images/NUmber-step-1.png"),
                    title: Text(
                      'Upload Vehicle Images',
                      style: TextStyle(
                          fontSize: 14 / scaleFactor, color: Colors.grey[800]),
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
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadDropHelmet()));
                    },
                    leading: Image.asset("assets/images/NUmber-step-2.png"),
                    title: Text(
                      'Upload Helmet Images',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14 / scaleFactor,
                      ),
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
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>DropPayment()));
                    },
                    leading: Image.asset("assets/images/NUmber-step-3.png"),
                    title: Text(
                      'Pay Dues',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14 / scaleFactor,
                      ),
                    )),
                const SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadDropVehicle()));

                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>DropPayment()));

                    // Navigator.push(context, MaterialPageRoute(builder: (context) =>UploadDropVehicle() ));
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
                              "Proceed To Complete Self Drop",
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
}
