// ignore_for_file: prefer_final_fields, file_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/self_pickup_data.dart';
import 'UploadHelmetImg.dart';

class UploadVehicleImg extends StatefulWidget {
  const UploadVehicleImg({Key? key}) : super(key: key);

  @override
  State<UploadVehicleImg> createState() => _UploadVehicleImgState();
}

class _UploadVehicleImgState extends State<UploadVehicleImg> {
  XFile? _pickfront;
  XFile? _pickback;
  XFile? _pickleft;
  XFile? _pickright;
  XFile? _pickwithCustomer;
  XFile? _pickfuelMeter;

  var _kmReading = TextEditingController();

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
                            "Pickup Details",
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
                                                              Text("Gallery",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickfront =
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
                                                              Text("Camera",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickfront =
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
                                      child: _pickfront == null
                                          ? Image.asset(
                                              "assets/images/Bike Front.png")
                                          : Image.file(
                                              File(_pickfront!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Front",
                                  style: TextStyle(fontSize: 14 / scaleFactor))
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
                                                          fontSize: 14 /
                                                              scaleFactor)),
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
                                                              Text("Gallery",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickback = await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .gallery);
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
                                                              Text("Camera",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickback = await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .camera);
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
                                      child: _pickback == null
                                          ? Image.asset(
                                              "assets/images/Bike Back.png")
                                          : Image.file(File(_pickback!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("back",
                                  style: TextStyle(fontSize: 14 / scaleFactor))
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
                                                          fontSize: 14 /
                                                              scaleFactor)),
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
                                                              Text("Gallery",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickleft = await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .gallery);
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
                                                              Text("Camera",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickleft = await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .camera);
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
                                      child: _pickleft == null
                                          ? Image.asset(
                                              "assets/images/Bike Right.png")
                                          : Image.file(File(_pickleft!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Right",
                                  style: TextStyle(fontSize: 14 / scaleFactor))
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
                                                          fontSize: 14 /
                                                              scaleFactor)),
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
                                                              Text("Gallery",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickright =
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
                                                              Text("Camera",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickright =
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
                                      child: _pickright == null
                                          ? Image.asset(
                                              "assets/images/Bike Left .png")
                                          : Image.file(
                                              File(_pickright!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Left",
                                  style: TextStyle(fontSize: 14 / scaleFactor))
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
                                                          fontSize: 14 /
                                                              scaleFactor)),
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
                                                              Text("Gallery",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickwithCustomer =
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
                                                              Text("Camera",
                                                                  style: TextStyle(
                                                                      fontSize: 14 /
                                                                          scaleFactor)),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            _pickwithCustomer =
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
                                      child: _pickwithCustomer == null
                                          ? Image.asset(
                                              "assets/images/bike meter.png")
                                          : Image.file(
                                              File(_pickwithCustomer!.path)))),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Photo Meter",
                                  style: TextStyle(fontSize: 14 / scaleFactor))
                            ],
                          ),
                          // Column(
                          //   children: [
                          //     Container(
                          //         padding:EdgeInsets.all(10),
                          //         decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 0.5),borderRadius: BorderRadius.all(Radius.circular(10))),
                          //         height: 100,width: 100,
                          //         child:GestureDetector(
                          //             onTap: (){
                          //               showDialog(
                          //                   context: context,
                          //                   builder: (BuildContext build) {
                          //                     return AlertDialog(
                          //                         title: Text("From where do you want to take the photo?"),
                          //                         content: SingleChildScrollView(
                          //                           child: ListBody(
                          //                             children: <Widget>[
                          //                               GestureDetector(
                          //                                 child: Row(
                          //                                   children: [
                          //                                     Icon(Icons.photo,size: 40,),
                          //                                     SizedBox(width: 10,),
                          //
                          //                                     Text("Gallery"),
                          //
                          //                                   ],
                          //                                 ),
                          //                                 onTap: () async {
                          //
                          //                                   _pickfuelMeter= await ImagePicker().pickImage(source: ImageSource.gallery);
                          //                                   setState((){});
                          //                                   Navigator.pop(build);
                          //                                 },
                          //                               ),
                          //                               Padding(padding: EdgeInsets.all(8.0)),
                          //                               GestureDetector(
                          //                                 child:  Row(
                          //                                   children: [
                          //                                     Icon(Icons.camera_alt,size: 40,),
                          //                                     SizedBox(width: 10,),
                          //
                          //                                     Text("Camera"),
                          //
                          //                                   ],
                          //                                 ),
                          //                                 onTap: () async {
                          //                                   _pickfuelMeter= await ImagePicker().pickImage(source: ImageSource.camera);
                          //                                   setState((){});
                          //                                   Navigator.pop(build);
                          //
                          //                                 },
                          //                               )
                          //                             ],
                          //                           ),
                          //                         )
                          //                     );
                          //                   });
                          //
                          //             },
                          //             child:_pickfuelMeter==null? Image.asset("assets/images/Selfie WIth Bike.png"):Image.file(File(_pickfuelMeter!.path))
                          //
                          //
                          //         )),
                          //     SizedBox(height: 8,),
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
                                keyboardType: TextInputType.number,
                                controller: _kmReading,
                                textAlign: TextAlign.center,
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
                  SelfPickupData.kmAtPickup = _kmReading.text;
                  SelfPickupData.left = _pickleft;
                  SelfPickupData.right = _pickright;
                  SelfPickupData.front = _pickfront;
                  SelfPickupData.back = _pickback;
                  SelfPickupData.fuelMeter = _pickfuelMeter;
                  SelfPickupData.withCustomer = _pickwithCustomer;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadHelmetImg()));
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

  // Future<XFile> selectImage() {
  //   XFile? image;
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //             title: const Text("From where do you want to take the photo?"),
  //             content: SingleChildScrollView(
  //               child: ListBody(
  //                 children: <Widget>[
  //                   GestureDetector(
  //                     child: const Text("Gallery"),
  //                     onTap: () async {
  //                       image = await ImagePicker()
  //                           .pickImage(source: ImageSource.gallery);
  //                     },
  //                   ),
  //                   const Padding(padding: EdgeInsets.all(8.0)),
  //                   GestureDetector(
  //                     child: const Text("Camera"),
  //                     onTap: () async {
  //                       image = await ImagePicker()
  //                           .pickImage(source: ImageSource.camera);
  //                     },
  //                   )
  //                 ],
  //               ),
  //             ));
  //       });
  //   return Future.value(image);
  // }
}
