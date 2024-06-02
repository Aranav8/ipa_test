// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridobiko/controllers/bookings/booking_controller.dart';

import '../../data/BookingData.dart';
import '../../data/BookingFlow.dart';
import '../../data/self_pickup_data.dart';

class UploadHelmetImg extends ConsumerStatefulWidget {
  const UploadHelmetImg({Key? key}) : super(key: key);

  @override
  ConsumerState<UploadHelmetImg> createState() => _UploadHelmetImgState();
}

class _UploadHelmetImgState extends ConsumerState<UploadHelmetImg> {
  int _count = 1;
  BookingData data = BookingFlow.selectedBooking!;
  void _incrementCount() {
    if (_count == 0 || _count == 1) {
      setState(() {
        _count++;
      });
    }
  }

  void _decrementCount() {
    if (_count == 2) {
      setState(() {
        _count--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    bool _pb = ref.watch(bookingControllerProvider);

    return Scaffold(
      floatingActionButton: _pb ? const CircularProgressIndicator() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
          elevation: 0,
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
                            "Pickup Details",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18 / scaleFactor),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Number Of Helmet :",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.grey,
                                fontSize: 15 / scaleFactor),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.grey[200]),
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: _decrementCount,
                                    child: const Icon(Icons.remove)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "$_count",
                                  style: TextStyle(fontSize: 14 / scaleFactor),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: _incrementCount,
                                    child: const Icon(Icons.add)),
                              ],
                            ),
                          ),
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
                                                          14 / scaleFactor)),
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
                                                          Text("Gallery",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor)),
                                                        ],
                                                      ),
                                                      onTap: () async {
                                                        SelfPickupData
                                                                .pickhelmentfront =
                                                            await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .gallery);
                                                        setState(() {});
                                                        Navigator.pop(build);
                                                      },
                                                    ),
                                                    const Padding(
                                                        padding: EdgeInsets.all(
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
                                                          Text("Camera",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor)),
                                                        ],
                                                      ),
                                                      onTap: () async {
                                                        SelfPickupData
                                                                .pickhelmentfront =
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
                                  child: SelfPickupData.pickhelmentfront == null
                                      ? Image.asset(
                                          "assets/images/Helmet Outside.png",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.file(
                                          File(SelfPickupData
                                              .pickhelmentfront!.path),
                                        ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Top",
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
                                                      fontSize:
                                                          14 / scaleFactor)),
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
                                                          Text("Gallery",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor)),
                                                        ],
                                                      ),
                                                      onTap: () async {
                                                        SelfPickupData
                                                                .pickhelmentback =
                                                            await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .gallery);
                                                        setState(() {});
                                                        Navigator.pop(build);
                                                      },
                                                    ),
                                                    const Padding(
                                                        padding: EdgeInsets.all(
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
                                                          Text("Camera",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor)),
                                                        ],
                                                      ),
                                                      onTap: () async {
                                                        SelfPickupData
                                                                .pickhelmentback =
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
                                  child: SelfPickupData.pickhelmentback == null
                                      ? Image.asset(
                                          "assets/images/Helmet Inside.png",
                                          fit: BoxFit.contain,
                                        )
                                      : Image.file(
                                          File(SelfPickupData
                                              .pickhelmentback!.path),
                                        ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Bottom ",
                                  style: TextStyle(fontSize: 14 / scaleFactor))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: _count == 2,
                        child: Row(
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
                                                          child: Text("Gallery",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor)),
                                                          onTap: () async {
                                                            SelfPickupData
                                                                    .pickhelmentleft =
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
                                                          child: Text("Camera",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor)),
                                                          onTap: () async {
                                                            SelfPickupData
                                                                    .pickhelmentleft =
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
                                      child:
                                          SelfPickupData.pickhelmentleft == null
                                              ? Image.asset(
                                                  "assets/images/Helmet Outside.png",
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.file(
                                                  File(SelfPickupData
                                                      .pickhelmentleft!.path),
                                                ),
                                    )),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text("Top",
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor))
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
                                                          child: Text("Gallery",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor)),
                                                          onTap: () async {
                                                            SelfPickupData
                                                                    .pickhelmentright =
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
                                                          child: Text("Camera",
                                                              style: TextStyle(
                                                                  fontSize: 14 /
                                                                      scaleFactor)),
                                                          onTap: () async {
                                                            SelfPickupData
                                                                    .pickhelmentright =
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
                                      child: SelfPickupData.pickhelmentright ==
                                              null
                                          ? Image.asset(
                                              "assets/images/Helmet Inside.png",
                                              fit: BoxFit.contain,
                                            )
                                          : Image.file(
                                              File(SelfPickupData
                                                  .pickhelmentright!.path),
                                            ),
                                    )),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text("Bottom",
                                    style:
                                        TextStyle(fontSize: 14 / scaleFactor))
                              ],
                            ),
                          ],
                        ),
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
                  _updateDataBase();
                  // SelfPickupData.fuelAtPickup=txt.text;
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelfPickup()));
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
                            "Proceed Self Pickup",
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

  Future<void> _updateDataBase() async {
    await ref
        .read(bookingControllerProvider.notifier)
        .setSelfPickup(context, data, _count);

    // String token = ref.read(userProvider)!.token!;

    // var headers = {'token': token};
    // var request = http.MultipartRequest(
    //     'POST',
    //     Uri.parse(
    //         '${Constants().url}android_app_customer/api/setSelfPickup.php'));

    // request.fields.addAll({
    //   'order_id': data.transId!,
    //   'no_of_helmets': _count.toString(),
    //   'KM_meter_pickup': SelfPickupData.kmAtPickup!,
    //   'destination': data.tripDetails!.destination!,
    //   'purpose': data.tripDetails!.purpose!,
    //   'id_collected': data.tripDetails!.idCollected!,
    //   'fuel_meter_reading': SelfPickupData.kmAtPickup!,
    // });
    // request.files.add(await http.MultipartFile.fromPath('bike_left',
    //     SelfPickupData.left == null ? "" : SelfPickupData.left!.path));
    // request.files.add(await http.MultipartFile.fromPath('bike_right',
    //     SelfPickupData.right == null ? "" : SelfPickupData.right!.path));
    // request.files.add(await http.MultipartFile.fromPath('bike_front',
    //     SelfPickupData.front == null ? "" : SelfPickupData.front!.path));
    // request.files.add(await http.MultipartFile.fromPath('bike_back',
    //     SelfPickupData.back == null ? "" : SelfPickupData.back!.path));
    // request.files.add(await http.MultipartFile.fromPath(
    //     'bike_with_customer',
    //     SelfPickupData.withCustomer == null
    //         ? ""
    //         : SelfPickupData.withCustomer!.path));
    // request.files.add(await http.MultipartFile.fromPath(
    //     'bike_fuel_meter',
    //     SelfPickupData.fuelMeter == null
    //         ? ""
    //         : SelfPickupData.fuelMeter!.path));
    // request.files.add(await http.MultipartFile.fromPath(
    //     'helmet_front_1',
    //     SelfPickupData.pickhelmentfront == null
    //         ? ""
    //         : SelfPickupData.pickhelmentfront!.path));
    // request.files.add(await http.MultipartFile.fromPath(
    //     'helmet_back_1',
    //     SelfPickupData.pickhelmentback == null
    //         ? ""
    //         : SelfPickupData.pickhelmentback!.path));
    // if (_count == 2) {
    //   request.files.add(await http.MultipartFile.fromPath(
    //       'helmet_front_2',
    //       SelfPickupData.pickhelmentleft == null
    //           ? ""
    //           : SelfPickupData.pickhelmentleft!.path));
    //   request.files.add(await http.MultipartFile.fromPath(
    //       'helmet_back_2',
    //       SelfPickupData.pickhelmentright == null
    //           ? ""
    //           : SelfPickupData.pickhelmentright!.path));
    // }
    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();
    // setState(() {
    //   _pb = false;
    // });

    // if (response.statusCode == 200) {
    //   var res = jsonDecode(await response.stream.bytesToString());
    //   if (res['success']) {
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(builder: (builder) => const MyHomePage()),
    //         (route) => false);
    //   }
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text(res['message'])));
    // } else {
    //   //print(response.reasonPhrase);
    // }
  }
}
