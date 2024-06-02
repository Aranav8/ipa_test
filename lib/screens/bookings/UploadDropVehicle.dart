// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridobiko/controllers/bookings/booking_controller.dart';
import 'package:ridobiko/screens/bookings/UploadHelmetDropImg.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:ridobiko/data/self_drop_data.dart';

import '../../data/BookingFlow.dart';

class UploadDropVehicle extends ConsumerStatefulWidget {
  const UploadDropVehicle({Key? key}) : super(key: key);

  @override
  ConsumerState<UploadDropVehicle> createState() => _UploadDropVehicleState();
}

class _UploadDropVehicleState extends ConsumerState<UploadDropVehicle> {
  BookingData data = BookingFlow.selectedBooking!;
  final _kmReading = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          // title: Align(alignment: Alignment.centerRight,child: Text('STEP 2/3',style: TextStyle(color: Colors.grey,fontSize: 15))),
          backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Card(
                margin: const EdgeInsets.all(10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Color.fromRGBO(139, 0, 0, 1), width: 0.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // elevation: 10,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Drop Details",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18 / scaleFactor),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Vehicle Images:",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.grey,
                                fontSize: 15 / scaleFactor),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 100,
                                  width: 100,
                                  child: GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext build) {
                                              return AlertDialog(
                                                  title: Text(
                                                    "From where do you want to take the photo?",
                                                    style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                    ),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.photo,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Gallery",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData.front =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.gallery);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        ),
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0)),
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Camera",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData.front =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.camera);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            });
                                      },
                                      child: SelfDropData.front == null
                                          ? Image.asset(
                                              "assets/images/Bike Front.png")
                                          : Image.file(
                                              File(SelfDropData.front!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Front",
                                style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 100,
                                  width: 100,
                                  child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext build) {
                                              return AlertDialog(
                                                  title: Text(
                                                    "From where do you want to take the photo?",
                                                    style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                    ),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.photo,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Gallery",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData.back =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.gallery);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        ),
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0)),
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Camera",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData.back =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.camera);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            });
                                      },
                                      child: SelfDropData.back == null
                                          ? Image.asset(
                                              "assets/images/Bike Back.png")
                                          : Image.file(
                                              File(SelfDropData.back!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "back",
                                style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 100,
                                  width: 100,
                                  child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext build) {
                                              return AlertDialog(
                                                  title: Text(
                                                    "From where do you want to take the photo?",
                                                    style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                    ),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.photo,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Gallery",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData.left =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.gallery);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        ),
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0)),
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Camera",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData.left =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.camera);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            });
                                      },
                                      child: SelfDropData.left == null
                                          ? Image.asset(
                                              "assets/images/Bike Right.png",
                                              height: 20,
                                            )
                                          : Image.file(
                                              File(SelfDropData.left!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Right",
                                style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 100,
                                  width: 100,
                                  child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext build) {
                                              return AlertDialog(
                                                  title: Text(
                                                    "From where do you want to take the photo?",
                                                    style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                    ),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.photo,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Gallery",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData.right =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.gallery);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        ),
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0)),
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Camera",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData.right =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.camera);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            });
                                      },
                                      child: SelfDropData.right == null
                                          ? Image.asset(
                                              "assets/images/Bike Left .png",
                                              height: 20,
                                            )
                                          : Image.file(
                                              File(SelfDropData.right!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Left",
                                style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  height: 100,
                                  width: 100,
                                  child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext build) {
                                              return AlertDialog(
                                                  title: Text(
                                                    "From where do you want to take the photo?",
                                                    style: TextStyle(
                                                      fontSize:
                                                          14 / scaleFactor,
                                                    ),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.photo,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Gallery",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData
                                                                    .withCustomer =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.gallery);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        ),
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0)),
                                                        GestureDetector(
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                size: 40,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                "Camera",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData
                                                                    .withCustomer =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.camera);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                build);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            });
                                      },
                                      child: SelfDropData.withCustomer == null
                                          ? Image.asset(
                                              "assets/images/bike meter.png")
                                          : Image.file(File(SelfDropData
                                              .withCustomer!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Photo Meter",
                                style: TextStyle(
                                  fontSize: 14 / scaleFactor,
                                ),
                              )
                            ],
                          ),
                          // Column(
                          //   children: [
                          //     Container(
                          //         padding: EdgeInsets.all(10),
                          //         decoration: BoxDecoration(
                          //             border: Border.all(
                          //                 color: Colors.grey, width: 0.5),
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(10))),
                          //         height: 100,
                          //         width: 100,
                          //         child: GestureDetector(
                          //             onTap: () {
                          //               showDialog(
                          //                   context: context,
                          //                   builder: (BuildContext build) {
                          //                     return AlertDialog(
                          //                         title: Text(
                          //                             "From where do you want to take the photo?"),
                          //                         content:
                          //                             SingleChildScrollView(
                          //                           child: ListBody(
                          //                             children: <Widget>[
                          //                               GestureDetector(
                          //                                 child: Row(
                          //                                   children: [
                          //                                     Icon(
                          //                                       Icons.photo,
                          //                                       size: 40,
                          //                                     ),
                          //                                     SizedBox(
                          //                                       width: 10,
                          //                                     ),
                          //                                     Text("Gallery"),
                          //                                   ],
                          //                                 ),
                          //                                 onTap: () async {
                          //                                   SelfDropData
                          //                                           .fuelMeter =
                          //                                       await ImagePicker()
                          //                                           .pickImage(
                          //                                               source:
                          //                                                   ImageSource.gallery);
                          //                                   setState(() {});
                          //                                   Navigator.pop(
                          //                                       build);
                          //                                 },
                          //                               ),
                          //                               Padding(
                          //                                   padding:
                          //                                       EdgeInsets.all(
                          //                                           8.0)),
                          //                               GestureDetector(
                          //                                 child: Row(
                          //                                   children: [
                          //                                     Icon(
                          //                                       Icons
                          //                                           .camera_alt,
                          //                                       size: 40,
                          //                                     ),
                          //                                     SizedBox(
                          //                                       width: 10,
                          //                                     ),
                          //                                     Text("Camera"),
                          //                                   ],
                          //                                 ),
                          //                                 onTap: () async {
                          //                                   SelfDropData
                          //                                           .fuelMeter =
                          //                                       await ImagePicker()
                          //                                           .pickImage(
                          //                                               source:
                          //                                                   ImageSource.camera);
                          //                                   setState(() {});
                          //                                   Navigator.pop(
                          //                                       build);
                          //                                 },
                          //                               )
                          //                             ],
                          //                           ),
                          //                         ));
                          //                   });
                          //             },
                          //             child: SelfDropData.fuelMeter == null
                          //                 ? Image.asset(
                          //                     "assets/images/Selfie WIth Bike.png")
                          //                 : Image.file(File(
                          //                     SelfDropData.fuelMeter!.path)))),
                          //     SizedBox(
                          //       height: 8,
                          //     ),
                          //     Text("Selfie with bike"),
                          //   ],
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Km reading:",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.grey,
                                fontSize: 15 / scaleFactor),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 100,
                            // padding: EdgeInsets.only(right: 30,left: 30,top: 10,bottom: 10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: TextField(
                                controller: _kmReading,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _calculate();
                            },
                            child: Card(
                              elevation: 5,
                              margin: const EdgeInsets.only(left: 18),
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
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Calculate",
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
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (SelfDropData.extraKmCharge != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadDropHelmet()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'Calculate charges first',
                      style: TextStyle(
                        fontSize: 14 / scaleFactor,
                      ),
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
      ),
    );
  }

  Future<XFile> selectImage() {
    XFile? image;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text("Gallery"),
                      onTap: () async {
                        image = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: const Text("Camera"),
                      onTap: () async {
                        image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                      },
                    )
                  ],
                ),
              ));
        });
    return Future.value(image);
  }

  Future<void> _calculate() async {
    await ref
        .read(bookingControllerProvider.notifier)
        .calculateCharges(context, data, _kmReading.text.trim());

    // var prefs = await SharedPreferences.getInstance();
    // var token = prefs.getString('token') ?? "";
    // var call = await http.post(
    //     Uri.parse(
    //         'https://www.ridobiko.com/android_app_customer/api/getKmCharges.php'),
    //     headers: {
    //       'token': token,
    //     },
    //     body: {
    //       "email": data.vendorEmailId,
    //       "order_id": data.transId,
    //       "bike_id": data.bikesId,
    //       "pickup_date": data.pickupDate,
    //       "drop_date": data.dropDate,
    //       "km_pickup": data.tripDetails?.kMMeterPickup,
    //       "km_drop": _kmReading.text,
    //     });
    // var res = jsonDecode(call.body);
    // if (res['success']) {
    //   SelfDropData.extraKmCharge = res['data']['extra_km_charge'];
    //   SelfDropData.kmAtDrop = _kmReading.text;
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content:
    //           Text('Calculated charge is Rs ${SelfDropData.extraKmCharge!}')));
    // }
    // //print(res);
  }
}
