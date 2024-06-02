// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridobiko/screens/bookings/DropPayment.dart';
import 'package:ridobiko/data/BookingFlow.dart';
import 'package:ridobiko/data/self_drop_data.dart';

class UploadDropHelmet extends StatefulWidget {
  const UploadDropHelmet({Key? key}) : super(key: key);

  @override
  State<UploadDropHelmet> createState() => _UploadDropHelmetState();
}

class _UploadDropHelmetState extends State<UploadDropHelmet> {
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
                            "Helmet Images:",
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                                          14 / scaleFactor),
                                                ),
                                                content: SingleChildScrollView(
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
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          SelfDropData
                                                                  .helmentfront =
                                                              await ImagePicker()
                                                                  .pickImage(
                                                                      source: ImageSource
                                                                          .gallery);
                                                          setState(() {});
                                                          Navigator.pop(build);
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
                                                              Icons.camera_alt,
                                                              size: 40,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "Camera",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          SelfDropData
                                                                  .helmentfront =
                                                              await ImagePicker()
                                                                  .pickImage(
                                                                      source: ImageSource
                                                                          .camera);
                                                          setState(() {});
                                                          Navigator.pop(build);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          });
                                    },
                                    child: SelfDropData.helmentfront == null
                                        ? Image.asset(
                                            "assets/images/Helmet Outside.png")
                                        : Image.file(
                                            File(SelfDropData
                                                .helmentfront!.path),
                                          ),
                                  )),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Top",
                                style: TextStyle(fontSize: 14 / scaleFactor),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                                          14 / scaleFactor),
                                                ),
                                                content: SingleChildScrollView(
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
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          SelfDropData
                                                                  .hellmentback =
                                                              await ImagePicker()
                                                                  .pickImage(
                                                                      source: ImageSource
                                                                          .gallery);
                                                          setState(() {});
                                                          Navigator.pop(build);
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
                                                              Icons.camera_alt,
                                                              size: 40,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "Camera",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          SelfDropData
                                                                  .hellmentback =
                                                              await ImagePicker()
                                                                  .pickImage(
                                                                      source: ImageSource
                                                                          .camera);
                                                          setState(() {});
                                                          Navigator.pop(build);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          });
                                    },
                                    child: SelfDropData.hellmentback == null
                                        ? Image.asset(
                                            "assets/images/Helmet Inside.png")
                                        : Image.file(
                                            File(SelfDropData
                                                .hellmentback!.path),
                                          ),
                                  )),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Bottom",
                                style: TextStyle(fontSize: 14 / scaleFactor),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Visibility(
                        visible: BookingFlow
                                .selectedBooking!.tripDetails!.noOfHelmets ==
                            '2',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                                            14 / scaleFactor),
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
                                                                style: TextStyle(
                                                                    fontSize: 14 /
                                                                        scaleFactor),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData
                                                                    .helmentleft =
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
                                                                style: TextStyle(
                                                                    fontSize: 14 /
                                                                        scaleFactor),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData
                                                                    .helmentleft =
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
                                      child: SelfDropData.helmentleft == null
                                          ? Image.asset(
                                              "assets/images/Helmet Outside.png")
                                          : Image.file(
                                              File(SelfDropData
                                                  .helmentleft!.path),
                                            ),
                                    )),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Top",
                                  style: TextStyle(fontSize: 14 / scaleFactor),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                                            14 / scaleFactor),
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
                                                                style: TextStyle(
                                                                    fontSize: 14 /
                                                                        scaleFactor),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData
                                                                    .helmentright =
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
                                                                style: TextStyle(
                                                                    fontSize: 14 /
                                                                        scaleFactor),
                                                              ),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            SelfDropData
                                                                    .helmentright =
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
                                      child: SelfDropData.helmentright == null
                                          ? Image.asset(
                                              "assets/images/Helmet Inside.png")
                                          : Image.file(
                                              File(SelfDropData
                                                  .helmentright!.path),
                                            ),
                                    )),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Bottom",
                                  style: TextStyle(fontSize: 14 / scaleFactor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Row( mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                      //   Container(height: 100,width: 100,child: GestureDetector(
                      //     onTap: (){
                      //       showDialog(
                      //           context: context,
                      //           builder: (BuildContext build) {
                      //             return AlertDialog(
                      //                 title: Text("From where do you want to take the photo?"),
                      //                 content: SingleChildScrollView(
                      //                   child: ListBody(
                      //                     children: <Widget>[
                      //                       GestureDetector(
                      //                         child: Text("Gallery"),
                      //                         onTap: () async {
                      //
                      //                           _drophelmentleft= await ImagePicker().pickImage(source: ImageSource.gallery);
                      //                           setState((){});
                      //                           Navigator.pop(build);
                      //                         },
                      //                       ),
                      //                       Padding(padding: EdgeInsets.all(8.0)),
                      //                       GestureDetector(
                      //                         child: Text("Camera"),
                      //                         onTap: () async {
                      //                           _drophelmentleft= await ImagePicker().pickImage(source: ImageSource.camera);
                      //                           setState((){});
                      //                           Navigator.pop(build);
                      //
                      //                         },
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )
                      //             );
                      //           });
                      //
                      //     },
                      //     child: _drophelmentleft== null?Image.asset("assets/images/img.png"):Image.file(File(_drophelmentleft!.path),),
                      //
                      //   )),
                      //   Container(height: 100,width: 100,child: GestureDetector(
                      //
                      //     onTap: (){
                      //       showDialog(
                      //           context: context,
                      //           builder: (BuildContext build) {
                      //             return AlertDialog(
                      //                 title: Text("From where do you want to take the photo?"),
                      //                 content: SingleChildScrollView(
                      //                   child: ListBody(
                      //                     children: <Widget>[
                      //                       GestureDetector(
                      //                         child: Text("Gallery"),
                      //                         onTap: () async {
                      //
                      //                           _drophelmentright= await ImagePicker().pickImage(source: ImageSource.gallery);
                      //                           setState((){});
                      //                           Navigator.pop(build);
                      //                         },
                      //                       ),
                      //                       Padding(padding: EdgeInsets.all(8.0)),
                      //                       GestureDetector(
                      //                         child: Text("Camera"),
                      //                         onTap: () async {
                      //                           _drophelmentright= await ImagePicker().pickImage(source: ImageSource.camera);
                      //                           setState((){});
                      //                           Navigator.pop(build);
                      //
                      //                         },
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )
                      //             );
                      //           });
                      //
                      //     },
                      //     child: _drophelmentright== null?Image.asset("assets/images/img.png"):Image.file(File(_drophelmentright!.path),),
                      //
                      //
                      //   )),
                      // ],),

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DropPayment()));
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
}
