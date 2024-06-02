// ignore_for_file: camel_case_types, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:ridobiko/data/BookingData.dart';
import 'package:ridobiko/data/BookingFlow.dart';

class ViewImgaes extends StatefulWidget {
  const ViewImgaes({super.key});

  @override
  State<StatefulWidget> createState() {
    return viewImages();
  }
}

class viewImages extends State {
  late BookingData data;
  @override
  void initState() {
    data = BookingFlow.selectedBooking!;
    data.tripPictures ??= TripPictures.fromJson(jsonDecode('{}'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Uploaded Images",
          style: TextStyle(
              fontSize: 14 / scaleFactor,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(139, 0, 0, 1),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(10),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
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
                          FullScreenWidget(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: data.tripPictures!.bikeFront == ""
                                      ? Image.asset(
                                          "assets/images/defaultimage.jpg",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          data.tripPictures!.bikeFront!,
                                          fit: BoxFit.contain,
                                        ))),
                          FullScreenWidget(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: data.tripPictures!.bikeBack == ""
                                      ? Image.asset(
                                          "assets/images/defaultimage.jpg",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          data.tripPictures!.bikeBack!,
                                          fit: BoxFit.contain,
                                        ))),
                          FullScreenWidget(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: data.tripPictures!.bikeLeft == ""
                                      ? Image.asset(
                                          "assets/images/defaultimage.jpg",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          data.tripPictures!.bikeLeft!,
                                          fit: BoxFit.contain,
                                        ))),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FullScreenWidget(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: data.tripPictures!.bikeRight == ""
                                      ? Image.asset(
                                          "assets/images/defaultimage.jpg",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          data.tripPictures!.bikeRight!,
                                          fit: BoxFit.contain,
                                        ))),
                          FullScreenWidget(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: data.tripPictures!.bikeFuelMeter == ""
                                      ? Image.asset(
                                          "assets/images/defaultimage.jpg",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          data.tripPictures!.bikeFuelMeter!,
                                          fit: BoxFit.contain,
                                        ))),
                          FullScreenWidget(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: data.tripPictures!.bikeWithCustomer ==
                                          ""
                                      ? Image.asset(
                                          "assets/images/defaultimage.jpg",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          data.tripPictures!.bikeWithCustomer!,
                                          fit: BoxFit.contain,
                                        ))),
                        ],
                      ),
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
                          FullScreenWidget(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: data.tripPictures!.helmetFront1 == ""
                                      ? Image.asset(
                                          "assets/images/defaultimage.jpg",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          data.tripPictures!.helmetFront1!,
                                          fit: BoxFit.contain,
                                        ))),
                          FullScreenWidget(
                              child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: data.tripPictures!.helmetBack1 == ""
                                      ? Image.asset(
                                          "assets/images/defaultimage.jpg",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          data.tripPictures!.helmetBack1!,
                                          fit: BoxFit.contain,
                                        ))),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: data.tripDetails!.noOfHelmets == '2',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: data.tripPictures!.helmetFront2 == ""
                                        ? Image.asset(
                                            "assets/images/defaultimage.jpg",
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            data.tripPictures!.helmetFront2!,
                                            fit: BoxFit.contain,
                                          ))),
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: data.tripPictures!.helmetBack2 == ""
                                        ? Image.asset(
                                            "assets/images/defaultimage.jpg",
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            data.tripPictures!.helmetBack2!,
                                            fit: BoxFit.contain,
                                          ))),
                          ],
                        ),
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
                            padding: const EdgeInsets.only(
                                right: 30, left: 30, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(data.tripDetails!.kMMeterPickup!,
                                  style: TextStyle(fontSize: 14 / scaleFactor)),
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
              Visibility(
                visible: data.tripPictures!.isExchanged == "1",
                child: Card(
                  margin: const EdgeInsets.all(10),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Exchange  Details",
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
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child:
                                        data.tripPictures!.exchangedBikeFront ==
                                                ""
                                            ? Image.asset(
                                                "assets/images/defaultimage.jpg",
                                                fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                data.tripPictures!
                                                    .exchangedBikeFront!,
                                                fit: BoxFit.contain,
                                              ))),
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child:
                                        data.tripPictures!.exchangedBikeBack ==
                                                ""
                                            ? Image.asset(
                                                "assets/images/defaultimage.jpg",
                                                fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                data.tripPictures!
                                                    .exchangedBikeBack!,
                                                fit: BoxFit.contain,
                                              ))),
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child:
                                        data.tripPictures!.exchangedBikeLeft ==
                                                ""
                                            ? Image.asset(
                                                "assets/images/defaultimage.jpg",
                                                fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                data.tripPictures!
                                                    .exchangedBikeLeft!,
                                                fit: BoxFit.contain,
                                              ))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child:
                                        data.tripPictures!.exchangedBikeRight ==
                                                ""
                                            ? Image.asset(
                                                "assets/images/defaultimage.jpg",
                                                fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                data.tripPictures!
                                                    .exchangedBikeRight!,
                                                fit: BoxFit.contain,
                                              ))),
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child:
                                        data.tripPictures!.exchangedBikeFuel ==
                                                ""
                                            ? Image.asset(
                                                "assets/images/defaultimage.jpg",
                                                fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                data.tripPictures!
                                                    .exchangedBikeFuel!,
                                                fit: BoxFit.contain,
                                              ))),
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: data.tripPictures!
                                                .exchangedBikeWithCustomer ==
                                            ""
                                        ? Image.asset(
                                            "assets/images/defaultimage.jpg",
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            data.tripPictures!
                                                .exchangedBikeWithCustomer!,
                                            fit: BoxFit.contain,
                                          ))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: !data.tripPictures!.bikeFrontDrop!.contains('default'),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey, width: 0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
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
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: data.tripPictures!.bikeFrontDrop ==
                                            ""
                                        ? Image.asset(
                                            "assets/images/defaultimage.jpg",
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            data.tripPictures!.bikeFrontDrop!,
                                            fit: BoxFit.contain,
                                          ))),
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: data.tripPictures!.bikeBackDrop == ""
                                        ? Image.asset(
                                            "assets/images/defaultimage.jpg",
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            data.tripPictures!.bikeBackDrop!,
                                            fit: BoxFit.contain,
                                          ))),
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: data.tripPictures!.bikeLeftDrop == ""
                                        ? Image.asset(
                                            "assets/images/defaultimage.jpg",
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            data.tripPictures!.bikeLeftDrop!,
                                            fit: BoxFit.contain,
                                          ))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: data.tripPictures!.bikeRightDrop ==
                                            ""
                                        ? Image.asset(
                                            "assets/images/defaultimage.jpg",
                                            fit: BoxFit.contain,
                                          )
                                        : Image.network(
                                            data.tripPictures!.bikeRightDrop!,
                                            fit: BoxFit.contain,
                                          ))),
                            FullScreenWidget(
                                child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child:
                                        data.tripPictures!.bikeFuelMeterDrop ==
                                                ""
                                            ? Image.asset(
                                                "assets/images/defaultimage.jpg",
                                                fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                data.tripPictures!
                                                    .bikeFuelMeterDrop!,
                                                fit: BoxFit.contain,
                                              ))),
                            // FullScreenWidget(child: Container(height: 100,width: 100,child: Image.network("assets/images/img.png", fit:BoxFit.contain,))),
                          ],
                        ),
                        // SizedBox(height: 10,),
                        //
                        // Align(alignment:Alignment.centerLeft,child: Text("Helmet Images:" ,style: TextStyle(decoration:TextDecoration.underline,color: Colors.grey, fontSize: 15),)),
                        // SizedBox(height: 10,),
                        // Row( mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                        //   FullScreenWidget(child: Container(height: 100,width: 100,child: Image.network(data.tripPictures!.helmetBack2!, fit:BoxFit.contain,))),
                        //   FullScreenWidget(child: Container(height: 100,width: 100,child: Image.network("assets/images/img.png", fit:BoxFit.contain,))),
                        //
                        // ],),
                        // SizedBox(height: 10,),
                        //
                        // Row( mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                        //   FullScreenWidget(child: Container(height: 100,width: 100,child: Image.network("assets/images/img.png", fit:BoxFit.contain,))),
                        //   FullScreenWidget(child: Container(height: 100,width: 100,child: Image.network("assets/images/img.png", fit:BoxFit.contain,))),
                        //
                        // ],),
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
                              padding: const EdgeInsets.only(
                                  right: 30, left: 30, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(data.tripDetails!.kMMeterDrop!,
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor)),
                              ),
                            ),
                          ],
                        ),
                      ],
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
